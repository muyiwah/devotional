import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mivdevotional/core/model/bible.model.dart';
import 'package:mivdevotional/core/model/save_color.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/book/search_screen.dart';
import 'package:mivdevotional/ui/constants/constant_widgets.dart';
import 'package:floating_overlay/floating_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:custom_floating_action_button/custom_floating_action_button.dart';

class ShowChapter extends StatefulWidget {
  final String bookName;
  final int chapter;
  int verse;

  ShowChapter({required this.bookName, required this.chapter, this.verse = -1});

  @override
  State<ShowChapter> createState() => _ShowChapterState();
}

class _ShowChapterState extends State<ShowChapter> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getColouredVerses();
    Future.delayed(Duration(seconds: 1), () {
      if (widget.verse != -1) goToVerse();
    });
  }

  List chapterVerses2 = [];
  String selectedScripture = "";
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  bool selected = false;
  int selectedIndex = -1;
  final controller = FloatingOverlayController.relativeSize(
    maxScale: 2.0,
    minScale: 1.0,
    start: Offset.zero,
    padding: const EdgeInsets.all(20.0),
    constrained: true,
  );
  List<SaveColor> dataList = [];

  savePrefColor(verse, color) async {
    dataList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notEmpty = false;
    notEmpty = prefs.containsKey('savedColor');
    SaveColor save = SaveColor(
        book: widget.bookName,
        chapter: widget.chapter,
        verse: verse,
        color: color,
        content: selectedScripture);

    if (notEmpty) {
      String d = prefs.getString('savedColor').toString();
      // print((json.decode(d))[0]['title']);
      for (int x = 0; jsonDecode(d).length > x; x++) {
        dataList.add(SaveColor.fromJsonJson(jsonEncode(
            (json.decode(prefs.getString('savedColor').toString()))[x])));
      }
      for (int u = 0; dataList.length > u; u++) {
        if (dataList[u].book == save.book &&
            dataList[u].chapter == save.chapter &&
            dataList[u].verse == save.verse) {
          dataList.removeAt(u);
        }
      }

      dataList.add(save);
      prefs.setString('savedColor', jsonEncode(dataList));
    } else {
      dataList.add(save);
      prefs.setString('savedColor', jsonEncode(dataList));
    }
    String d = prefs.getString('savedColor').toString();
    print('//////////////////');
    print(d);
    getColouredVerses();
  }

  List<SaveColor> data = [];
  List<SaveColor> data2 = [];
  List<int> data3 = [];
  getColouredVerses() async {
    data.clear();
    data2.clear();
    data3.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('savedColor')) {
      String d = prefs.getString('savedColor').toString();
      //  CustomsavedColorModel data= CustomsavedColorModel.fromJsonJson( prefs.getString('savedColor') as String);
      //  print(data.cohortId);
      for (int x = 0; jsonDecode(d).length > x; x++) {
        data.add(SaveColor.fromJsonJson(jsonEncode(
            (json.decode(prefs.getString('savedColor').toString()))[x])));
      }
      print(data);
      for (int y = 0; data.length > y; y++) {
        if (data[y].book == widget.bookName &&
            data[y].chapter == widget.chapter) {
          data2.add(data[y]);
          data3.add(data[y].verse);
        }
      }

      print(data);
      // print(data3);
      setState(() {});
    }
  }

  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  goToVerse() {
    print(widget.verse);
    itemScrollController.scrollTo(
        index: widget.verse != 0 ? widget.verse - 1 : widget.verse,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.bookName}   ${widget.chapter}');

    return Scaffold(
        appBar: AppBar(
          leading: InkWell(child: back, onTap: () => Navigator.pop(context)),
          title: Text(
            '${widget.bookName}   ${widget.chapter}',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: FloatingOverlay(
            controller: controller,
            floatingChild: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        controller.hide();
                        savePrefColor(selectedIndex, 'red');
                      },
                      child: Container(
                        color: Colors.red,
                        height: 50,
                        width: 60,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        controller.hide();
                        savePrefColor(selectedIndex, 'blue');
                      },
                      child: Container(
                        color: Colors.blue,
                        height: 50,
                        width: 60,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        controller.hide();
                        savePrefColor(selectedIndex, 'green');
                      },
                      child: Container(
                        color: Colors.green,
                        height: 50,
                        width: 60,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        controller.hide();
                        savePrefColor(selectedIndex, 'purple');
                        // tempSave(selectedIndex, 'purple');
                      },
                      child: Container(
                        color: Colors.purple,
                        height: 50,
                        width: 60,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        controller.hide();
                        savePrefColor(selectedIndex, 'white');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        width: 60,
                        child: Text(
                          'clear',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                                text:
                                    '${chapterVerses2[selectedIndex].text} ${widget.bookName} ${widget.chapter}:${selectedIndex + 1}'))
                            .then((_) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(duration: Duration(milliseconds: 1500),
                                backgroundColor: Colors.green.withOpacity(.9),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).size.height * .2,
                                    left: 10,
                                    right: 10),
                                content: Center(child: Text("${widget.bookName} ${widget.chapter}:${selectedIndex + 1} copied to clipboard"))));
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.yellow,
                        height: 50,
                        width: 60,
                        child: Icon(Icons.copy_rounded)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: Consumer<BibleModel>(builder: (context, bibleModel, child) {
              List chapterVerses = bibleModel.bible
                  .where((bibleData) =>
                      (bibleData.book == widget.bookName) &&
                      (bibleData.chapter == widget.chapter))
                  .toList();
              chapterVerses2 = chapterVerses;
              return ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  scrollOffsetController: scrollOffsetController,
                  itemPositionsListener: itemPositionsListener,
                  scrollOffsetListener: scrollOffsetListener,
                  itemCount: chapterVerses.length,
                  itemBuilder: (BuildContext context, index) {
                    Color color = Colors.transparent;
                    if (data3.isNotEmpty && data3.contains(index)) {
                      print(index);
                      print(data3);
                      print(data3.indexOf(index));
                      // print(data2);
                      String my = data2[data3.indexOf(index)].color;
                      if (my == 'red') {
                        color = Colors.red;
                      } else if (my == 'blue') {
                        color = Colors.blue;
                      } else if (my == 'purple') {
                        color = Colors.purple;
                      } else if (my == 'green') {
                        color = Colors.green;
                      } else if (my == 'white') {
                        color = Colors.transparent;
                      }
                    }
                    return InkWell(
                      onLongPress: () {
                        // savePrefColor(index + 1, 'red');
                      },
                      onTap: () {
                        controller.toggle();
                        selected = true;
                        setState(() {
                          selectedIndex = index;
                          selectedScripture = chapterVerses[index].text;
                        });
                        print(selectedScripture);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: (widget.verse != -1 &&
                                    widget.verse == index + 1)
                                ? Colors.red.withOpacity(.3)
                                : Colors.transparent,
                          ),
                          color: (selected &&
                                  index == selectedIndex &&
                                  color == Colors.transparent)
                              ? Colors.blue.withOpacity(.3)
                              : color,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${chapterVerses[index].verse.toString()}. ${chapterVerses[index].text}',
                          style: TextStyle(
                              color: (color == Colors.purple ||
                                      color == Colors.red ||
                                      color == Colors.green ||
                                      color == Colors.blue)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16),
                        ),
                      ),
                    );
                  });
            })),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () {
              if (controller.isFloating) {
                controller.toggle();
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => SearchScreen())));
            }));
    //       options: [
    //         InkWell(onTap: () {Navigator.push(context, MaterialPageRoute(builder:
    //         (context)=>SearchScreen()));},
    //           child: CircleAvatar(
    //             child: Icon(Icons.search),
    //           ),
    //         ),
    //         CircleAvatar(
    //           child: Icon(Icons.share),
    //         ),
    //         // Container(
    //         //   // margin: EdgeInsets.symmetric(horizontal: 8),
    //         //   width: 50,
    //         //   height: 40,
    //         //   color: Colors.red,
    //         // ),
    //         // Container(
    //         //   margin: EdgeInsets.symmetric(horizontal: 8),
    //         //   width: 50,
    //         //   height: 40,
    //         //   color: Colors.green,
    //         // ),
    //         // Container(
    //         //   margin: EdgeInsets.symmetric(horizontal: 8),
    //         //   width: 50,
    //         //   height: 40,
    //         //   color: Colors.blue,
    //         // ),
    //       ],
    //       type: CustomFloatingActionButtonType.horizontal,
    //       openFloatingActionButton: const Icon(Icons.add),
    //       closeFloatingActionButton: const Icon(Icons.close));
    // }
  }
}
