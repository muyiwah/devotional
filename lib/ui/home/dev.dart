import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mivdevotional/model/devorion_model.dart';
import 'package:mivdevotional/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/get_week.dart';
import 'package:mivdevotional/devotion_today.dart';
import 'package:mivdevotional/ui/book/daily_verse.dart';
import 'package:mivdevotional/ui/home/dailyverse_full.dart';
import 'package:mivdevotional/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/ui/home/prayer_conference.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typewritertext/typewritertext.dart';
// import 'package:firebase_database/firebase_database.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDevotional();
    getAllWordClinic();
    getFontSize();
    // fetchUsers();
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
      bool show = prefs.getBool('show') ?? true;
      if (show) {
        checkUser();
      // }
    }
  }

// final db = FirebaseFirestore.instance;
  int df = DateTime.now().month;
  int dfd = DateTime.now().weekOfMonth;
  List<DevotionModel> allDevotional = [];
  List<WordClinicModel> allWordClinickkk = [];
  checkUser() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.grey.withOpacity(.9),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/readbible.png')),
                        Positioned(
                          bottom: 2,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.5),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(3),
                            child: Text(
                              textAlign: TextAlign.center,
                              'You can now easily read the bible in a year',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Provider.of<BibleModel>(context, listen: false)
                                .updateSelectedTab(2);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue),
                            child: Text(
                              'Try It',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('show', false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue),
                            child: Text(
                              'Don\'nt show again',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(
                        delay: Duration(milliseconds: 400),
                        duration: Duration(milliseconds: 600))
                  ],
                ),
              ),
            ));
  }

  DevotionModel todayDevotional = DevotionModel(
      title: '',
      reference: '',
      scripture: '',
      action_plan: '',
      thought: '',
      prayer: '',
      text: '',
      date: '');

  double appfontSize = 0;

  getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fontSize')) {
      appfontSize = prefs.getDouble('fontSize') ?? 0;
      setState(() {});
    }
  }

  getAllDevotional() async {
    allDevotional =
        await Provider.of<BibleModel>(context, listen: false).getDevotional();
    todayDevotional =
        (allDevotional.firstWhere((element) => element.date == refineDate()));
//     print('weekday is $df');
//     print('date is $dfd');
//     print(    jsonEncode(todayDevotional)
// );

    setState(() {});
  }

  getAllWordClinic() async {
    allWordClinickkk =
        await Provider.of<BibleModel>(context, listen: false).getWordClinic();
    // todayDevotional =
    //     (allDevotional.firstWhere((element) => element.date == refineDate()));
    // print(allWordClinickkk[0].conclusion);
    setState(() {});
  }

  int thisMonth = DateTime.now().month;
  int thisDay = DateTime.now().day;

  String today = '';
//2024-03-24
  String refineDate() {
    String month = '';

    if (thisMonth == 1) {
      month = 'January $thisDay';
    } else if (thisMonth == 2) {
      month = 'February $thisDay';
    } else if (thisMonth == 3) {
      month = 'March $thisDay';
    } else if (thisMonth == 4) {
      month = 'April $thisDay';
    } else if (thisMonth == 5) {
      month = 'May $thisDay';
    } else if (thisMonth == 6) {
      month = 'June $thisDay';
    } else if (thisMonth == 7) {
      month = 'July $thisDay';
    } else if (thisMonth == 8) {
      month = 'August $thisDay';
    } else if (thisMonth == 9) {
      month = 'September $thisDay';
    } else if (thisMonth == 10) {
      month = 'October $thisDay';
    } else if (thisMonth == 11) {
      month = 'November $thisDay';
    } else if (thisMonth == 12) {
      month = 'December $thisDay';
    }
    return month;
  }

  int ran = Random().nextInt(87);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bible3.png',
                ),
                fit: BoxFit.cover)),
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    if (todayDevotional.date.isNotEmpty)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DevotionToday(todayDevotional)));
                        },
                        child: Container(
                            margin: EdgeInsets.all(20),
                            height: 400,
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.black.withOpacity(.5),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todayDevotional.date,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16 + appfontSize,
                                      fontWeight: FontWeight.w200),
                                ),
                                Text(
                                  maxLines: 2,
                                  todayDevotional.title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17 + appfontSize,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  child: TypeWriterText(
                                      text: Text(
                                        todayDevotional.text,
                                        maxLines: 4,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Platform.isAndroid
                                              ? 16 + appfontSize
                                              : 17 + appfontSize,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 50)),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/6.webp',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Center(
                                  child: Text(
                                    'Read now',
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20 + appfontSize,
                                        fontWeight: FontWeight.w500),
                                  ).animate().fadeIn(
                                      delay: Duration(seconds: 4),
                                      duration: Duration(seconds: 3)),
                                ),
                              ],
                            )),
                      ),
                    DateTime.now().month == 8
                        ? InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrayerConference())),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              width: double.infinity,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      spreadRadius: .7,
                                      offset: Offset(-2, 2),
                                      color: Colors.black.withOpacity(.9))
                                ],
                                gradient: LinearGradient(
                                    colors: const [
                                      Colors.black,
                                      Colors.orange,
                                      // Color.fromARGB(209, 1, 32, 206)
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Prayer Bulletin',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16 + appfontSize),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'BECOMING A MAN OF PRAYER',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16 + appfontSize),
                                        ),
                                        Text(
                                          'AUGUST 2024',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                      margin: EdgeInsets.only(left: 0),
                                      height: 80,
                                      width: 100,
                                      child: Image.asset(
                                          'assets/images/candle.gif')
                                      // child: Image.asset('assets/images/bible.png'),
                                      )
                                ],
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(duration: Duration(seconds: 3))
                            .slide(
                                duration: Duration(seconds: 2),
                                begin: Offset(0, 0.5),
                                curve: Curves.easeInOut)
                        : InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DailverseFullScreen(
                                        DailyVerse().verses[ran]))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              width: double.infinity,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      spreadRadius: .7,
                                      offset: Offset(-2, 2),
                                      color: Colors.black.withOpacity(.9))
                                ],
                                gradient: LinearGradient(
                                    colors: const [
                                      Colors.black,
                                      Color.fromARGB(255, 124, 217, 31),
                                      // Color.fromARGB(209, 1, 32, 206)
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Daily Verse',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18 + appfontSize),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          DailyVerse().verses[ran].verse,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16 + appfontSize),
                                        ),
                                        Text(
                                          DailyVerse().verses[ran].ref,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    height: 80,
                                    width: 100,
                                    child: Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    // child: Image.asset('assets/images/bible.png'),
                                  )
                                ],
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(duration: Duration(seconds: 3))
                            .slide(
                                duration: Duration(seconds: 2),
                                begin: Offset(0, 0.5),
                                curve: Curves.easeInOut),
                    // Container(height: 20,) ,
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
