import 'dart:async';
import 'dart:convert';
// import 'package:alarm/alarm.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/ui/bibleplanselect.dart';
import 'package:mivdevotional/ui/home/cmenu.dart';
import 'package:mivdevotional/ui/home/notification.dart';
import 'package:mivdevotional/ui/home/word_clinic_today.dart';
import 'package:collection/collection.dart';
import 'package:mivdevotional/utils/snack.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyBiblePage2 extends StatefulWidget {
  @override
  _DailyBiblePage2State createState() => _DailyBiblePage2State();
}

class _DailyBiblePage2State extends State<DailyBiblePage2> {
  final GlobalKey<CircularMenuState> circularMenuKey =
      GlobalKey<CircularMenuState>();
  List<Bible>? bibleData;
  List<dynamic>? readingPlan;
  int completedDays = 0;
  late ScrollController _scrollController;
  var today;
  // AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  void initState() {
    today = DateTime.now();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
    getPrefBibleVersion();

    getDay(DateTime.now());
    loadResources();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    print('hasdfasdfasdfasdfsdfrer yuer');
    Timer.periodic(Duration(milliseconds: 500), ((e) {
      print('herer yuer');

      showPrompt();
      e.cancel();
    }));
    super.didChangeDependencies();
  }

  showPrompt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('prompt')) {
    bool showChoice = prefs.getBool('showChoice') ?? true;
    if (showChoice) {
      Navigator.push(
              context, MaterialPageRoute(builder: (_) => Bibleplanselect()))
          .then((e) {
        if (e != null) {
          showsnack(context, Colors.green, '${e} plan selected');
        }
        loadResources();
        setState(() {});
      });
      // }
    }
  }

  String selection = 'KJV';
  bool prefBibleDone = false;

  getPrefBibleVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//
    if (prefs.containsKey('prefBible')) {
      selection = prefs.getString('prefBible').toString();
      prefBibleDone = true;
      // print(jsonDecode(selection));
      selection = jsonDecode(selection);
      print('selection $selection');
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the ScrollController
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('Scrolled to the last item!');
        markAsCompleted();
        // Add your logic here when the user reaches the last item
      }
    }
    // if (isScrolledToTop(_scrollController)) {
    //   top = true;

    //   print("The screen is scrolled to the top.");
    // }
    // if (hasScrolledDown(_scrollController, 100.0)) {
    // top = false;

    //   print("Scrolled more than 100 pixels down from the top.");
    // }
  }

  bool isScrolledToTop(ScrollController scrollController) {
    return scrollController.offset <= 0;
  }

  bool hasScrolledDown(ScrollController scrollController, double threshold) {
    return scrollController.offset > threshold;
  }

  // void toggleAudio() async {
  //   if (isPlaying) {
  //     await audioPlayer?.stop();
  //     setState(() {
  //       isPlaying = false;
  //     });
  //   } else {
  //     final result =
  //         await audioPlayer?.play(AssetSource('audio/background_song.mp3'));
  //     if (result == PlayerState.playing) {
  //       setState(() {
  //         isPlaying = true;
  //       });
  //     }
  //   }
  // }
  var theme;
  bool top = false;
  bool middle = false;
  DateTime selectedDate = DateTime.now();
  Map<String, String>? readingsForSelectedDay;
  Map<DateTime, bool> progressMap = {};
  Future<void> loadResources() async {
    bibleData = await loadBibleData();
    final planData =
        await rootBundle.loadString('assets/bibleJson/allreaddynamic.json');
    final planDataAll =
        await rootBundle.loadString('assets/bibleJson/allreadingplan.json');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String plan = prefs.getString('plan') ?? '';
    if (plan.isNotEmpty && plan == 'Thematic') {
      readingPlan = json.decode(planData);
    } else {
      readingPlan = json.decode(planDataAll);
    }

    // Load progress
    setState(() {
      completedDays = prefs.getInt('completedDays') ?? 0;
      final progress = prefs.getString('progressMap');
      if (progress != null) {
        progressMap = Map<DateTime, bool>.from(json.decode(progress).map(
              (key, value) => MapEntry(DateTime.parse(key), value),
            ));
        print('progress map $progressMap');
      }
    });
  }

  void updateReadingsForSelectedDay() {
    // setState(() {
    //   int day = selectedDate.day;
    //   readingsForSelectedDay = dailyReadings[day];
    // });
  }

  // Future<void> markAsCompleted(DateTime date) async {
  Future<void> markAsCompleted() async {
    // DateTime date = DateTime.now();
    DateTime currentDay = DateTime(today.year, today.month, today.day);

    print('currentday=$currentDay'); // Normalize to midnight
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (currentDay == DateTime(today.year, 12, 31)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConfettiSample()));
    }
    // Check if the current day is already marked as completed
    if (progressMap.containsKey(currentDay) &&
        progressMap[currentDay] == true) {
      print('Day already marked as completed: $currentDay');
      return; // Exit the function early if already marked
    }

    setState(() {
      completedDays += 1;
      progressMap[currentDay] = true;
    });

    await prefs.setInt('completedDays', completedDays);
    await prefs.setString(
      'progressMap',
      json.encode(progressMap.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      )),
    );

    print('Marked as completed: $currentDay');
  }

  int calculateMissedDays(Map<DateTime, bool> progressMap) {
    DateTime today = DateTime.now();
    // DateTime today = DateTime(2024,12,31);
    DateTime startDate = DateTime(today.year, 1, 1);
    int missedDays = 0;

    for (DateTime date = startDate;
        date.isBefore(today) || date.isAtSameMomentAs(today);
        date = date.add(Duration(days: 1))) {
      // print(date);
      if (progressMap[date] != true) {
        missedDays++;
      }
    }

    return missedDays;
  }

  getNoOfVersesInChapter(List<Bible> bibleData, String reading, chapter) {
    if (chapter == null) return 0;
    int no = 0;
    final List<Bible> selectedVerses = [];
    final regex = RegExp(r'(\d?\s?[A-Za-z]+)\s+((\d+)(:\d+)?(-\d+(:\d+)?)?)');
    final matches = regex.allMatches(reading);
    for (final match in matches) {
      final bookName = match.group(1)?.trim() ?? '';
      for (var entry in bibleData) {
        if (entry.book == bookName && entry.chapter == chapter) {
          no++;
          print('verses = $no');
        }
      }
    }
    return no;
  }

  Future<List<Bible>> loadBibleData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
