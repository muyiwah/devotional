import 'package:mivdevotional/core/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/devotion_screen.dart';
import 'package:mivdevotional/devotion_today.dart';
import 'package:mivdevotional/ui/home/dev.dart';
import 'package:mivdevotional/ui/home/home_screen.dart';
import 'package:mivdevotional/ui/home/sliver.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/ui/home/word_clinic_page.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDevotional();
    // controller = PageController(initialPage: 3);
  }

  List<DevotionModel> allDevotional = [];
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

  DateTime date = DateTime.now();

  String today = '';

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

  List screen = [
    
    MyWidget(),
    HomeScreen(),
    DevorionScreen(),
   WordClinicPage(),
    Center(child: Text('account')),
    Text('data2'),
  ];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[selected],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // Provider.of<UserProvider>(context, listen: false).isChildren
        //     ? Colors.green
        //     : myColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        currentIndex: selected,
        onTap: (value) {
          setState(() {
            selected = value;
          });
        },
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.blue,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Devotional"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Bible"),
          BottomNavigationBarItem(
              label: 'All Devotional', icon: Icon(Icons.message_rounded)),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: "Word Clinic"),
          // TabData(iconData: Icons.schedule, title: "Account"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}