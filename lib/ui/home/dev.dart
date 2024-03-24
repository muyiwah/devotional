import 'dart:math';

import 'package:mivdevotional/core/model/devorion_model.dart';
import 'package:mivdevotional/core/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/devotion_today.dart';
import 'package:mivdevotional/ui/book/daily_verse.dart';
import 'package:mivdevotional/ui/home/dailyverse_full.dart';
import 'package:mivdevotional/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  }

  List<DevotionModel> allDevotional = [];
  List<WordClinicModel> allWordClinickkk = [];
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

    setState(() {});
  } 
  
   getAllWordClinic() async {
    allWordClinickkk =
        await Provider.of<BibleModel>(context, listen: false).getWordClinic();
    // todayDevotional =
    //     (allDevotional.firstWhere((element) => element.date == refineDate()));
print(allWordClinickkk[0].conclusion);
    setState(() {});
  }

  DateTime date = DateTime.now();

  String today = '';
//2024-03-24 
  String refineDate() {
    String month = '';
    today = (date.toString().split(' ')[0].split('-')[1].toString() +
        {date.toString().split(' ')[0].split('-')[2]}.toString());
    if (date.toString().split(' ')[0].split('-')[1].toString() == '01') {
      month = 'January ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '02') {
      month = 'February ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '03') {
      month = 'March ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '04') {
      month = 'April ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '05') {
      month = 'May ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '06') {
      month = 'June ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '07') {
      month = 'July ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '08') {
      month = 'August ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '09') {
      month = 'September ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '10') {
      month = 'October ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '11') {
      month = 'November ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '12') {
      month = 'December ${date.toString().split(' ')[0].split('-')[2]}';
    }
    return month;
  }

  int ran = Random().nextInt(4);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DevotionToday(todayDevotional)));
            },
            child: Container(
                padding: EdgeInsets.all(6),
                color: Colors.blue,
                child: Text(
                  'mivdevotional',
                  style: TextStyle(color: Colors.white),
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
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 3,
                      spreadRadius: .2,
                      offset: Offset(-2, 2),
                      color: Colors.blueGrey)
                ],
                gradient: LinearGradient(colors: const [
                  Colors.blue,
                  Color.fromARGB(255, 115, 78, 237),
                  // Color.fromARGB(209, 1, 32, 206)
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DailyVerse().verses[ran].verse,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
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
                    child: Image.asset('assets/images/bible.png'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
