import 'dart:async';

import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mivdevotional/model/august_prayer.dart';
import 'package:mivdevotional/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/core/utility/get_week.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:mivdevotional/ui/notepads/notes_Screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerConference extends StatefulWidget {
  const PrayerConference({super.key});

  @override
  State<PrayerConference> createState() => _PrayerConferenceState();
}

class _PrayerConferenceState extends State<PrayerConference> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPrayerConf();
    getFontSize();
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
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  String dob = '';
  AugustPrayer _augustPrayer = AugustPrayer();
  List<AugustPrayer> allPrayerConf = [];
  void pickDate() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (newDate != null) {
      print(newDate.weekOfMonth);
      thisMonth = (newDate.month);
      thisDay = newDate.day;
      _augustPrayer =
          (allPrayerConf.firstWhere((element) => element.date == refineDate()));
      indexofToday = allPrayerConf.indexOf(_augustPrayer);

      setState(() {});
      _controller.jumpToPage(indexofToday);
    }
    if (mounted) setState(() {});
  }

  int thisMonth = DateTime.now().month;
  int thisDay = DateTime.now().day;

  int selectedindex = 0;
  int indexofToday = 0;
  final PageController _controller = PageController();
  List<DISCUSSION> _discussion = [];
  AugustPrayer prayerConfToday = AugustPrayer();
  Timer? timer;
  getAllPrayerConf() async {
    allPrayerConf = await Provider.of<BibleModel>(context, listen: false)
        .getAllPrayerConference();
    prayerConfToday =
        (allPrayerConf.firstWhere((element) => element.date == refineDate()));
    indexofToday = allPrayerConf.indexOf(prayerConfToday);

    setState(() {});
    // print(indexofToday);
    timer = Timer.periodic(Duration(milliseconds: 500), (time) {
      _controller.jumpToPage(indexofToday);
      timer!.cancel();
    });
  }

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

  // goToToday() {
  //   _controller.jumpToPage(indexofToday);
  // }

  String z = '-1';
  String y = '';
  String getVerse(e) {
    z = '-1';
    print(e);
    if (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) {
      y = e.split(' ')[2].split(':')[1];
    } else {
      y = e.split(' ')[1].split(':')[1];
    }
    if (y.contains('-')) {
      print(y);
      z = y.split('-')[1];

      y = y.split('-')[0];
    } else if (y.contains(',')) {
      y = y.split(',')[0];
    } else {
      y = y;
    }
    print(y);
    return y;
  }

  TextStyle myStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

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
    return Scaffold(
      appBar: AppBar(
          // leading: InkWell(
          //   onTap: () => _controller.previousPage(
          //       duration: const Duration(milliseconds: 500),
          //       curve: Curves.easeOutSine),
          //   child: Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.black,
          //     size: 28,
          //   ),
          // ),
          // actions: [
          //   Container(
          //     padding: const EdgeInsets.all(4),
          //     // color: Colors.white.withOpacity(3),
          //     child: InkWell(
          //         onTap: () => _controller.nextPage(
          //             duration: const Duration(milliseconds: 500),
          //             curve: Curves.easeOutSine),
          //         child: Icon(
          //           Icons.arrow_forward_ios,
          //           color: Colors.white,
          //           size: 28,
          //         )),
          //   )
          // ],
          centerTitle: true,
          title: const Text('Prayer Bulletin')),
      body: allPrayerConf.isNotEmpty
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 65, right: 12, left: 12),
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    itemCount: allPrayerConf.length,
                    itemBuilder: (context, index) {
                      selectedindex = index;

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              '${allPrayerConf[index].date} ',
                              style: TextStyle(fontSize: 16 + appfontSize),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              allPrayerConf[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 16 + appfontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            // Text(
                            //   allPrayerConf[index].subtitle.toString(),
                            //   textAlign: TextAlign.center,
                            //   style:
                            //       TextStyle(fontSize: 16 + appfontSize),
                            // ),
                            const SizedBox(
                              height: 4,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: allPrayerConf[index]
                                  .scriptures!
                                  .map((e) => InkWell(
                                      onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShowChapter(
                                                    fromWordClinic: true,
                                                    fromSearch: false,
                                                    autoRead: false,
                                                    bookName: (e.startsWith(
                                                                '1') ||
                                                            e.startsWith('2') ||
                                                            e.startsWith('3'))
                                                        ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                                                        : e
                                                            .split(' ')[0]
                                                            .toString(),
                                                    chapter: (e.startsWith(
                                                                '1') ||
                                                            e.startsWith('2') ||
                                                            e.startsWith('3'))
                                                        ? int.parse(e
                                                            .split(' ')[2]
                                                            .split(':')[0])
                                                        : int.parse(e
                                                            .split(' ')[1]
                                                            .split(':')[0]),
                                                    verse:
                                                        int.parse(getVerse(e)),
                                                    verseEnd: int.parse(z))),
                                          ),
                                      child: Container(
                                          padding: EdgeInsets.all(3),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 2),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(.3),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            '$e ',
                                            style: TextStyle(
                                                fontSize: 16 + appfontSize),
                                          ))))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            // RichText(
                            //     text: TextSpan(children: [
                            //   TextSpan(
                            //       text: 'Objective: ',
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 16 + appfontSize,
                            //           fontWeight: FontWeight.w500,
                            //           height: 1.6)),
                            //   // TextSpan(
                            //   //     text: allPrayerConf[index]
                            //   //         .objective
                            //   //         .toString(),
                            //   //     style: TextStyle(
                            //   //       color: Colors.black87,
                            //   //       height: 1.6,
                            //   //       fontSize: 16 + appfontSize,
                            //   //     ))
                            // ])),
                            // const SizedBox(
                            //   height: 6,
                            // ),
                            // RichText(
                            //     text: TextSpan(children: [
                            //   TextSpan(
                            //       text: 'Memory verse: ',
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 16 + appfontSize,
                            //           fontWeight: FontWeight.w500,
                            //           height: 1.6)),
                            //   TextSpan(
                            //       text: allPrayerConf[index]
                            //           .memoryVerse
                            //           .toString(),
                            //       style: TextStyle(
                            //         color: Colors.black87,
                            //         height: 1.6,
                            //         fontSize: 16 + appfontSize,
                            //       ))
                            // ])),
                            if (allPrayerConf[index]
                                .Discussion_title
                                .isNotEmpty)
                              Text(
                                allPrayerConf[index].Discussion_title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            if (allPrayerConf[index]
                                .Discussion_title
                                .isNotEmpty)
                              const SizedBox(
                                height: 6,
                              ),
                            const SizedBox(
                              height: 6,
                            ),

                            if (allPrayerConf[index].anchor_passage.isNotEmpty)
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Anchor Passage: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16 + appfontSize,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6)),
                                TextSpan(
                                    text: allPrayerConf[index]
                                        .anchor_passage
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      height: 1.6,
                                      fontSize: 16 + appfontSize,
                                    ))
                              ])),
                            const SizedBox(
                              height: 14,
                            ),

                            Text(
                              'Prayer Foci',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: allPrayerConf[index]
                                  .prayer_foci!
                                  .mapIndexed((index, e) => Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                bottom: 13,
                                                right: 3,
                                                left: 3),
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        e.title!.startsWith("-")
                                                            ? Colors.white
                                                            : Colors.blue)),
                                            child: Wrap(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(
                                                        e.title!.contains("*")
                                                            ? 0
                                                            : 3.0),
                                                    child: RichText(
                                                        textAlign: e.title!
                                                                .startsWith('-')
                                                            ? TextAlign.center
                                                            : TextAlign.left,
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                              text:
                                                                  '${e.title?.replaceAll("*", "")}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16 +
                                                                      appfontSize,
                                                                  fontWeight: e
                                                                          .title!
                                                                          .startsWith(
                                                                              "-")
                                                                      ? FontWeight
                                                                          .w500
                                                                      : FontWeight
                                                                          .normal,
                                                                  height: 1.6)),
                                                        ]))),

                                                //   Text(
                                                //     '${e.title.replaceAll("*", "")}',
                                                //     style:  TextStyle(fontSize: 16,fontWeight:  e.title.contains("*")?FontWeight.w500:FontWeight.normal),
                                                //   ),
                                                // ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                e.scriptures.isEmpty
                                                    ? SizedBox.shrink()
                                                    : SizedBox(
                                                        height: 30,
                                                        child: ListView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            children: e
                                                                .scriptures
                                                                .map((e) =>
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              3),
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.blue.withOpacity(
                                                                              .3),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          getVerse(
                                                                              e);
                                                                          print(
                                                                              z);
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => ShowChapter(fromWordClinic: true, fromSearch: false, autoRead: false, bookName: (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) ? ('${e.split(' ')[0]} ${e.split(' ')[1]}') : e.split(' ')[0].toString(), chapter: (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) ? int.parse(e.split(' ')[2].split(':')[0]) : int.parse(e.split(' ')[1].split(':')[0]), verse: int.parse(getVerse(e)), verseEnd: int.parse(z)),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          e,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16 + appfontSize,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ))
                                                                .toList()),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          if (!e.title!.startsWith("-"))
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                ("Prayer ${index + 1}."),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                            )
                                        ],
                                      ))
                                  .toList(),
                            ),
                            // Expanded(
                            //     child: ListView.builder(
                            //         itemCount: _discussion.length,
                            //         itemBuilder: (context, index) => Container(
                            //               margin:
                            //                   EdgeInsets.symmetric(vertical: 5),
                            //               padding: EdgeInsets.all(3),
                            //               decoration:
                            //                   BoxDecoration(border: Border.all()),
                            //               child: Wrap(
                            //                 children: [
                            //                   Padding(
                            //                     padding: const EdgeInsets.all(3.0),
                            //                     child: Text(
                            //                       '${index + 1}. ${_discussion[index].title}',
                            //                       style: TextStyle(
                            //                           fontSize: 16,
                            //                           fontWeight: FontWeight.w500),
                            //                     ),
                            //                   ),
                            //                   SizedBox(
                            //                     width: 15,
                            //                   ),
                            //                 if(_discussion[index]
                            //                         .scriptures.isNotEmpty)  Wrap(
                            //                     children: _discussion[index]
                            //                         .scriptures
                            //                         .map((e) => InkWell(
                            //                             onTap: () =>
                            //                                 Navigator.push(
                            //                                   context,
                            //                                   MaterialPageRoute(
                            //                                     builder: (context) => ShowChapter(fromSearch: false,autoRead: false,
                            //                                         bookName: (e.startsWith('1') ||
                            //                                                 e.startsWith(
                            //                                                     '2') ||
                            //                                                 e.startsWith(
                            //                                                     '3'))
                            //                                             ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                            //                                             : e
                            //                                                 .split(' ')[
                            //                                                     0]
                            //                                                 .toString(),
                            //                                         chapter: (e.startsWith('1') ||
                            //                                                 e.startsWith(
                            //                                                     '2') ||
                            //                                                 e.startsWith(
                            //                                                     '3'))
                            //                                             ? int.parse(e
                            //                                                 .split(' ')[2]
                            //                                                 .split(':')[0])
                            //                                             : int.parse(e.split(' ')[1].split(':')[0]),
                            //                                         verse: int.parse(getVerse(e))),
                            //                                   ),
                            //                                 ),
                            //                             child: Container(
                            //                                 padding:
                            //                                     EdgeInsets.symmetric(horizontal:5,vertical: 3),
                            //                                 color: Colors.amber
                            //                                     .withOpacity(.2),
                            //                                 margin: EdgeInsets
                            //                                     .symmetric(
                            //                                         horizontal:
                            //                                             2),
                            //                                 child: Text(
                            //                                   e,
                            //                                   style: TextStyle(
                            //                                       fontSize: 16),
                            //                                 ))))
                            //                         .toList(),
                            //                   )
                            //                 ],
                            //               ),
                            //             ))),

                            // Spacer()
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Positioned(
                //     left: 20,
                //     right: 20,
                //     bottom: 0,
                // child: Container(
                //   padding: const EdgeInsets.all(4),
                //   // color: Colors.white.withOpacity(3),
                //   child: Row(
                //     mainAxisAlignment:
                //         MainAxisAlignment.spaceBetween,
                //     children: [
                //       InkWell(
                //         onTap: () => _controller.previousPage(
                //             duration:
                //                 const Duration(milliseconds: 500),
                //             curve: Curves.easeOutSine),
                //         child: Icon(
                //           Icons.arrow_back_ios,
                //           color: Colors.black.withOpacity(.5),
                //           size: 32,
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 20,
                //       ),
                //       InkWell(
                //           onTap: () => _controller.nextPage(
                //               duration:
                //                   const Duration(milliseconds: 500),
                //               curve: Curves.easeOutSine),
                //           child: Icon(
                //             Icons.arrow_forward_ios,
                //             color: Colors.black.withOpacity(.5),
                //             size: 32,
                //           )),
                //     ],
                //   ),
                // ))
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            width: double.infinity,
                            color: Colors.teal.withOpacity(.5),
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                        onPressed: () {
                                          _controller.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOutSine);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.orange,
                                          size: 40,
                                        ))
                                    .animate()
                                    .fadeIn(
                                        delay: Duration(milliseconds: 600),
                                        duration: Duration(milliseconds: 600))
                                    .slideX(begin: 10),
                                IconButton(
                                        onPressed: () {
                                          _controller.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOutSine);
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.orange,
                                          size: 40,
                                        ))
                                    .animate()
                                    .fadeIn(
                                        delay: Duration(milliseconds: 800),
                                        duration: Duration(milliseconds: 800))
                                    .slideX(begin: 10),
                                IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NoteScreen(),
                                              ));
                                        },
                                        icon: Image.asset(
                                            'assets/images/note.png'))
                                    .animate()
                                    .fadeIn(
                                        delay: Duration(milliseconds: 1000),
                                        duration: Duration(milliseconds: 1000))
                                    .slideX(begin: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton.small(
                                          heroTag: '2',
                                          child: Icon(Icons.calendar_month),
                                          onPressed: () {
                                            pickDate();
                                          })
                                      .animate()
                                      .fadeIn(
                                          delay: Duration(milliseconds: 1200),
                                          duration:
                                              Duration(milliseconds: 1200))
                                      .slideX(begin: 10),
                                ),
                              ],
                            ))
                        .animate()
                        .fadeIn(
                            delay: Duration(milliseconds: 500),
                            duration: Duration(milliseconds: 500))
                        .scaleY(begin: -3))
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      //   floatingActionButton: FloatingActionButton(
      //       onPressed: () async {
      //         final result = await Share.share(
      //           'Wordclinic Today\nThe Men of Issachar Vision\n\nTHEME        ${allPrayerConf[selectedindex].title}      ${allPrayerConf[selectedindex].date}\n\nTOPIC:        ${allPrayerConf[selectedindex].subtitle}\n\nTEXT        ${allPrayerConf[selectedindex].scriptures}\n\nMEMORY VERSE:  ${allPrayerConf[selectedindex].memoryVerse}\n\nOBJECTIVE: ${allPrayerConf[selectedindex].objective}\n\nINTRODUCTION\n${allPrayerConf[selectedindex].iNTRODUCTION}\n\nDISCUSSION\n${allPrayerConf[selectedindex].discussion!.mapIndexed((index, element) => '${'-'}'+element.title+'${element.scriptures.map((e) => e).toList() }'  +'\n').toList()}\n\nCONCLUSION\n${allPrayerConf[selectedindex].conclusion}\n\n@The Men of Issachar Vision Inc\n  download app for more https://www.menofissacharvision.com',
      //         );

      // // if (result.status == ShareResultStatus.success) {
      // //     print('Thank you for sharing my website!');
      // // }
      //       },
      //       child: Icon(
      //         Icons.share,
      //       ),
      //     ),
    );
  }
}
