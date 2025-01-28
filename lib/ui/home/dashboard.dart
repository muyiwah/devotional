import 'package:mivdevotional/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/devotion_screen.dart';
import 'package:mivdevotional/devotion_today.dart';
import 'package:mivdevotional/reminder.dart';
import 'package:mivdevotional/ui/bibleplanselect.dart';
import 'package:mivdevotional/ui/book/show_book.dart';
import 'package:mivdevotional/ui/daily_reading.dart';
import 'package:mivdevotional/ui/home/cmenu.dart';
import 'package:mivdevotional/ui/home/daily_reading2.dart';
import 'package:mivdevotional/ui/home/others.dart';
import 'package:mivdevotional/ui/test/tts.dart';
import 'package:mivdevotional/ui/learningtool_create_event.dart';
import 'package:mivdevotional/ui/notepads/notepad.dart';
import 'package:mivdevotional/ui/notepads/notes_Screen.dart';
import 'package:mivdevotional/ui/home/dev.dart';
import 'package:mivdevotional/ui/home/home_screen.dart';
import 'package:mivdevotional/ui/home/saved_scriptures.dart';
import 'package:mivdevotional/ui/home/sliver.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/ui/home/word_clinic_screen.dart';
import 'package:mivdevotional/ui/home/word_clinic_today.dart';
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
    // getAllDevotional();
    // controller = PageController(initialPage: 3);
  }

 
  List screen = [
    MyWidget(),
    HomeScreen(),
    DailyBiblePage2(),
    Notespad(),
    WordClinicPage(),
   
    LearningToolCreateEvent()
  ];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    int navProvider = Provider.of<BibleModel>(context).selectedTab;
if (navProvider != 0) {
      selected = navProvider;
    }

    var screenSize = MediaQuery.of(context).size;
    Config.setScreenSize(screenSize.height / 100, screenSize.width / 100);

    final bibleProvider = Provider.of<BibleModel>(context, listen: false);
    // if (bibleProvider.oldTestamentBooks.isEmpty) {
    //   bibleProvider.getBibleBook();
    // }

    if (bibleProvider.chaptersPerBook.isEmpty) {
      bibleProvider.getChapterPerBook();
    }
    if (bibleProvider.bible.isEmpty) {
      bibleProvider.getBibleText();
    }
    if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getAsvText();
    }
    if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getNivText();
    }
    if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getNltText();
    }
    if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getMsgText();
    }
    if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getBishopText();
    }
    if (bibleProvider.bibleAmp.isEmpty) {
      bibleProvider.getAmpText();
    }
       if (bibleProvider.bibleRsv.isEmpty) {
      bibleProvider.getRsvText();
    }

    if (bibleProvider.bibleBbe.isEmpty) {
      bibleProvider.getBbeText();
    }
    if (bibleProvider.bibleDby.isEmpty) {
      bibleProvider.getDbyText();
    }
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
            Provider.of<BibleModel>(context, listen: false).updateSelectedTab(0); 
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
          BottomNavigationBarItem(icon: Icon(Icons.read_more), label: "Read"),
          BottomNavigationBarItem(
              label: 'Notes', icon: Icon(Icons.message_rounded)),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: "Word Clinic"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.menu), label: "Others"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Others"),
        ],
      ),
    );
  }
}
