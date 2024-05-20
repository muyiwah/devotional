import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/model/reader_model.dart';
import 'package:mivdevotional/model/save_color.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/model/voiceSettings.dart';
import 'package:mivdevotional/ui/book/search_screen.dart';
import 'package:mivdevotional/ui/constants/constant_widgets.dart';
import 'package:floating_overlay/floating_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:custom_floating_action_button/custom_floating_action_button.dart';

class ShowChapter extends StatefulWidget {
  final String bookName;
  final int chapter;
  int verse;
  final bool fromSearch;
  final bool autoRead;
  int lastChapter;
  ShowChapter(
      {required this.bookName,
      required this.chapter,
      this.verse = -1,
      required this.fromSearch,
      required this.autoRead,
      this.lastChapter = 0});

  @override
  State<ShowChapter> createState() => _ShowChapterState();
}

class _ShowChapterState extends State<ShowChapter> {
  @override
  void initState() {
    print(widget.lastChapter);
    // TODO: implement initState
    super.initState();
    getColouredVerses();
    getPrefBibleVersion();
    initTts();
    if (Platform.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
    // getSavedVoice();
    getSaveVoiceSettings();
    if (widget.autoRead) {
      Future.delayed(Duration(seconds: 1), () {
        readBibleAutomatically();
      });
    }
    Future.delayed(Duration(seconds: 1), () {
      if (widget.verse != -1) goToVerse();
    });
  }

  int currentIndex = 0;

  ReaderModel _readerModel =
      ReaderModel(name: '', gender: '', identifier: '', locale: '');
  String currentlyPlayingSentence = '';
  FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;
  List<Map> _voices = [];
  int audioPlayIndex = 0;
  int? _currentWordStart, _currentWordEnd;
  List<String> _voicesString = ['Melina'];
  bool prefBibleDone = false;
  VoiceSettings _voiceSettings = VoiceSettings(
    volume: .7,
    rate: .5,
    pitch: .5,
  );

  Future<void> _getDefaultEngine() async {
    var engine = await _flutterTts.getDefaultEngine;
    if (engine != null) {
      // print(engine);
    }
  }

  Future<void> _getDefaultVoice() async {
    var voice = await _flutterTts.getDefaultVoice;
    if (voice != null) {
      // print(voice);
    }
  }

  readBibleAutomatically() async {
    allScripture.clear();

    if (Platform.isAndroid) {
      await _flutterTts.setVolume(_voiceSettings.volume);
      await _flutterTts.setSpeechRate(_voiceSettings.rate);
      await _flutterTts.setPitch(_voiceSettings.pitch);
      if (widget.bookName.contains('1')) {
        await _flutterTts.speak(
            'first ${widget.bookName.split(' ')[1]} chapter ${widget.chapter}');
      } else if (widget.bookName.contains('2')) {
        await _flutterTts.speak(
            'second ${widget.bookName.split(' ')[1]} chapter ${widget.chapter}');
      } else if (widget.bookName.contains('3')) {
        await _flutterTts.speak(
            'third ${widget.bookName.split(' ')[1]} chapter ${widget.chapter}');
      } else {
        await _flutterTts.speak('${widget.bookName} chapter ${widget.chapter}');
      }
      // await _flutterTts.speak('chapter');
      // await _flutterTts.speak(widget.chapter.toString());
      for (int x = 0; chapterVerses2.length > x; x++) {
        await _flutterTts.setVolume(_voiceSettings.volume);
        // await _flutterTts.setSpeechRate(_voiceSettings.rate);
        // await _flutterTts.setPitch(_voiceSettings.pitch);
        await _flutterTts.awaitSpeakCompletion(true);
        if (x % 10 == 0) {
          await _flutterTts.speak('verse ${x + 1}');
        }
        await _flutterTts.speak(chapterVerses2[x].text);
        allScripture.add(chapterVerses2[x].text);
        audioPlayIndex = x;
      }
      y = 0;
    }
    if (Platform.isIOS) {
      await _flutterTts.setVolume(_voiceSettings.volume);
      await _flutterTts.setSpeechRate(_voiceSettings.rate);
      await _flutterTts.setPitch(_voiceSettings.pitch);
      if (widget.bookName.contains('1')) {
        await _flutterTts.speak('first');
        await _flutterTts.speak(widget.bookName.split(' ')[1]);
      } else if (widget.bookName.contains('2')) {
        await _flutterTts.speak('second');
        await _flutterTts.speak(widget.bookName.split(' ')[1]);
      } else if (widget.bookName.contains('3')) {
        await _flutterTts.speak('third');
        await _flutterTts.speak(widget.bookName.split(' ')[1]);
      } else {
        await _flutterTts.speak(widget.bookName);
      }
      await _flutterTts.speak('chapter');
      await _flutterTts.speak(widget.chapter.toString());

      for (int x = 0; chapterVerses2.length > x; x++) {
        if (x % 10 == 0) {
          await _flutterTts.speak('verse ${x + 1}');
        }
        _flutterTts.speak(chapterVerses2[x].text);
        allScripture.add(chapterVerses2[x].text);
        // print(allScripture[x]);
        audioPlayIndex = x;
      }
      setState(() {});
    }
  }

  void setVoiceN() {
    print(_readerModel);

    _flutterTts
        .setVoice({'name': _readerModel.name, 'locale': _readerModel.locale});
  }

  getPrefBibleVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//
    if (prefs.containsKey('prefBible')) {
      selection = prefs.getString('prefBible').toString();
      prefBibleDone = true;
      print(jsonDecode(selection));
      selection = jsonDecode(selection);
      setState(() {});
    }
  }

  getSaveVoiceSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('voiceSettings')) {
      String d = (prefs.getString('voiceSettings').toString());

      _voiceSettings = VoiceSettings.fromJsonJson(jsonEncode(jsonDecode(d)));

      print((_voiceSettings.volume));
    }
  }

  int y = 0;

  initTts() async {
    _flutterTts.setProgressHandler((text, start, end, word) async {
      int x = 0;
      // print(word);
      // print(start);
      // print(end);
      // print(currentlyPlayingSentence);
      // if (word=='service'){
      //   print('enmds wit service');
      //   print(currentlyPlayingSentence);
      // print(text.endsWith('${word}.'));
// await _flutterTts.awaitSpeakCompletion(true);
// if(Platform.isIOS){
      currentlyPlayingSentence = text;

      if (currentlyPlayingSentence.endsWith(word) ||
          currentlyPlayingSentence.endsWith('${word}.') ||
          currentlyPlayingSentence.endsWith('${word})') ||
          currentlyPlayingSentence.endsWith('${word}!') ||
          currentlyPlayingSentence.endsWith('${word}"') ||
          currentlyPlayingSentence.endsWith('${word}".') ||
          currentlyPlayingSentence.endsWith('${word},') ||
          currentlyPlayingSentence.endsWith('${word}:') ||
          currentlyPlayingSentence.endsWith('${word};') ||
          currentlyPlayingSentence.endsWith('${word}?')) {
        // print(text);

        x = (chapterVerses2
            .indexWhere((element) => element.text == currentlyPlayingSentence));
        print('xxxxxxxxxxxxx=$x');
        if ((x.isEven && (x < chapterVerses2.length - 5))) {
          scollToVerse(x);
        }
        if ((x==-1)) {
          scollToVerse(0);
        }
        if (Platform.isAndroid) {
          if (mounted &&
              chapterVerses2[chapterVerses2.length - 1].text ==
                  currentlyPlayingSentence &&
              widget.chapter != widget.lastChapter &&
              widget.verse == -1) {
            if (currentlyPlayingSentence.endsWith(word) ||
                currentlyPlayingSentence.endsWith('${word}.') ||
                currentlyPlayingSentence.endsWith('${word}!') ||
                currentlyPlayingSentence.endsWith('${word})') ||
                currentlyPlayingSentence.endsWith('${word}"') ||
                currentlyPlayingSentence.endsWith('${word}".') ||
                currentlyPlayingSentence.endsWith('${word},') ||
                currentlyPlayingSentence.endsWith('${word}:') ||
                currentlyPlayingSentence.endsWith('${word};') ||
                currentlyPlayingSentence.endsWith('${word}?')) {
              print('hererre now');
              Future.delayed(Duration(seconds: 2), () async {
                await _flutterTts.speak('Next chapter');
                await _flutterTts.stop();
                Navigator.pop(context, 'next ${widget.chapter}');
              });
            }
          }
          setState(() {});
        } else {
          if (mounted &&
              allScripture.last == currentlyPlayingSentence &&
              widget.chapter != widget.lastChapter &&
              widget.verse == -1) {
            if (currentlyPlayingSentence.endsWith(word) ||
                currentlyPlayingSentence.endsWith('${word}.') ||
                currentlyPlayingSentence.endsWith('${word},') ||
                currentlyPlayingSentence.endsWith('${word}"') ||
                currentlyPlayingSentence.endsWith('${word}".') ||
                currentlyPlayingSentence.endsWith('${word}:') ||
                currentlyPlayingSentence.endsWith('${word};') ||
                currentlyPlayingSentence.endsWith('${word}?')) {
              Future.delayed(Duration(seconds: 3), () async {
                await _flutterTts.speak('Next chapter');
                await _flutterTts.stop();
                Navigator.pop(context, 'next ${widget.chapter}');
              });
            }
          }
          setState(() {});
        }
      }
      // }
      // else{
      // print(y);

// // currentlyPlayingSentence=chapterVerses2[y].text.toString();
//  if (currentlyPlayingSentence.endsWith(word)
//       ||
//           currentlyPlayingSentence.endsWith('${word}.') ||
//           currentlyPlayingSentence.endsWith('${word},') ||
//           currentlyPlayingSentence.endsWith('${word}:') ||
//           currentlyPlayingSentence.endsWith('${word};') ||
//           currentlyPlayingSentence.endsWith('${word}?')
//           ) {
//      y++;
//         print('`sssssssssssssssss');
//         print(chapterVerses2[y].text);
//                           await _flutterTts.speak(allScripture[1]);

// currentlyPlayingSentence=chapterVerses2[1].text;
// print(currentlyPlayingSentence);
//         x = (chapterVerses2
//             .indexWhere((element) => element.text == currentlyPlayingSentence));

//         if (x.isEven) {
//           scollToVerse(x);
//         }
//       }

//       }
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
// prefBible
    if (prefs.containsKey('savedReader')) {
      String d = prefs.getString('savedReader').toString();
      _readerModel = ReaderModel.fromJsonJson(jsonEncode(jsonDecode(d)));
      setVoiceN();
    } else {
      _flutterTts.getVoices.then((data) {
        try {
          _voicesString.clear();
          _voices = List<Map>.from(data);
          setState(() {
            _voices = _voices
                .where((_voice) => _voice['name'].contains('en'))
                .toList();
            // _voices.forEach(
            //   (voi) => _voicesString.add(voi['name']),
            // );
            print(_voices);
            _currentVoice = _voices[2];
            setVoice2();
          });
        } catch (e) {
          print(e);
        }
      });
    }
  }

  setVoice2() {
    print(_currentVoice);
    _flutterTts.setVoice(
        {'name': _currentVoice!['name'], 'locale': _currentVoice!['locale']});
  }

  List<String> allScripture = [];
  String selection = 'KJV';

  bool kjv = true;
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
    getColouredVerses();
  }

  List<SaveColor> data = [];
  List<SaveColor> data2 = [];
  List<int> data3 = [];

  getSavedVoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('savedReader')) {
      String d = prefs.getString('savedReader').toString();
      ReaderModel _readerModel =
          ReaderModel.fromJsonJson(jsonEncode(jsonDecode(d)));
    }
  }

  getColouredVerses() async {
    data.clear();
    data2.clear();
    data3.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('savedColor')) {
      String d = prefs.getString('savedColor').toString();
      //  CustomsavedColorModel data= CustomsavedColorModel.fromJsonJson( prefs.getString('savedColor') as String);
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

      setState(() {});
    }
  }

  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  goToVerse() {
    itemScrollController.scrollTo(
        index: widget.verse != 0 ? widget.verse - 1 : widget.verse,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  scollToVerse(pos) {
    itemScrollController.scrollTo(
        index: pos,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  List<String> _list = [
    'KJV',
    'NIV',
    'NLT',
    'MSG',
    'AMP',
    'ASV',
    'DBY',
    'BBE',
    'RSV',
    'BISHOP',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            InkWell(child: back, onTap: () => Navigator.pop(context, 'nill')),
        title: Text(
          '${widget.bookName}   ${widget.chapter}',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // if(prefBibleDone)

          Container(
            width: 90,
            margin: EdgeInsets.only(right: 20, top: 6),
            child: CustomDropdown<String>(
              maxlines: 1,
              closedHeaderPadding: EdgeInsets.all(10),
              decoration: CustomDropdownDecoration(
                // expandedFillColor: Colors.white,
                // headerStyle: TextStyle(color: Colors.white, fontSize: 14),
                closedFillColor: Colors.blue,
                listItemStyle: TextStyle(color: Colors.blue, fontSize: 14),
              ),
              hintText: '',
              items: _list,
              initialItem: selection,
              onChanged: (value) {
                controller.hide();
                selection = value;
                setState(() {});
              },
            ),
          ),
        ],
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
                      controller.hide();

                      Clipboard.setData(ClipboardData(
                              text:
                                  '${chapterVerses2[selectedIndex].text} ${widget.bookName} ${widget.chapter}:${selectedIndex + 1}'))
                          .then((_) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 1500),
                              backgroundColor: Colors.green.withOpacity(.9),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * .2,
                                  left: 10,
                                  right: 10),
                              content: Center(
                                  child: Text(
                                      "${widget.bookName} ${widget.chapter}:${selectedIndex + 1} copied to clipboard"))));
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        color: Colors.yellow,
                        height: 50,
                        width: 60,
                        child: Icon(Icons.copy_rounded)),
                  ),
                ),
              ),
            ],
          ),
          child: Consumer<BibleModel>(builder: (context, bibleModel, child) {
            List chapterVerses = selection == 'KJV'
                ? bibleModel.bible
                    .where((bibleData) =>
                        (bibleData.book == widget.bookName) &&
                        (bibleData.chapter == widget.chapter))
                    .toList()
                : selection == "AMP"
                    ? bibleModel.bibleAmp
                        .where((bibleData) =>
                            (bibleData.book == widget.bookName) &&
                            (bibleData.chapter == widget.chapter))
                        .toList()
                    : selection == "NIV"
                        ? bibleModel.bibleNiv
                            .where((bibleData) =>
                                (bibleData.book == widget.bookName) &&
                                (bibleData.chapter == widget.chapter))
                            .toList()
                        : selection == "MSG"
                            ? bibleModel.bibleMsg
                                .where((bibleData) =>
                                    (bibleData.book == widget.bookName) &&
                                    (bibleData.chapter == widget.chapter))
                                .toList()
                            : selection == "BISHOP"
                                ? bibleModel.bibleBishop
                                    .where((bibleData) =>
                                        (bibleData.book == widget.bookName) &&
                                        (bibleData.chapter == widget.chapter))
                                    .toList()
                                : selection == "NLT"
                                    ? bibleModel.bibleNlt
                                        .where((bibleData) =>
                                            (bibleData.book == widget.bookName) &&
                                            (bibleData.chapter ==
                                                widget.chapter))
                                        .toList()
                                    : selection == "RSV"
                                        ? bibleModel.bibleRsv
                                            .where((bibleData) =>
                                                (bibleData.book == widget.bookName) &&
                                                (bibleData.chapter ==
                                                    widget.chapter))
                                            .toList()
                                        : selection == "DBY"
                                            ? bibleModel.bibleDby
                                                .where((bibleData) =>
                                                    (bibleData.book ==
                                                        widget.bookName) &&
                                                    (bibleData.chapter ==
                                                        widget.chapter))
                                                .toList()
                                            : selection == "BBE"
                                                ? bibleModel.bibleBbe
                                                    .where((bibleData) =>
                                                        (bibleData.book ==
                                                            widget.bookName) &&
                                                        (bibleData.chapter ==
                                                            widget.chapter))
                                                    .toList()
                                                : bibleModel.bibleAsv
                                                    .where((bibleData) => (bibleData.book == widget.bookName) && (bibleData.chapter == widget.chapter))
                                                    .toList();
            chapterVerses2 = chapterVerses;
            return ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                scrollOffsetController: scrollOffsetController,
                itemPositionsListener: itemPositionsListener,
                scrollOffsetListener: scrollOffsetListener,
                itemCount: chapterVerses.length,
                itemBuilder: (BuildContext context, index) {
                  currentIndex = index + 1;
                  Color color = Colors.transparent;
                  if (data3.isNotEmpty && data3.contains(index)) {
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
                    onLongPress: () async {
                      print(chapterVerses[index].text);
                      await Share.share(
                        '${widget.bookName} ${widget.chapter}:${chapterVerses[index].verse}  ($selection)\n${chapterVerses[index].text}\nhttps://play.google.com/store/apps/details?id=com.miv.devotional',
                      );
                    },
                    onTap: () {
                      controller.toggle();
                      selected = true;
                      setState(() {
                        selectedIndex = index;
                        selectedScripture = chapterVerses[index].text;
                      });
                    },
                    child:
                        //  Container(
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: (widget.verse != -1 &&
                        //               widget.verse == index + 1)
                        //           ? Colors.red.withOpacity(.3)
                        //           : Colors.transparent,
                        //     ),
                        //     color: (selected &&
                        //             index == selectedIndex &&
                        //             color == Colors.transparent)
                        //         ? Colors.blue.withOpacity(.3)
                        //         : color,
                        //   ),
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: RichText(
                        //     text: TextSpan(
                        //       children: [
                        //        TextSpan(
                        //                 text:
                        //                     '${chapterVerses[index].verse.toString()}. ',
                        //                 style: TextStyle(color: Colors.black)),
                        //         TextSpan(
                        //           text:
                        //               '${chapterVerses[index].text.toString()}',
                        //           style: TextStyle(
                        //               color: (color == Colors.purple ||
                        //                       color == Colors.red ||
                        //                       color == Colors.green ||
                        //                       color == Colors.blue)
                        //                   ? Colors.white
                        //                   : Colors.black,
                        //               fontSize: 16),
                        //         ),

                        //           TextSpan(
                        //             text:
                        //                 '${chapterVerses[index].text.toString().substring(_currentWordStart!, _currentWordEnd)}',
                        //             style: TextStyle(
                        //                 backgroundColor: Colors.yellow,
                        //                 color: (color == Colors.purple ||
                        //                         color == Colors.red ||
                        //                         color == Colors.green ||
                        //                         color == Colors.blue)
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //                 fontSize: 16),
                        //           ),

                        //           TextSpan(
                        //             text:
                        //                 '${chapterVerses[index].text.toString().substring(_currentWordEnd!)}',
                        //             style: TextStyle(
                        //                 color: (color == Colors.purple ||
                        //                         color == Colors.red ||
                        //                         color == Colors.green ||
                        //                         color == Colors.blue)
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //                 fontSize: 16),
                        //           ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              (widget.verse != -1 && widget.verse == index + 1)
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
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    '${chapterVerses[index].verse.toString()}. ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: currentlyPlayingSentence ==
                                      chapterVerses[index].text
                                  ? '${chapterVerses[index].text.toString().substring(0, _currentWordStart)}'
                                  : '${chapterVerses[index].text.toString()}',
                              style: TextStyle(
                                  color: (color == Colors.purple ||
                                          color == Colors.red ||
                                          color == Colors.green ||
                                          color == Colors.blue)
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16),
                            ),
                            if (_currentWordStart != null &&
                                currentlyPlayingSentence ==
                                    chapterVerses[index].text)
                              TextSpan(
                                text:
                                    '${chapterVerses[index].text.toString().substring(_currentWordStart!, _currentWordEnd)}',
                                style: TextStyle(
                                    backgroundColor: Colors.yellow,
                                    color: (color == Colors.purple ||
                                            color == Colors.red ||
                                            color == Colors.green ||
                                            color == Colors.blue)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                            if (_currentWordEnd != null &&
                                currentlyPlayingSentence ==
                                    chapterVerses[index].text)
                              TextSpan(
                                text:
                                    '${chapterVerses[index].text.toString().substring(_currentWordEnd!)}',
                                style: TextStyle(
                                    color: (color == Colors.purple ||
                                            color == Colors.red ||
                                            color == Colors.green ||
                                            color == Colors.blue)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          })),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: widget.fromSearch == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.small(
                    heroTag: '1',
                    child: Icon(
                        (_currentWordStart != null && _currentWordStart! != 0)
                            ? Icons.stop
                            : Icons.volume_mute),
                    onPressed: () async {
                      if (_currentWordStart != null &&
                          _currentWordStart! != 0) {
                        // _flutterTts.setCompletionHandler(() { })
                        await _flutterTts.stop();
                        await _flutterTts.speak('');
                        await _flutterTts.stop();

                        _currentWordStart = 0;
                        setState(() {});
                      } else {
                        print('speak');
                        allScripture.clear();

                        if (Platform.isAndroid) {
                          await _flutterTts.setVolume(_voiceSettings.volume);
                          await _flutterTts.setSpeechRate(_voiceSettings.rate);
                          await _flutterTts.setPitch(_voiceSettings.pitch);
                          if (widget.bookName.contains('1')) {
                            await _flutterTts.speak(
                                'first ${widget.bookName.split(' ')[1]} chapter ${widget.chapter}');
                          } else if (widget.bookName.contains('2')) {
                            await _flutterTts.speak(
                                'second ${widget.bookName.split(' ')[1]} chapter ${widget.chapter}');
                          } else if (widget.bookName.contains('3')) {
                            await _flutterTts.speak(
                                'third ${widget.bookName.split(' ')[1]} chapter ${widget.chapter}');
                          } else {
                            await _flutterTts.speak(
                                '${widget.bookName} chapter ${widget.chapter}');
                          }
                          // await _flutterTts.speak('chapter');
                          // await _flutterTts.speak(widget.chapter.toString());
                          for (int x = 0; chapterVerses2.length > x; x++) {
                            await _flutterTts.setVolume(_voiceSettings.volume);
                            // await _flutterTts.setSpeechRate(_voiceSettings.rate);
                            // await _flutterTts.setPitch(_voiceSettings.pitch);
                            await _flutterTts.awaitSpeakCompletion(true);
                            allScripture.add(chapterVerses2[x].text);
                            if (x % 10 == 0) {
                              await _flutterTts.speak('verse ${x + 1}');
                            }
                            await _flutterTts.speak(chapterVerses2[x].text);
                            audioPlayIndex = x;
                          }
                          y = 0;
                        }
                        if (Platform.isIOS) {
                          await _flutterTts.setVolume(_voiceSettings.volume);
                          await _flutterTts.setSpeechRate(_voiceSettings.rate);
                          await _flutterTts.setPitch(_voiceSettings.pitch);
                          if (widget.bookName.contains('1')) {
                            await _flutterTts.speak('first');
                            await _flutterTts
                                .speak(widget.bookName.split(' ')[1]);
                          } else if (widget.bookName.contains('2')) {
                            await _flutterTts.speak('second');
                            await _flutterTts
                                .speak(widget.bookName.split(' ')[1]);
                          } else if (widget.bookName.contains('3')) {
                            await _flutterTts.speak('third');
                            await _flutterTts
                                .speak(widget.bookName.split(' ')[1]);
                          } else {
                            await _flutterTts.speak(widget.bookName);
                          }
                          await _flutterTts.speak('chapter');
                          await _flutterTts.speak(widget.chapter.toString());

                          for (int x = 0; chapterVerses2.length > x; x++) {
                            if (x % 10 == 0) {
                              await _flutterTts.speak('verse ${x + 1}');
                            }
                            _flutterTts.speak(chapterVerses2[x].text);
                            allScripture.add(chapterVerses2[x].text);
                            // print(allScripture[x]);
                            audioPlayIndex = x;
                          }
                          setState(() {});
                        }
                      }
                    },
                  ),
                  FloatingActionButton(
                      heroTag: '2',
                      child: Icon(Icons.search),
                      onPressed: () {
                        if (controller.isFloating) {
                          controller.toggle();
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SearchScreen())));
                      }),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
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
