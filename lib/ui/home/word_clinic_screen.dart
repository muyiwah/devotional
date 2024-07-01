import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class WordClinicPage extends StatefulWidget {
  const WordClinicPage({super.key});

  @override
  State<WordClinicPage> createState() => _WordClinicPageState();
}

class _WordClinicPageState extends State<WordClinicPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllWordClinic();
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

  String dob = '';

  void pickDate() async {
    DateTime? newDate = await showDatePicker(helpText: 'Select the word clinic date you will like to see',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (newDate != null) {
      print(newDate.weekOfMonth);
      thisMonth = (newDate.month);

      wordClinicToday = (allWordClinickkk.firstWhere((element) =>
          (element.week == newDate.weekOfMonth &&
              element.date == refineDate())));
      _discussion = (allWordClinickkk[indexofToday].discussion)!;
      indexofToday = allWordClinickkk.indexOf(wordClinicToday);
      setState(() {});
      print(wordClinicToday.week);
      print('indexofToday======$indexofToday');

      Future.delayed(const Duration(milliseconds: 500), () {
        goToToday();
      });
    }
    if (mounted) setState(() {});
  }

  int selectedindex = 0;
  int indexofToday = 0;
  final PageController _controller = PageController();
  List<WordClinicModel> allWordClinickkk = [];
  List<DISCUSSION> _discussion = [];
  WordClinicModel wordClinicToday = WordClinicModel();
  getAllWordClinic() async {
    allWordClinickkk =
        await Provider.of<BibleModel>(context, listen: false).getWordClinic();
    print(allWordClinickkk.length);
    try {
      wordClinicToday = (allWordClinickkk.firstWhere((element) =>
          (element.week == DateTime.now().weekOfMonth &&
              element.date == refineDate())));
    } catch (e) {
      print(e);
    }
    if (wordClinicToday.title == null) {
      try {
        wordClinicToday = (allWordClinickkk.firstWhere((element) =>
            (element.week == DateTime.now().weekOfMonth - 1 &&
                element.date == refineDate())));
      } catch (e) {
        print(e);
      }
    } else if (wordClinicToday.title == null) {
      wordClinicToday = allWordClinickkk[0];
    }
    _discussion = (allWordClinickkk[indexofToday].discussion)!;
    indexofToday = allWordClinickkk.indexOf(wordClinicToday);
    setState(() {});
    print(wordClinicToday.week);
    print('indexofToday======`$indexofToday');

    Future.delayed(const Duration(milliseconds: 500), () {
      goToToday();
    });
  }

  int thisMonth = DateTime.now().month;

  String refineDate() {
    String month = '';

    if (thisMonth == 1) {
      month = 'January';
    } else if (thisMonth == 2) {
      month = 'February';
    } else if (thisMonth == 3) {
      month = 'March';
    } else if (thisMonth == 4) {
      month = 'April';
    } else if (thisMonth == 5) {
      month = 'May';
    } else if (thisMonth == 6) {
      month = 'June';
    } else if (thisMonth == 7) {
      month = 'July';
    } else if (thisMonth == 8) {
      month = 'August';
    } else if (thisMonth == 9) {
      month = 'September';
    } else if (thisMonth == 10) {
      month = 'October';
    } else if (thisMonth == 11) {
      month = 'November';
    } else if (thisMonth == 12) {
      month = 'December';
    }
    return month;
  }

  goToToday() {
    _controller.jumpToPage(indexofToday);
  }

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

  TextStyle myStyle =
       TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

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
    return CustomFloatingActionButton(floatinButtonColor: Colors.black.withOpacity(.2),
        body: Scaffold(
          appBar: AppBar(leading:  InkWell(
                        onTap: () => _controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutSine),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
            actions: [
                Container(
                  padding: const EdgeInsets.all(4),
                  // color: Colors.white.withOpacity(3),
                  child: InkWell(
                      onTap: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutSine),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 28,
                      )),
                )
              ],
              centerTitle: true,
              title: InkWell(
                  onTap: () => _controller.jumpToPage(indexofToday),
                  child: const Text('All word clinic'))),
          body: allWordClinickkk.isNotEmpty
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(
                      children: [
                        PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _controller,
                          itemCount: allWordClinickkk.length,
                          itemBuilder: (context, index) {
                            selectedindex = index;

                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    '${allWordClinickkk[index].date} Week ${allWordClinickkk[index].week}',style: TextStyle(fontSize: 16+appfontSize),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(textAlign:TextAlign.center,
                                    allWordClinickkk[index].title.toString(),
                                    style: TextStyle(fontSize: 16+appfontSize, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(allWordClinickkk[index]
                                      .subtitle
                                      .toString(),
                                      textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: 16 + appfontSize),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Wrap(alignment: WrapAlignment.center,
                                    children: allWordClinickkk[index]
                                        .scriptures!
                                        .map((e) => InkWell(
                                            onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ShowChapter(fromWordClinic: true,
                                                          fromSearch: false,
                                                          autoRead: false,
                                                          bookName: (e.startsWith('1') ||
                                                                  e.startsWith(
                                                                      '2') ||
                                                                  e.startsWith(
                                                                      '3'))
                                                              ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                                                              : e
                                                                  .split(' ')[0]
                                                                  .toString(),
                                                          chapter: (e.startsWith(
                                                                      '1') ||
                                                                  e.startsWith(
                                                                      '2') ||
                                                                  e.startsWith(
                                                                      '3'))
                                                              ? int.parse(e
                                                                  .split(' ')[2]
                                                                  .split(':')[0])
                                                              : int.parse(e.split(' ')[1].split(':')[0]),
                                                          verse: int.parse(getVerse(e)),
                                                          verseEnd: int.parse(z))),
                                                ),
                                            child: Container(
                                                padding: EdgeInsets.all(3),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 3, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Text('$e ',style: TextStyle(fontSize: 16+appfontSize),))))
                                        .toList(),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                     TextSpan(
                                        text: 'Objective: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16+ appfontSize,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6)),
                                    TextSpan(
                                        text: allWordClinickkk[index]
                                            .objective
                                            .toString(),
                                        style:  TextStyle(
                                          color: Colors.black87,
                                          height: 1.6,
                                          fontSize: 16+ appfontSize,
                                        ))
                                  ])),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                     TextSpan(
                                        text: 'Memory verse: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16+appfontSize,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6)),
                                    TextSpan(
                                        text: allWordClinickkk[index]
                                            .memoryVerse
                                            .toString(),
                                        style:  TextStyle(
                                          color: Colors.black87,
                                          height: 1.6,
                                          fontSize: 16+ appfontSize,
                                        ))
                                  ])),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                     TextSpan(
                                        text: 'Introduction: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16+appfontSize,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6)),
                                    TextSpan(
                                        text: allWordClinickkk[index]
                                            .iNTRODUCTION
                                            .toString(),
                                        style:  TextStyle(
                                          color: Colors.black87,
                                          height: 1.6,
                                          fontSize: 16+ appfontSize,
                                        ))
                                  ])),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  if (allWordClinickkk[index]
                                      .discussion_title!
                                      .isNotEmpty)
                                    RichText(
                                        text: TextSpan(children: [
                                       TextSpan(
                                          text: 'Discussion: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16+appfontSize,
                                              fontWeight: FontWeight.w500,
                                              height: 1.6)),
                                      TextSpan(
                                          text: allWordClinickkk[index]
                                              .discussion_title
                                              .toString(),
                                          style:  TextStyle(
                                            color: Colors.black87,
                                            height: 1.6,
                                            fontSize: 16+appfontSize,
                                          ))
                                    ])),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: allWordClinickkk[index]
                                        .discussion!
                                        .mapIndexed((index, e) => Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          e.title.contains("*")
                                                              ? Colors.white
                                                              : Colors.black)),
                                              child: Wrap(
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.all(
                                                          e.title.contains("*")
                                                              ? 0
                                                              : 3.0),
                                                      child: RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    '${e.title.replaceAll("*", "")}:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16+
                                                                        appfontSize,
                                                                    fontWeight: e.title.contains(
                                                                            "*")
                                                                        ? FontWeight
                                                                            .w500
                                                                        : FontWeight
                                                                            .normal,
                                                                    height:
                                                                        1.6)),
                                                          ]))),

                                                  //   Text(
                                                  //     '${e.title.replaceAll("*", "")}',
                                                  //     style:  TextStyle(fontSize: 16,fontWeight:  e.title.contains("*")?FontWeight.w500:FontWeight.normal),
                                                  //   ),
                                                  // ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  e.title.contains("*")
                                                      ? SizedBox.shrink()
                                                      : SizedBox(
                                                          height: 30,
                                                          child: ListView(
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
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
                                                                            color:
                                                                                Colors.blue.withOpacity(.3),
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            getVerse(e);
                                                                            print(z);
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => ShowChapter(fromWordClinic: true,
                                                                                  fromSearch: false, autoRead: false, bookName: (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) ? ('${e.split(' ')[0]} ${e.split(' ')[1]}') : e.split(' ')[0].toString(), chapter: (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) ? int.parse(e.split(' ')[2].split(':')[0]) : int.parse(e.split(' ')[1].split(':')[0]), verse: int.parse(getVerse(e)), verseEnd: int.parse(z)),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            e,
                                                                            style:
                                                                                 TextStyle(
                                                                              fontSize: 16+ appfontSize,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  .toList()),
                                                        ),
                                                ],
                                              ),
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
                                  //                                     builder: (context) => ShowChapter(
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
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                     TextSpan(
                                        text: 'Conclusion: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16+appfontSize,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6)),
                                    TextSpan(
                                        text: allWordClinickkk[index]
                                            .conclusion
                                            .toString(),
                                        style:  TextStyle(
                                          color: Colors.black87,
                                          height: 1.6,
                                          fontSize: 16+appfontSize,
                                        ))
                                  ])),
                                  // Spacer()
                                ],
                              ),
                            );
                          },
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
                      ],
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          //   floatingActionButton: FloatingActionButton(
          //       onPressed: () async {
          //         final result = await Share.share(
          //           'Wordclinic Today\nThe Men of Issachar Vision\n\nTHEME        ${allWordClinickkk[selectedindex].title}      ${allWordClinickkk[selectedindex].date}\n\nTOPIC:        ${allWordClinickkk[selectedindex].subtitle}\n\nTEXT        ${allWordClinickkk[selectedindex].scriptures}\n\nMEMORY VERSE:  ${allWordClinickkk[selectedindex].memoryVerse}\n\nOBJECTIVE: ${allWordClinickkk[selectedindex].objective}\n\nINTRODUCTION\n${allWordClinickkk[selectedindex].iNTRODUCTION}\n\nDISCUSSION\n${allWordClinickkk[selectedindex].discussion!.mapIndexed((index, element) => '${'-'}'+element.title+'${element.scriptures.map((e) => e).toList() }'  +'\n').toList()}\n\nCONCLUSION\n${allWordClinickkk[selectedindex].conclusion}\n\n@The Men of Issachar Vision Inc\n  download app for more https://www.menofissacharvision.com',
          //         );

          // // if (result.status == ShareResultStatus.success) {
          // //     print('Thank you for sharing my website!');
          // // }
          //       },
          //       child: Icon(
          //         Icons.share,
          //       ),
          //     ),
        ),
        options: [
          InkWell(
            onTap: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(),
                  ));
            },
            child: CircleAvatar(
              child: Icon(Icons.note_add),
            ),
          ),   InkWell(
            onTap: () {
              pickDate();
            },
            child: CircleAvatar(
              child: Icon(Icons.calendar_month),
            ),
          ),
          InkWell(
            onTap: () async {
              await Share.share(
                'Wordclinic Today\nThe Men of Issachar Vision\n\nTHEME        ${allWordClinickkk[selectedindex].title}      ${allWordClinickkk[selectedindex].date}\n\nTOPIC:        ${allWordClinickkk[selectedindex].subtitle}\n\nTEXT        ${allWordClinickkk[selectedindex].scriptures}\n\nMEMORY VERSE:  ${allWordClinickkk[selectedindex].memoryVerse}\n\nOBJECTIVE: ${allWordClinickkk[selectedindex].objective}\n\nINTRODUCTION\n${allWordClinickkk[selectedindex].iNTRODUCTION}\n\nDISCUSSION\n${allWordClinickkk[selectedindex].discussion!.mapIndexed((index, element) => '${'-'}' + element.title + '${element.scriptures.map((e) => e).toList()}' + '\n').toList()}\n\nCONCLUSION\n${allWordClinickkk[selectedindex].conclusion}\n\nDownload Android app for more\nhttps://play.google.com/store/apps/details?id=com.miv.devotional \n\nDownload IOS app for more\nhttps://apps.apple.com/us/app/miv-devotional/id6502105645\n\n@The Men of Issachar Vision Inc\n https://www.menofissacharvision.com',
              );
            },
            child: CircleAvatar(
              child: Icon(Icons.share),
            ),
          ),
          // Container(
          //   // margin: EdgeInsets.symmetric(horizontal: 8),
          //   width: 50,
          //   height: 40,
          //   color: Colors.red,
          // ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 8),
          //   width: 50,
          //   height: 40,
          //   color: Colors.green,
          // ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 8),
          //   width: 50,
          //   height: 40,
          //   color: Colors.blue,
          // ),
        ],
        type: CustomFloatingActionButtonType.horizontal,
        spaceFromBottom: 50,
        spaceFromRight: 30,
        openFloatingActionButton: const Icon(Icons.add,color: Colors.white,size: 35,),
        closeFloatingActionButton: const Icon(Icons.close));
  }
}
