import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/core/utility/get_week.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

class WordClinicToday extends StatefulWidget {
  const WordClinicToday({super.key});

  @override
  State<WordClinicToday> createState() => _WordClinicTodayState();
}

class _WordClinicTodayState extends State<WordClinicToday> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllWordClinic();
  }

  List<WordClinicModel> allWordClinickkk = [];
  List<DISCUSSION> _discussion = [];
  WordClinicModel wordClinicToday = WordClinicModel();
  getAllWordClinic() async {
    allWordClinickkk =
        await Provider.of<BibleModel>(context, listen: false).getWordClinic();
    wordClinicToday = (allWordClinickkk
        .firstWhere((element) => element.week == DateTime.now().weekOfMonth));
    _discussion = (wordClinicToday.discussion)!;
    setState(() {});
  }

  String y = '';
  String getVerse(e) {
    if (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) {
      y = e.split(' ')[2].split(':')[1];
    } else {
      y = e.split(' ')[1].split(':')[1];
    }
    if (y.contains('-')) {
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
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
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
        centerTitle: true,
        title: Text(
          '${wordClinicToday.date} Week ${wordClinicToday.week}',
        ),
      ),
      body: allWordClinickkk.isNotEmpty
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Row(mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(wordClinicToday.date.toString(),style: myStyle,),
                      // Text('Week ${wordClinicToday.week}',style: myStyle,),
                      //   ],
                      // ),

                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        wordClinicToday.title.toString(),
                        style: myStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(wordClinicToday.subtitle.toString()),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: wordClinicToday.scriptures!
                            .map((e) => InkWell(
                                onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowChapter(
                                            bookName: (e.startsWith('1') ||
                                                    e.startsWith('2') ||
                                                    e.startsWith('3'))
                                                ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                                                : e.split(' ')[0].toString(),
                                            chapter: (e.startsWith('1') ||
                                                    e.startsWith('2') ||
                                                    e.startsWith('3'))
                                                ? int.parse(e
                                                    .split(' ')[2]
                                                    .split(':')[0])
                                                : int.parse(e
                                                    .split(' ')[1]
                                                    .split(':')[0]),
                                            verse: int.parse(getVerse(e))),
                                      ),
                                    ),
                                child: Container(margin: EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(color: Colors.greenAccent,
                                        borderRadius:
                                            BorderRadius.circular(5)),
                                    padding: EdgeInsets.symmetric(vertical:3,horizontal: 6),
                                    child: Text('${e} ',style: TextStyle(color: Colors.black),))))
                            .toList(),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Objective: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.6)),
                        TextSpan(
                            text: wordClinicToday.objective.toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              height: 1.6,
                              fontSize: 16,
                            ))
                      ])),
                      SizedBox(
                        height: 18,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Memory verse: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.6)),
                        TextSpan(
                            text: wordClinicToday.memoryVerse.toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              height: 1.6,
                              fontSize: 16,
                            ))
                      ])),
                      SizedBox(
                        height: 18,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Introduction: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.6)),
                        TextSpan(
                            text: wordClinicToday.iNTRODUCTION.toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              height: 1.6,
                              fontSize: 16,
                            ))
                      ])),
                      SizedBox(
                        height: 10,
                      ),
                      if (wordClinicToday.discussion_title!.isNotEmpty)
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Discussion: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.6)),
                          TextSpan(
                              text: wordClinicToday.discussion_title.toString(),
                              style: TextStyle(
                                color: Colors.black87,
                                height: 1.6,
                                fontSize: 16,
                              ))
                        ])),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _discussion
                            .mapIndexed((index, e) => Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          '${index + 1}. ${e.title}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: e.scriptures
                                                .map((e) => Container(
                                                      padding:
                                                          EdgeInsets.symmetric(horizontal:5,vertical: 3),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue
                                                              .withOpacity(.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5)),
                                                      child: InkWell(
                                                        onTap: () =>
                                                            Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => ShowChapter(
                                                                bookName: (e.startsWith('1') ||
                                                                        e.startsWith(
                                                                            '2') ||
                                                                        e.startsWith(
                                                                            '3'))
                                                                    ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                                                                    : e
                                                                        .split(' ')[
                                                                            0]
                                                                        .toString(),
                                                                chapter: (e.startsWith('1') ||
                                                                        e.startsWith(
                                                                            '2') ||
                                                                        e.startsWith(
                                                                            '3'))
                                                                    ? int.parse(e
                                                                        .split(' ')[2]
                                                                        .split(':')[0])
                                                                    : int.parse(e.split(' ')[1].split(':')[0]),
                                                                verse: int.parse(getVerse(e))),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          e,
                                                          style: TextStyle(
                                                            fontSize: 16,
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
                      //               child: Wrap(
                      //                 children: [
                      //                   Text(
                      //                     _discussion[index].title.toString(),
                      //                     style: TextStyle(
                      //                         fontSize: 22, color: Colors.red),
                      //                   ),
                      //                   SizedBox(
                      //                     width: 15,
                      //                   ),
                      //                   Wrap(
                      //                     children: _discussion[index]
                      //                         .scriptures
                      //                         .map((e) =>
                      // InkWell(
                      //                             onTap: () => Navigator.push(
                      //                                   context,
                      //                                   MaterialPageRoute(
                      //                                     builder: (context) => ShowChapter(
                      //                                         bookName: (e.startsWith(
                      //                                                     '1') ||
                      //                                                 e.startsWith(
                      //                                                     '2') ||
                      //                                                 e.startsWith(
                      //                                                     '3'))
                      //                                             ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                      //                                             : e
                      //                                                 .split(' ')[0]
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
                      //                                 padding: EdgeInsets.all(3),
                      //                                 color: Colors.amber
                      //                                     .withOpacity(.2),
                      //                                 margin: EdgeInsets.symmetric(
                      //                                     horizontal: 2),
                      //                                 child: Text(
                      //                                   e,
                      //                                   style:
                      //                                       TextStyle(fontSize: 18),
                      //                                 ))))
                      //                         .toList(),
                      //                   )
                      //                 ],
                      //               ),
                      //             ))),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Conclusion: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.6)),
                        TextSpan(
                            text: wordClinicToday.conclusion.toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              height: 1.6,
                              fontSize: 16,
                            ))
                      ])),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}