//
    if (prefs.containsKey('prefBible')) {
      selection = prefs.getString('prefBible').toString();
      prefBibleDone = true;
      // print(jsonDecode(selection));
      selection = jsonDecode(selection);
      print('selection $selection');
      if (mounted) setState(() {});
    }
    print('see selection $selection');
    if (selection == 'KJV') {
      final data = await rootBundle.loadString('assets/bibleJson/bible.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'AMP') {
      final data =
          await rootBundle.loadString('assets/bibleJson/amplified.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'DBY') {
      final data = await rootBundle.loadString('assets/bibleJson/dby.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'MSG') {
      final data =
          await rootBundle.loadString('assets/bibleJson/msgBible.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'BBE') {
      final data = await rootBundle.loadString('assets/bibleJson/bbe.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'BISHOP') {
      final data = await rootBundle.loadString('assets/bibleJson/bishop.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'RSV') {
      final data = await rootBundle.loadString('assets/bibleJson/rsv.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'NIV') {
      final data = await rootBundle.loadString('assets/bibleJson/niv.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else if (selection == 'NLT') {
      final data = await rootBundle.loadString('assets/bibleJson/nlt.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    } else {
      final data = await rootBundle.loadString('assets/bibleJson/asv.json');
      final jsonData = json.decode(data) as List<dynamic>;
      return jsonData.map((entry) => Bible.fromJson(entry)).toList();
    }
  }

  // Function to extract verses based on reading format
  List<Bible> getVerses(List<Bible> bibleData, String reading) {
    // print(reading);
    final List<Bible> selectedVerses = [];
    final regex = RegExp(r'(\d?\s?[A-Za-z]+)\s+((\d+)(:\d+)?(-\d+(:\d+)?)?)');
    final matches = regex.allMatches(reading);
    for (final match in matches) {
      final bookName = match.group(1)?.trim() ?? '';
      final range = match.group(2) ?? '';
      final parts = range.split('-');
      // print(bookName);
      // print('range $range');
      // print('parts $parts');
      // print('_____');
      bool isChaptersOnly = false;
      final start = parts[0];
      final end = parts.length > 1 ? parts[1] : null;

      final startChapter = int.parse(start.split(':')[0]);
      final startVerse =
          start.contains(':') ? int.parse(start.split(':')[1]) : null;
      final endChapter = (range.contains('-') && !range.contains(':'))
          ? int.parse(range.split('-')[1])
          : null;
      isChaptersOnly = endChapter != null ? true : false;
      final endVerse = (range!.contains(':') && range!.contains('-'))
          ? int.parse(range.split('-')[1])
          : null;
      // print('start $start');
      // print('end $end');
      // print('startChapter $startChapter');
      // print('startVerse $startVerse');
      // print('endChapter $endChapter');
      // print('endVerse $endVerse');

      // print('++++++++++++++');
      for (var entry in bibleData) {
        if (entry.book == bookName) {
          if (entry.chapter == startChapter &&
              startVerse != null &&
              entry.verse >= startVerse &&
              endVerse != null &&
              entry.verse <= endVerse) {
            selectedVerses.add(entry);
          } else if (end == null &&
              startVerse == null &&
              endChapter == null &&
              endVerse == null &&
              entry.chapter == startChapter) {
            selectedVerses.add(entry);
          } else if (isChaptersOnly &&
              entry.chapter >= startChapter &&
              (endChapter == null || entry.chapter <= endChapter)) {
            selectedVerses.add(entry);
          }
        }
      }
    }
    return selectedVerses;
  }

  startNo(List<Bible> bibleData, String reading) {
    Map<String, dynamic> data = {};
    final List<Bible> selectedVerses = [];
    final regex = RegExp(r'(\d?\s?[A-Za-z]+)\s+((\d+)(:\d+)?(-\d+(:\d+)?)?)');
    final matches = regex.allMatches(reading);
    for (final match in matches) {
      final bookName = match.group(1)?.trim() ?? '';
      final range = match.group(2) ?? '';
      final parts = range.split('-');
      // print(bookName);
      // print('range $range');
      // print('parts $parts');
      // print('_____');
      bool isChaptersOnly = false;
      final start = parts[0];
      final end = parts.length > 1 ? parts[1] : null;

      final startChapter = int.parse(start.split(':')[0]);
      final startVerse =
          start.contains(':') ? int.parse(start.split(':')[1]) : null;
      final endChapter = (range.contains('-') && !range.contains(':'))
          ? int.parse(range.split('-')[1])
          : null;
      final startChapterForOnlyChapterRead =
          (range.contains('-') && !range.contains(':'))
              ? int.parse(range.split('-')[0])
              : null;
      isChaptersOnly = endChapter != null ? true : false;
      final endVerse = (range.contains(':') && range.contains('-'))
          ? int.parse(range.split('-')[1])
          : null;
      // print('start $start');
      // print('end $end');
      // print('startChapter $startChapter');
      // print('startVerse $startVerse');
      // print('endChapter $endChapter');
      // print('endVerse $endVerse');

      data = {
        'startVerse': startVerse,
        'endChapter': endChapter,
        'endVerse': endVerse,
        'isChaptersOnly': isChaptersOnly,
        'startChapterForOnlyChapterRead': startChapterForOnlyChapterRead,
        'noOfVersesInStartChapter': getNoOfVersesInChapter(
            bibleData, reading, startChapterForOnlyChapterRead)
      };
      print(data);
    }
    return data;
  }

  Map<String, dynamic>? getDailyReadings(
      List<dynamic> readingPlan, DateTime date) {
    // Calculate the day of the year
    int dayOfYear = int.parse(DateFormat("D").format(date));

    // Find and return the reading plan for the specific day
    return readingPlan.firstWhere(
      (plan) => plan['day'] == dayOfYear,
      orElse: () => null,
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Return a list if the day is marked as completed
    if (progressMap[DateTime(day.year, day.month, day.day)] == true) {
      return ["Completed"];
    }
    return [];
  }

  ///my edit
  int day = 0;

  getDay(DateTime today) {
    day = today.day;
  }

  bool _isMissedDay(DateTime day) {
    DateTime today = DateTime.now();
    // Mark as missed if the day is before today and not in the progress map
    return day.isBefore(today) &&
        progressMap[DateTime(day.year, day.month, day.day)] != true;
  }

  bool _isCompletedDay(DateTime day) {
    // Mark as completed if it's in the progress map and true
    return progressMap[DateTime(day.year, day.month, day.day)] == true;
  }

  @override
  Widget build(BuildContext context) {
    // final day = today.day;
    print('today =$today');
    final dayPlan = getDailyReadings(readingPlan ?? [], today);

    if (bibleData == null || dayPlan == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Daily Bible Readings'),
        ),
        body: Center(child: Text('No data for the day available')),
      );
    }

    final readings = <String, Map<String, dynamic>>{};
    dayPlan['readings'].forEach((key, value) {
      print('---------');
      theme = dayPlan['theme'] ?? '';
      print(dayPlan['theme']);
      readings[key] = {
        // 'theme': theme,
        'startNo': startNo(bibleData!, value),
        'reference': value,
        'verses': getVerses(bibleData!, value),
      };
    });
    final missedDays = calculateMissedDays(progressMap);
    print(missedDays);
    return Scaffold(
      floatingActionButton: CircularMenu(
        toggleButtonSize: 27,
        radius: 140,
        toggleButtonOnPressed: () {
          print('object');
        },
        alignment: Alignment.bottomRight,
        toggleButtonColor: Colors.pink.withOpacity(.2),
        toggleButtonAnimatedIconData: AnimatedIcons.menu_home,
        key: circularMenuKey,
        items: [
          CircularMenuItem(
              iconSize: 25,
              icon: Icons.home,
              color: Colors.green,
              onTap: () {
                circularMenuKey.currentState?.reverseAnimation();
              }),
          // CircularMenuItem(
          //     icon: Icons.search,
          //     color: Colors.blue,
          //     onTap: () {
          //       setState(() {
          //         // _color = Colors.blue;
          //         // _colorName = 'Blue';
          //       });
          //     }),
          CircularMenuItem(
              iconSize: 25,
              icon: Icons.settings,
              color: Colors.orange,
              onTap: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Bibleplanselect()))
                    .then((e) {
                  if (e != null) {
                    showsnack(context, Colors.green, '${e} plan selected');
                  }
                  loadResources();
                  setState(() {});
                });
                circularMenuKey.currentState?.reverseAnimation();
              }),

          CircularMenuItem(
              iconSize: 25,
              icon: Icons.notifications,
              color: Colors.brown,
              onTap: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ReminderScreen()))
                    .then((onValue) =>
                        circularMenuKey.currentState?.reverseAnimation());
              }),
          CircularMenuItem(
              iconSize: 25,
              icon: Icons.calendar_month,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TableCalendarScreen())).then((e) {
                  if (e != null) {
                    print('eeeee');
                    print(e);
                    today = e;
                    setState(() {});
                  }
                });

                circularMenuKey.currentState?.reverseAnimation();
              }),
        ],
      ),
      // appBar: AppBar(
      //   title: Text('Daily Bible Readings $day'),
      //   // actions: [
      //   //   ElevatedButton(
      //   //       onPressed: () {
      //   //         markAsCompleted();
      //   //       },
      //   //       child: Text('mark complte'))
      //   // ],
      // ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            centerTitle: true,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.5,
              centerTitle: true, // Centers the title in the middle of the image
              title: Text(
                'Daily Bible Reading (Day ${int.parse(DateFormat("D").format(today))})',
                style: TextStyle(
                  color: Colors
                      .white, // Text color to make it visible on the image
                  fontSize: 18, // Adjust font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Ensures the text is centered
              ),
              background: Image.asset(
                'assets/images/biblereading.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: LinearProgressIndicator(
                          value: (completedDays / (readingPlan?.length ?? 1))
                              .clamp(0.0, 1.0),
                          backgroundColor: Colors.green[100],
                          color: Colors.blue,
                          minHeight: 8,
                        ),
                      ),
                      Lottie.asset(
                          'assets/images/Animation - 1735562095675.json',
                          width: 30,
                          height: 30)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        // '$completedDays / ${readingPlan?.length ?? 0} days completed ||',
                        '$completedDays / 365 days completed',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${calculateMissedDays(progressMap)} missed days',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => TableCalendarScreen()))
                                .then((e) {
                              if (e != null) {
                                print('eeeee');
                                print(e);
                                today = e;

                                setState(() {});
                              }
                            });

                            circularMenuKey.currentState?.reverseAnimation();
                          },
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                  if (theme.toString().isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          'Theme: ${theme}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = readings.entries.elementAt(index);
                final category = entry.key.replaceAll('_', ' ').toUpperCase();
                final reference = entry.value['reference'] as String;
                final verses = entry.value['verses'] as List<Bible>;
                final versesText = verses.map((verse) {
                  return "${verse.verse}. ${verse.text}";
                }).join('\n');

                return GestureDetector(
                  onTap: () {
                    circularMenuKey.currentState?.reverseAnimation();
                  },
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          reference,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      versesText,
                      style: TextStyle(fontSize: 18, height: 1.6),
                    ),
                  ),
                );
              },
              childCount: readings.length,
            ),
          ),
        ],
      ),
    );
  }
}

