import 'dart:math';

import 'package:mivdevotional/core/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/book/daily_verse.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionToday extends StatefulWidget {
  DevotionToday( this.todayDevotional);
final DevotionModel todayDevotional;
  @override
  State<DevotionToday> createState() => _DevotionTodayState();
}

class _DevotionTodayState extends State<DevotionToday> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller = PageController(initialPage: 3);
  }

  PageController controller = PageController(initialPage: 22);
  List<DevotionModel> allDevotional = [];

  
  int ran =  Random().nextInt(3)+5;

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
        body:  Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey,
              floating: true,
              snap: true,
              pinned: true,
              title: Text(widget.todayDevotional.title,overflow: TextOverflow.visible,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
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
                                      builder: (context) => ShowChapter(
                                          bookName:
                                              (widget.todayDevotional.reference.startsWith('1') ||
                                                      widget.todayDevotional
                                                          .reference
                                                          .startsWith('2') ||
                                                      widget.todayDevotional
                                                          .reference
                                                          .startsWith('3'))
                                                  ? ('${widget.todayDevotional.reference.split(' ')[0]} ${widget.todayDevotional.reference.split(' ')[1]}')
                                                  : widget.todayDevotional
                                                      .reference
                                                      .split(' ')[0]
                                                      .toString(),
                                          chapter: (widget.todayDevotional
                                                      .reference
                                                      .startsWith('1') ||
                                                  widget.todayDevotional
                                                      .reference
                                                      .startsWith('2') ||
                                                  widget.todayDevotional
                                                      .reference
                                                      .startsWith('3'))
                                              ? int.parse(widget.todayDevotional
                                                  .reference
                                                  .split(' ')[2]
                                                  .split(':')[0])
                                              : int.parse(widget.todayDevotional.reference.split(' ')[1].split(':')[0]))));
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
                                    widget.todayDevotional.reference,
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
                          widget.todayDevotional.date,
                          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                        ),
                        // Text(widget.todayDevotional.title),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.todayDevotional.scripture,
                            style: TextStyle(fontWeight: FontWeight.w200,fontSize: 16, color: Colors.blue,height: 1.6),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.todayDevotional.text,
                            style: TextStyle(fontSize: 16,color: Colors.black,height: 1.6),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  RichText(
                  text: TextSpan(children: [
                // TextSpan(
                //     text: 'Thought of the day: ',
                //     style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text:widget.todayDevotional.thought ,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                       ))
              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  RichText(
                  text: TextSpan(children: [
                // TextSpan(
                //     text: 'Action Plan: ',
                //     style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text:widget.todayDevotional.action_plan ,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                       ))
              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  RichText(
                  text: TextSpan(children: [
                // TextSpan(
                //     text: 'Prayer: ',
                //     style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text:widget.todayDevotional.prayer ,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                       ))
              ])),
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
    );
  }
}