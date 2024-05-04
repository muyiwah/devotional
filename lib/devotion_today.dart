import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mivdevotional/core/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/book/daily_verse.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DevotionToday extends StatefulWidget {
  DevotionToday(this.todayDevotional);
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
    getVerse();
  }

  PageController controller = PageController(initialPage: 22);
  List<DevotionModel> allDevotional = [];

  int ran = Random().nextInt(3) + 5;
  String y = '';
  bool thoughtFocused = false;
  bool actionPlanFocused = false;
  bool prayerFocused = false;
  int getChapter() {
    String k = '';
    print(widget.todayDevotional.reference);
    if (widget.todayDevotional.reference.startsWith('1') ||
        widget.todayDevotional.reference.startsWith('2') ||
        widget.todayDevotional.reference.startsWith('3')) {
      k = widget.todayDevotional.reference.split(' ')[2].split(':')[0];
    } else {
      k = widget.todayDevotional.reference.split(' ')[1].split(':')[0];

      print(k);
      print(k.contains('1'));
    }

    if (k.contains('-')) {
      print(k);
      k = k.split('–')[0];
    } else if (k.contains(',')) {
      k = k.split(',')[0];
    } else {
      k = k;
    }
    print('this is itfffffff$k');

    return int.parse(k);
  }
  // int thisMonth = DateTime.now().month;

  // String refineDate() {

  //   String month = '';

  //   if (thisMonth == 1) {
  //     month = 'January';
  //   } else if (thisMonth == 2) {
  //     month = 'February';
  //   } else if (thisMonth == 3) {
  //     month = 'March';
  //   } else if (thisMonth == 4) {
  //     month = 'April';
  //   } else if (thisMonth == 5) {
  //     month = 'May';
  //   } else if (thisMonth ==6) {
  //     month = 'June';
  //   } else if (thisMonth == 7) {
  //     month = 'July';
  //   } else if (thisMonth == 8) {
  //     month = 'August';
  //   } else if (thisMonth == 9) {
  //     month = 'September';
  //   } else if (thisMonth == 10) {
  //     month = 'October';
  //   } else if (thisMonth == 11) {
  //     month = 'November';
  //   } else if (thisMonth == 12) {
  //     month = 'December';
  //   }
  //   return month;
  // }

  String getVerse() {
    print(widget.todayDevotional.reference);
    print('herer');
    if (widget.todayDevotional.reference.startsWith('1') ||
        widget.todayDevotional.reference.startsWith('2') ||
        widget.todayDevotional.reference.startsWith('3')) {
      y = widget.todayDevotional.reference.split(' ')[2].split(':')[1];
    } else {
      y = widget.todayDevotional.reference.split(' ')[1].split(':')[1];

      print(y);
      // y.replaceAll('-','+');
      // print(y);
      // print(y.contains('+'));
    }
    if (y.contains('-')) {
      print(y);
      y = y.split('-')[0];

      print('splitteed $y');
    } else if (y.contains(',')) {
      y = y.split(',')[0];
    } else {
      y = y;
    }
    print('this is itfffffff$y');

    return y;
  }

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
    if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getAsvText();
    }
     if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getNivText();
    }  if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getNltText();
    }  if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getMsgText();
    }  if (bibleProvider.bibleAsv.isEmpty) {
      bibleProvider.getBishopText();
    }
 if (bibleProvider.bibleAmp.isEmpty) {
      bibleProvider.getAmpText();
    }
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey,
              floating: true,
              snap: true,
              pinned: true,
              title: Text(
                widget.todayDevotional.title,
                overflow: TextOverflow.visible,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
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
                  ),
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
                                      bookName: (widget
                                                  .todayDevotional.reference
                                                  .startsWith('1') ||
                                              widget.todayDevotional.reference
                                                  .startsWith('2') ||
                                              widget.todayDevotional.reference
                                                  .startsWith('3'))
                                          ? ('${widget.todayDevotional.reference.split(' ')[0]} ${widget.todayDevotional.reference.split(' ')[1]}')
                                          : widget.todayDevotional.reference
                                              .split(' ')[0]
                                              .toString(),
                                      chapter: (widget.todayDevotional.reference
                                                  .startsWith('1') ||
                                              widget.todayDevotional.reference
                                                  .startsWith('2') ||
                                              widget.todayDevotional.reference
                                                  .startsWith('3'))
                                          ? int.parse(widget.todayDevotional.reference.split(' ')[2].split(':')[0])
                                          : int.parse(widget.todayDevotional.reference.split(' ')[1].split(':')[0]),
                                      verse: int.parse(y)),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.green,
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.todayDevotional.reference,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        // Text(widget.todayDevotional.title),
                        if (widget.todayDevotional.scripture.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.todayDevotional.scripture,
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                  color: Colors.blue,
                                  height: 1.6),
                            ),
                          ),
                        InkWell(
                          onTap: () {
                               actionPlanFocused = false;
                                  thoughtFocused = false;
                                  prayerFocused = false;
                                  setState(() {
                                    
                                  });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(
                              widget.todayDevotional.text,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black, height: 1.6),
                            ),
                          ),
                        ),
                        if (widget.todayDevotional.thought.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                thoughtFocused = true;
                                  actionPlanFocused = false;
                           prayerFocused = false;
                                setState(() {});
                              },
                              onTapCancel: () {
                                thoughtFocused = false;
                                  actionPlanFocused = false;
                           prayerFocused = false;
                                setState(() {});
                              },
                              onLongPress: () {
                                actionPlanFocused = false;
                                  thoughtFocused = true;
                                  prayerFocused = false;setState(() {
                                    
                                  });
                                Clipboard.setData(ClipboardData(
                                        text: widget.todayDevotional.thought))
                                    .then((_) {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        duration: Duration(milliseconds: 1500),
                                        backgroundColor:
                                            Colors.green.withOpacity(.9),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            left: 10,
                                            right: 10),
                                        content: Center(
                                            child:
                                                Text("copied to clipboard"))));
                                });
                              },
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Thought of the day: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: widget.todayDevotional.thought,
                                    style: TextStyle(
                                      backgroundColor: thoughtFocused
                                          ? Colors.blue.withOpacity(.2)
                                          : Colors.transparent,
                                      height: 1.6,
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ))
                              ])),
                            ),
                          ),
                        if (widget.todayDevotional.action_plan.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onLongPress: () {
                              actionPlanFocused = true;
                                  thoughtFocused = false;
                                  prayerFocused = false;
                                  setState(() {
                                    
                                  });  Clipboard.setData(ClipboardData(
                                        text:
                                            widget.todayDevotional.action_plan))
                                    .then((_) {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        duration: Duration(milliseconds: 1500),
                                        backgroundColor:
                                            Colors.green.withOpacity(.9),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            left: 10,
                                            right: 10),
                                        content: Center(
                                            child:
                                                Text("copied to clipboard"))));
                                });
                              },
                              child: InkWell(
                                onTap: () {
                                  actionPlanFocused = true;
                           prayerFocused = false;
                                  thoughtFocused = false;
                                  setState(() {});
                                },
                                onTapCancel: () {
                           prayerFocused = false;
                                  actionPlanFocused = false;
                                  thoughtFocused = false;
                                  setState(() {});
                                },
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Action Plan: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                      text: widget.todayDevotional.action_plan,
                                      style: TextStyle(
                                        backgroundColor: actionPlanFocused
                                            ? Colors.blue.withOpacity(.2)
                                            : Colors.transparent,
                                        height: 1.6,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ))
                                ])),
                              ),
                            ),
                          ),
                        if (widget.todayDevotional.prayer.isNotEmpty)
                          InkWell(
                            onLongPress: () {

                              actionPlanFocused = false;
                                  thoughtFocused = false;
                                  prayerFocused = true;setState(() {
                                    
                                  });
                              Clipboard.setData(ClipboardData(
                                      text: widget.todayDevotional.prayer))
                                  .then((_) {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      backgroundColor:
                                          Colors.green.withOpacity(.9),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .2,
                                          left: 10,
                                          right: 10),
                                      content: Center(
                                          child: Text("copied to clipboard"))));
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  prayerFocused = true;
                                  actionPlanFocused = false;
                                  thoughtFocused = false;
                                  setState(() {});
                                },
                                onTapCancel: () {
                                  actionPlanFocused = false;
                                  thoughtFocused = false;
                                  prayerFocused = false;
                                  setState(() {});
                                },
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Prayer: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                      text: widget.todayDevotional.prayer,
                                      style: TextStyle(backgroundColor: prayerFocused?Colors.blue.withOpacity(.2):Colors.transparent,
                                        height: 1.6,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ))
                                ])),
                              ),
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Share.share(
            '*Awakening Word Today*\n*The Men of Issachar Vision Inc*\n\n*${widget.todayDevotional.date}, 2024*\n\n*${widget.todayDevotional.title}*\n\n*${widget.todayDevotional.reference}*\n\n*${widget.todayDevotional.scripture}*\n\n ${widget.todayDevotional.text}\n\n*Action plan:* ${widget.todayDevotional.action_plan}\n\n*Thought of the day:* ${widget.todayDevotional.thought}\n\n*prayer:* ${widget.todayDevotional.prayer}\n\nDownload app for more\nhttps://play.google.com/store/apps/details?id=com.miv.devotional \n\n@The Men of Issachar Vision Inc\n https://www.menofissacharvision.com',
          );

// if (result.status == ShareResultStatus.success) {
//     print('Thank you for sharing my website!');
// }
        },
        child: Icon(
          Icons.share,
        ),
      ),
    );
  }
}