class TableCalendarScreen extends StatefulWidget {
  @override
  _TableCalendarScreenState createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  Map<DateTime, bool> progressMap = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final progress = prefs.getString('progressMap');
      if (progress != null) {
        progressMap = Map<DateTime, bool>.from(json.decode(progress).map(
              (key, value) => MapEntry(DateTime.parse(key), value),
            ));
      }
    });
  }

  bool _isMissedDay(DateTime day) {
    DateTime today = DateTime.now();
    return day.isBefore(today) &&
        progressMap[DateTime(day.year, day.month, day.day)] != true;
  }

  bool _isCompletedDay(DateTime day) {
    return progressMap[DateTime(day.year, day.month, day.day)] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bible Reading Calendar'),
      ),
      body: Column(
        children: [
          Text('You can read up missed days by tapping on the day'),
          Expanded(
            child: TableCalendar(
              firstDay: DateTime(DateTime.now().year, 1, 1),
              lastDay: DateTime(DateTime.now().year, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) => _isCompletedDay(day) ? ["Completed"] : [],
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (_isMissedDay(day)) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return null;
                },
                markerBuilder: (context, day, events) {
                  if (_isCompletedDay(day)) {
                    return Image.asset('assets/images/mark.png');
                  }
                  return null;
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                  Navigator.pop(context, selectedDate);
                });
                // Handle day selection here (e.g., fetch readings for the day)
                print("Selected Date: $selectedDay");
              },
            ),
          ),
        ],
      ),
    );
  }
}
