import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/ui/home/notification.dart';
import 'package:mivdevotional/ui/home/word_clinic_today.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyBiblePage2 extends StatefulWidget {
  @override
  _DailyBiblePage2State createState() => _DailyBiblePage2State();
}

class _DailyBiblePage2State extends State<DailyBiblePage2> {
  List<Bible>? bibleData;
  List<dynamic>? readingPlan;
  int completedDays = 0;

  @override
  void initState() {
    super.initState();
    getDay(DateTime.now());
    loadResources();
  }

  DateTime selectedDate = DateTime.now();
  Map<String, String>? readingsForSelectedDay;
  Map<DateTime, bool> progressMap = {};
  Future<void> loadResources() async {
    bibleData = await loadBibleData();
    final planData =
        await rootBundle.loadString('assets/bibleJson/monthfour.json');
    readingPlan = json.decode(planData);

    // Load progress
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    DateTime date = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completedDays += 1;
      progressMap[date] = true;
    });
    await prefs.setInt('completedDays', completedDays);
    await prefs.setString(
      'progressMap',
      json.encode(progressMap.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      )),
    );
    print('marked completed $date');
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
    final data = await rootBundle.loadString('assets/bibleJson/asv.json');
    final jsonData = json.decode(data) as List<dynamic>;
    return jsonData.map((entry) => Bible.fromJson(entry)).toList();
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
          }
          // else if (endChapter != null &&
          //     entry.chapter == endChapter &&
          //     endVerse != null &&
          //     entry.verse <= endVerse) {
          //   selectedVerses.add(entry);
          // }
          //
          else if (isChaptersOnly &&
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

  Map<String, dynamic>? getDailyReadings(List<dynamic> readingPlan, int day) {
    return readingPlan.firstWhere((plan) => plan['day'] == day,
        orElse: () => null);
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
    // final today = DateTime.now();
    // final day = today.day;

    final dayPlan = getDailyReadings(readingPlan ?? [], day);

    if (bibleData == null || dayPlan == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Daily Bible Readings'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final readings = <String, Map<String, dynamic>>{};
    dayPlan['readings'].forEach((key, value) {
      readings[key] = {
        'startNo': startNo(bibleData!, value),
        'reference': value,
        'verses': getVerses(bibleData!, value),
      };
    });
    final missedDays = calculateMissedDays(progressMap);
    print(missedDays);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ReminderScreen()));
      }),
      appBar: AppBar(
        title: Text('Daily Bible Readings $day'),
        actions: [
          ElevatedButton(
              onPressed: () {
                markAsCompleted();
             
              },
              child: Text('mark complte'))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Display progress bar
                Text(
                  'Progress: $completedDays / ${readingPlan?.length ?? 0} days completed',
                  style: TextStyle(fontSize: 16),
                ),
                LinearProgressIndicator(
                  value: (completedDays / (readingPlan?.length ?? 1))
                      .clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 8,
                ),
              ],
            ),
          ),
        
          //       }
          //     });
          //   },
          //   child: Text('mark complte')),
          Expanded(
            child: Scrollbar(
              child: ListView(
                children: readings.entries.mapIndexed((i, entry) {
                  final category = entry.key.replaceAll('_', ' ').toUpperCase();
                  final reference = entry.value['reference'] as String;
                  Map startNo = entry.value['startNo'];
                  final endChapter = entry.value['endChapter'];
                  final verses = entry.value['verses'] as List<Bible>;
                  int counter = 0;
                  int firstOnlyChapterEndVerse = 0;
                  // Combine reference and verses for display
                  print(startNo['startVerse']);
                  if (startNo['startVerse'] != null) {
                    counter = int.parse(startNo['startVerse'].toString());
                  } else if (startNo['endChapter'] != null) {
                    counter = 1;
                  }
                  if (startNo['isChaptersOnly'] == true) {
                    firstOnlyChapterEndVerse = int.parse(
                        startNo['noOfVersesInStartChapter'].toString());
                  }

                  final versesText = verses.mapIndexed((count, verse) {
                    // print(startNo['isChaptersOnly']);
                    // print(startNo['noOfVersesInStartChapter']);
                    if (startNo['isChaptersOnly'] == true &&
                        (startNo['noOfVersesInStartChapter']) == count) {
                      counter = -startNo['noOfVersesInStartChapter']+1;
                      print('helllllloooooooo');
                      print(count);
                      print(counter);
                    }

                    return "${counter + count}. ${verse.text}";
                  }).join('\n');

                  return Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // markAsCompleted();
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => TableCalendarScreen()))
                                .then((e) {
                              if (e != null) {
                                print('eeeee');
                                print(e);
                                day = e;
                                setState(() {});
                              }
                            });
                          },
                          child: Text('check progress')),
                      ListTile(
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
                    ],
                  );
                }).toList(),
              ),
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
        title: Text('Bible Reading Calendar'),
      ),
      body: TableCalendar(
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
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                width: 8.0,
                height: 8.0,
              );
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
            Navigator.pop(context, selectedDate.day);
          });
          // Handle day selection here (e.g., fetch readings for the day)
          print("Selected Date: $selectedDay");
        },
      ),
    );
  }
}
