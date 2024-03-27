import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/core/utility/get_week.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';


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
  }

  int indexofToday = 0;
  final PageController _controller = PageController();
  List<WordClinicModel> allWordClinickkk = [];
  List<DISCUSSION> _discussion = [];
  WordClinicModel wordClinicToday = WordClinicModel();
  getAllWordClinic() async {
    allWordClinickkk =
        await Provider.of<BibleModel>(context, listen: false).getWordClinic();
    wordClinicToday = (allWordClinickkk
        .firstWhere((element) => element.week == DateTime.now().weekOfMonth));
    _discussion = (allWordClinickkk[indexofToday].discussion)!;
    indexofToday = allWordClinickkk.indexOf(wordClinicToday);
    setState(() {});
    print(wordClinicToday.week);
    print('indexofToday======$indexofToday');

    Future.delayed(const Duration(milliseconds: 500), () {
      goToToday();
    });
  }

  goToToday() {
    _controller.jumpToPage(indexofToday);
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
      appBar: AppBar(centerTitle: true,
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
                      itemBuilder: (context, index) => SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              '${allWordClinickkk[index].date} Week ${allWordClinickkk[index].week}',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              allWordClinickkk[index].title.toString(),
                              style: myStyle,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(allWordClinickkk[index].subtitle.toString()),
                            const SizedBox(
                              height: 4,
                            ),
                            Wrap(
                              children: allWordClinickkk[index]
                                  .scriptures!
                                  .map((e) => InkWell(
                                      onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShowChapter(
                                                  bookName: (e.startsWith('1') ||
                                                          e.startsWith('2') ||
                                                          e.startsWith('3'))
                                                      ? ('${e.split(' ')[0]} ${e.split(' ')[1]}')
                                                      : e
                                                          .split(' ')[0]
                                                          .toString(),
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
                                      child: Text('${e} ')))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Objective: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.6)),
                              TextSpan(
                                  text: allWordClinickkk[index]
                                      .objective
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.6,
                                    fontSize: 16,
                                  ))
                            ])),
                            const SizedBox(
                              height: 6,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Memory verse: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.6)),
                              TextSpan(
                                  text: allWordClinickkk[index]
                                      .memoryVerse
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.6,
                                    fontSize: 16,
                                  ))
                            ])),
                            const SizedBox(
                              height: 6,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Introduction: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.6)),
                              TextSpan(
                                  text: allWordClinickkk[index]
                                      .iNTRODUCTION
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.6,
                                    fontSize: 16,
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
                                const TextSpan(
                                    text: 'Discussion: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6)),
                                TextSpan(
                                    text: allWordClinickkk[index]
                                        .discussion_title
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      height: 1.6,
                                      fontSize: 16,
                                    ))
                              ])),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: allWordClinickkk[index].discussion!
                              .mapIndexed((index, e) => Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            '${index + 1}. ${e.title}',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: e.scriptures
                                                  .map((e) => Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal:5,vertical: 3),
                                                        margin:
                                                            const EdgeInsets.symmetric(
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
                                                            style: const TextStyle(
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
                              const TextSpan(
                                  text: 'Conclusion: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.6)),
                              TextSpan(
                                  text: allWordClinickkk[index]
                                      .conclusion
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.6,
                                    fontSize: 16,
                                  ))
                            ])),
                            // Spacer()
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        right: 10,
                        bottom: 30,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          // color: Colors.white.withOpacity(3),
                          child: Row(
                            children: [
                          
                            
                              InkWell(
                                onTap: () => _controller.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutSine),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 32,
                                ),
                              ),
                            const SizedBox(
                                width: 20,
                              ),    InkWell(
                                  onTap: () => _controller.nextPage(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeOutSine),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 32,
                                  )),  ],
                          ),
                        ))
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
