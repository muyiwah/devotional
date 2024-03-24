import 'dart:convert';

import 'package:mivdevotional/core/model/save_color.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/constants/constant_widgets.dart';
import 'package:floating_overlay/floating_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:custom_floating_action_button/custom_floating_action_button.dart';

class ShowChapter extends StatefulWidget {
  final String bookName;
  final int chapter;

  ShowChapter({required this.bookName, required this.chapter});

  @override
  State<ShowChapter> createState() => _ShowChapterState();
}

class _ShowChapterState extends State<ShowChapter> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getColouredVerses();
  }

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
        color: color);

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
      for (int y = 0; data.length > y; y++) {
        if (data[y].book == widget.bookName &&
            data[y].chapter == widget.chapter) {
          data2.add(data[y]);
          data3.add(data[y].verse);
        }
      }

      print(data2);
      // print(data3);
      setState(() {});
    }
  }

  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  @override
  Widget build(BuildContext context) {
    print('${widget.bookName}   ${widget.chapter}');
    return CustomFloatingActionButton(
        body: Scaffold(
            appBar: AppBar(
              leading:
                  InkWell(child: back, onTap: () => Navigator.pop(context)),
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
                          color: Colors.white,
                          height: 50,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              child:
                  Consumer<BibleModel>(builder: (context, bibleModel, child) {
                List chapterVerses = bibleModel.bible
                    .where((bibleData) =>
                        (bibleData.book == widget.bookName) &&
                        (bibleData.chapter == widget.chapter))
                    .toList();

                return ListView.builder(
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
                          });
                        },
                        child: Container(
                          color: (selected &&
                                  index == selectedIndex &&
                                  color == Colors.transparent)
                              ? Colors.blue.withOpacity(.3)
                              : color,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${chapterVerses[index].verse.toString()}. ${chapterVerses[index].text}',
                            style: TextStyle(
                                color: (color == Colors.purple ||
                                        color == Colors.red)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16),
                          ),
                        ),
                      );
                    });
              }),
            )),
        options: [
          CircleAvatar(
            child: Icon(Icons.height),
          ),
          CircleAvatar(
            child: Icon(Icons.share),
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
        openFloatingActionButton: const Icon(Icons.add),
        closeFloatingActionButton: const Icon(Icons.close));
  }
}
