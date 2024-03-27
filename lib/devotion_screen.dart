import 'package:mivdevotional/core/model/devorion_model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  getAllDevotional() async {
    allDevotional =
        await Provider.of<BibleModel>(context, listen: false).getDevotional();
    todayDevotional =
        (allDevotional.firstWhere((element) => element.date == refineDate()));
    indexofToday = allDevotional.indexOf(todayDevotional);
    print(indexofToday);

    setState(() {});
    _controller.jumpToPage(indexofToday);
  }

  DateTime date = DateTime.now();

  String today = '';

  String refineDate() {
    String month = '';
    today = (date.toString().split(' ')[0].split('-')[1].toString() +
        {date.toString().split(' ')[0].split('-')[2]}.toString());
    if (date.toString().split(' ')[0].split('-')[1].toString() == '01') {
      month = 'January ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '02') {
      month = 'February ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '03') {
      month = 'March ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '04') {
      month = 'April ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '05') {
      month = 'May ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '06') {
      month = 'June ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '07') {
      month = 'July ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '08') {
      month = 'August ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '09') {
      month = 'September ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '10') {
      month = 'October ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '11') {
      month = 'November ${date.toString().split(' ')[0].split('-')[2]}';
    } else if (date.toString().split(' ')[0].split('-')[1].toString() == '12') {
      month = 'December ${date.toString().split(' ')[0].split('-')[2]}';
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
    return Scaffold(
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
              itemBuilder: (context, index) => Container(
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
                            ),   InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowChapter(
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
                                              chapter: (allDevotional[index].reference.startsWith('1') ||
                                                      allDevotional[index]
                                                          .reference
                                                          .startsWith('2') ||
                                                      allDevotional[index]
                                                          .reference
                                                          .startsWith('3'))
                                                  ? int.parse(
                                                      allDevotional[index]
                                                          .reference
                                                          .split(' ')[2]
                                                          .split(':')[0])
                                                  : int.parse(allDevotional[index].reference.split(' ')[1].split(':')[0]))));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  color: Colors.amberAccent,
                                  child: Text(
                                    allDevotional[index].reference,
                                  ),
                                )),
                            Text(allDevotional[index].scripture),
                            SizedBox(
                              height: 18,
                            ),  Text(
                              allDevotional[index].text,
                              style: TextStyle(fontSize: 16, height: 1.6),
                            ),
                          if(allDevotional[index].thought.isNotEmpty)  Container(
                              margin: EdgeInsets.only(top: 8),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Thought of the day: ',
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
                         if(allDevotional[index].action_plan.isNotEmpty)   Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Action Plan: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,height: 1.6,
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
                         if(allDevotional[index].prayer.isNotEmpty)   Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Prayer: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,height: 1.6,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: allDevotional[index].prayer,
                                    style: TextStyle(
                                      color: Colors.black,height: 1.6,
                                      fontSize: 16,
                                    ))
                              ])),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
          Positioned(
              right: 10,
              bottom: 30,
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
                          ),)
        ],
      ),
    );
  }
}
