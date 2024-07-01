import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/ui/home/widgets/show_testament_books.dart';
import 'package:mivdevotional/ui/home/widgets/testament_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOldTestament = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFontSize();
  }

  void toggleTestament(bool isTrue) {
    setState(() {
      isOldTestament = isTrue;
    });
  }

  double appfontSize = 0;

  getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fontSize')) {
      appfontSize = prefs.getDouble('fontSize') ?? 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
      bibleProvider.getBishopText();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Center(
                    child: Text(
                  'Holy Bible',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Config.screenWidth * 6+ appfontSize),
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 13.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                            child: TestamentLabel(testamentName: 'Old'),
                            onTap: () => toggleTestament(true)),
                      ),
                      Expanded(
                        child: InkWell(
                            child: TestamentLabel(testamentName: 'New'),
                            onTap: () => toggleTestament(false)),
                      )
                    ],
                  ),
                ),
                Consumer<BibleModel>(builder: (context, bible, child) {
                  return isOldTestament
                      ? ShowTestamentBooks(
                          books: bible.oldTestamentBooks
                              as List<BibleBookWithChapters>,
                        )
                      : ShowTestamentBooks(
                          books: bible.newTestamentBooks
                              as List<BibleBookWithChapters>);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
