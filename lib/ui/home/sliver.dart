import 'dart:math';

import 'package:mivdevotional/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/book/daily_verse.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySilverScreen extends StatefulWidget {
  @override
  State<MySilverScreen> createState() => _MySilverScreenState();
}

class _MySilverScreenState extends State<MySilverScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDevotional();
    // controller = PageController(initialPage: 3);
  }

  PageController controller = PageController(initialPage: 22);
  List<DevotionModel> allDevotional = [];

  getAllDevotional() async {
    allDevotional =
        await Provider.of<BibleModel>(context, listen: false).getDevotional();
    print('devoitonal date');
    print(allDevotional.firstWhere((element) => element.date == "March 24"));

    setState(() {});
  }

  int ran = 3;

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        body: PageView.builder(
      onPageChanged: (value) {
        ran = Random().nextInt(3) + 5;
        print(ran);
      },
      controller: controller,
      physics: ClampingScrollPhysics(),
      itemCount: allDevotional.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey,
              floating: true,
              snap: true,
              pinned: true,
              title: Text(allDevotional[index].title),
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/$ran.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(.3),
                    )
                  ],
                ),
              ),
            ),
            SliverMainAxisGroup(slivers: [
              SliverToBoxAdapter(
                  child: Container(
                color: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  // padding: const EdgeInsets.only(left: 10,right: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowChapter(fromSearch: false,
                                          bookName:
                                              (allDevotional[index].reference.startsWith('1') ||
                                                      allDevotional[index]
                                                          .reference
                                                          .startsWith('2') ||
                                                      allDevotional[index]
                                                          .reference
                                                          .startsWith('3'))
                                                  ? ('${allDevotional[index].reference.split(' ')[0]} ${allDevotional[index].reference.split(' ')[1]}')
                                                  : allDevotional[index]
                                                      .reference
                                                      .split(' ')[0]
                                                      .toString(),
                                          chapter: (allDevotional[index]
                                                      .reference
                                                      .startsWith('1') ||
                                                  allDevotional[index]
                                                      .reference
                                                      .startsWith('2') ||
                                                  allDevotional[index]
                                                      .reference
                                                      .startsWith('3'))
                                              ? int.parse(allDevotional[index]
                                                  .reference
                                                  .split(' ')[2]
                                                  .split(':')[0])
                                              : int.parse(allDevotional[index].reference.split(' ')[1].split(':')[0]))));
                            },
                            child: Container(
                              color: Colors.blue,
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    allDevotional[index].reference,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )),
                        // Text(DailyVerse().verses[0]['verse']),
                        Text(
                          allDevotional[index].date,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        // Text(allDevotional[index].title),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            allDevotional[index].scripture,
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.blue,
                                height: 1.6),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            allDevotional[index].text,
                            style: TextStyle(
                                fontSize: 16, color: Colors.black, height: 1.6),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            allDevotional[index].thought,
                            style: TextStyle(
                                color: Colors.green,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(allDevotional[index].action_plan),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(allDevotional[index].prayer),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ]),
          ],
        ),
      ),
    ));
  }
}
