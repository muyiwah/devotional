import 'dart:convert';
import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mivdevotional/core/model/devorion_model.dart';
import 'package:mivdevotional/core/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/get_week.dart';
import 'package:mivdevotional/devotion_today.dart';
import 'package:mivdevotional/ui/book/daily_verse.dart';
import 'package:mivdevotional/ui/home/dailyverse_full.dart';
import 'package:mivdevotional/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // fetchUsers();
  }

// final db = FirebaseFirestore.instance;
  int df = DateTime.now().month;
  int dfd = DateTime.now().weekOfMonth;
  List<DevotionModel> allDevotional = [];
  List<WordClinicModel> allWordClinickkk = [];

// Future<void> fetchUsers() {
//   CollectionReference users = FirebaseFirestore.instance.collection('devotional');

//   return users.get()
//     .then((QuerySnapshot snapshot) {
//       snapshot.docs.forEach((doc) {
//         print('${doc.id} => ${doc.data()}');
//       });
//     })
//     .catchError((error) => print("Failed to fetch users: $error"));
// }

  DevotionModel todayDevotional = DevotionModel(
      title: '',
      reference: '',
      scripture: '',
      action_plan: '',
      thought: '',
      prayer: '',
      text: '',
      date: '');
  getAllDevotional() async {
    allDevotional =
        await Provider.of<BibleModel>(context, listen: false).getDevotional();
    todayDevotional =
        (allDevotional.firstWhere((element) => element.date == refineDate()));
    print('weekday is $df');
    print('date is $dfd');
    print(    jsonEncode(todayDevotional) 
);

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
    } else if (thisMonth ==6) {
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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bible3.png',
                ),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                              fontSize: 16,
                              fontWeight: FontWeight.w200),
                        ),
                        Text(
                          todayDevotional.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          todayDevotional.text,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )),
              ),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DailverseFullScreen(DailyVerse().verses[ran]))),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  gradient: LinearGradient(colors: const [
                    Colors.black,
                    Color.fromARGB(255, 124, 217, 31),
                    // Color.fromARGB(209, 1, 32, 206)
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Daily Verse',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            DailyVerse().verses[ran].verse,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 17),
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
            ),
          ],
        ),
      ),
    );
  }
}
