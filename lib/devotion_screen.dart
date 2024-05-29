import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:mivdevotional/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/core/utility/get_week.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DevorionScreen extends StatefulWidget {
  const DevorionScreen({super.key});

  @override
  State<DevorionScreen> createState() => _DevorionScreenState();
}

class _DevorionScreenState extends State<DevorionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDevotional();
    // controller = PageController(initialPage: 3);
  }

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
      todayDevotional =
          (allDevotional.firstWhere((element) => element.date == refineDate()));
      indexofToday = allDevotional.indexOf(todayDevotional);
      print(todayDevotional.thought);

      setState(() {});
      _controller.jumpToPage(indexofToday);
    }
    if (mounted) setState(() {});
  }

  int indexofToday = 0;
  PageController _controller = PageController();
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

  String y = '';
  String z = '';

  String getVerse(e) {
      z = '-1';

    if (e.startsWith('1') || e.startsWith('2') || e.startsWith('3')) {
      y = e.split(' ')[2].split(':')[1];
    } else {
      y = e.split(' ')[1].split(':')[1];
      print(y);
    }
    if (y.contains('-')) {
      z = y.split('-')[1];

      y = y.split('-')[0];
    } else if (y.contains(',')) {
      // z = y.split(',')[1];
      y = y.split(',')[0];
    } else {
      y = y;
    }
    print(y);
    return y;
  }

  getAllDevotional() async {
    allDevotional =
        await Provider.of<BibleModel>(context, listen: false).getDevotional();
    todayDevotional =
        (allDevotional.firstWhere((element) => element.date == refineDate()));
    indexofToday = allDevotional.indexOf(todayDevotional);
    print(todayDevotional.thought);

    setState(() {});
    _controller.jumpToPage(indexofToday);
  }

  int selectedIndex = 0;

  int thisMonth = DateTime.now().month;
  int thisDay = DateTime.now().day;

  String today = '';
//2024-03-24
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
    return CustomFloatingActionButton(
        body: Scaffold(
          appBar: AppBar(
            title: Text('All Devotional'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              PageView.builder(
                  controller: _controller,
                  physics: ClampingScrollPhysics(),
                  itemCount: allDevotional.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    selectedIndex = index;
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                allDevotional[index].date,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                allDevotional[index].title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              if (allDevotional[index].reference.isNotEmpty)
                                InkWell(
                                    onTap: () {
                                      // print(allDevotional[index]
                                      //                   .reference
                                      //                   .split(' ')[0]
                                      //                   .toString());
                                      //                   print(int.parse(allDevotional[index].reference.split(' ')[1].split(':')[0]));
                                      //                   print( int.parse(getVerse(allDevotional[index].reference)));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShowChapter(
                                            autoRead: false,
                                            fromSearch: false,
                                            bookName: (allDevotional[index]
                                                        .reference
                                                        .startsWith('1') ||
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
                                                : int.parse(allDevotional[index]
                                                    .reference
                                                    .split(' ')[1]
                                                    .split(':')[0]),
                                            verse: int.parse(getVerse(
                                                allDevotional[index]
                                                    .reference),),
                                                    verseEnd: int.parse(z)
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      color: Colors.amberAccent,
                                      child: Text(
                                        allDevotional[index].reference,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )),
                              Text(
                                allDevotional[index].scripture,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                allDevotional[index].text,
                                style: TextStyle(fontSize: 16, height: 1.6),
                              ),
                              if (allDevotional[index].thought.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Thought for the day: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6)),
                                    TextSpan(
                                        text: allDevotional[index].thought,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          height: 1.6,
                                          fontSize: 16,
                                        ))
                                  ])),
                                ),
                              if (allDevotional[index].action_plan.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Action Plan: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            height: 1.6,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: allDevotional[index].action_plan,
                                        style: TextStyle(
                                          height: 1.6,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ))
                                  ])),
                                ),
                              if (allDevotional[index].prayer.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Prayer: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            height: 1.6,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: allDevotional[index].prayer,
                                        style: TextStyle(
                                          color: Colors.black,
                                          height: 1.6,
                                          fontSize: 16,
                                        ))
                                  ])),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              Positioned(
                left: 20,
                right: 20,
                bottom: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ),
                    InkWell(
                        onTap: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutSine),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 32,
                        )),
                  ],
                ),
              )
            ],
          ),
          //     floatingActionButton: FloatingActionButton(
          //       onPressed: () async {
          //         final result = await Share.share(
          //           'Awakening Word Today\nThe Men of Issachar Vision\n\n ${allDevotional[selectedIndex].date}\n\n${allDevotional[selectedIndex].title}\n${allDevotional[selectedIndex].reference}\n\n${allDevotional[selectedIndex].scripture}\n\n ${allDevotional[selectedIndex].text}\n\nAction plan: ${allDevotional[selectedIndex].action_plan}\n\nThought of the day: ${allDevotional[selectedIndex].thought}\n\nprayer: ${allDevotional[selectedIndex].prayer}\n\n@The Men of Issachar Vision Inc\n  download app for more https://www.menofissacharvision.com',
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
              pickDate();
            },
            child: CircleAvatar(
              child: Icon(Icons.calendar_month),
            ),
          ),
          InkWell(
            onTap: () async {
              final result = await Share.share(
                '*Awakening Word Today*\n*The Men of Issachar Vision Inc*\n\n*${allDevotional[selectedIndex].date}, 2024*\n\n*${allDevotional[selectedIndex].title}*\n\n*${allDevotional[selectedIndex].reference}*\n\n*${allDevotional[selectedIndex].scripture}*\n\n ${allDevotional[selectedIndex].text}\n\n*Action plan:* ${allDevotional[selectedIndex].action_plan}\n\n*Thought for the day:* ${allDevotional[selectedIndex].thought}\n\n*Prayer:* ${allDevotional[selectedIndex].prayer}\n\nDownload Android app for more\nhttps://play.google.com/store/apps/details?id=com.miv.devotional \n\nDownload IOS app for more\nhttps://apps.apple.com/us/app/miv-devotional/id6502105645\n\n@The Men of Issachar Vision Inc\n https://www.menofissacharvision.com',
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
        openFloatingActionButton: const Icon(Icons.add),
        closeFloatingActionButton: const Icon(Icons.close));
  }
}
