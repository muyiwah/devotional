import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mivdevotional/model/reader_model.dart';
import 'package:mivdevotional/model/save_color.dart';
import 'package:mivdevotional/devotion_screen.dart';
import 'package:mivdevotional/model/voiceSettings.dart';
import 'package:mivdevotional/ui/bibleplanselect.dart';
import 'package:mivdevotional/ui/home/saved_scriptures.dart';
import 'package:mivdevotional/utils/snack.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningToolCreateEvent extends StatefulWidget {
  LearningToolCreateEvent({super.key});

  @override
  State<LearningToolCreateEvent> createState() =>
      _LearningToolCreateEventState();
}

class _LearningToolCreateEventState extends State<LearningToolCreateEvent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTts();
    getFontSize();
    getPreferredBible();
    if (Platform.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
    getSaveVoiceSettings();
  }

  bool sundaySelected = true;
  bool mondaySelected = true;
  bool tuesdaySelected = true;
  bool wednesdaySelected = true;
  bool thursdaySelected = true;
  bool fridaySelected = true;
  bool saturdayelected = true;

  VoiceSettings _voiceSettings =
      VoiceSettings(volume: .5, rate: .5, pitch: 1.0);
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  double freqheight = 0;
  Future<void> _getDefaultEngine() async {
    var engine = await _flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  double appfontSize = 1;

  getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fontSize')) {
      appfontSize = prefs.getDouble('fontSize') ?? 0;
      setState(() {});
    }
  }
getPreferredBible()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
//
    if (prefs.containsKey('prefBible')) {
      selection = prefs.getString('prefBible').toString();
      // print(jsonDecode(selection));
      selection = jsonDecode(selection);
      print('selection $selection');
      if (mounted) setState(() {});
    }
}
  Future<void> _getDefaultVoice() async {
    var voice = await _flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  getSaveVoiceSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('voiceSettings')) {
      String d = (prefs.getString('voiceSettings').toString());
      print(VoiceSettings.fromJsonJson(jsonEncode(jsonDecode(d))));
      _voiceSettings = VoiceSettings.fromJsonJson(jsonEncode(jsonDecode(d)));
      volume = _voiceSettings.volume;
      pitch = _voiceSettings.pitch;
      rate = _voiceSettings.rate;
      setState(() {});
      print((_voiceSettings.volume));
    }
  }

  String selectedReader = "Karen";
  String selectedReaderAndroid = "en-gb-x-gba-network";

  int? _currentWordStart, _currentWordEnd;
  String _currentlyPlayingSentence = '';
  String playVoice =
      "This is my voice texture. You can select from the list of other voices for your preferred audio bible reader";
  List<Map> _voices = [];
  FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;
  List<ReaderModel> readerDesc = [];
  ReaderModel _readerModel = ReaderModel(
    name: '',
    gender: '',
    identifier: '',
    locale: '',
  );
  double readerHeight = 0;
  ReaderModel myReader =
      ReaderModel(name: 'dd', gender: '', identifier: '', locale: '');
  List<String> _voicesString = [];
  initTts() async {
    readerDesc.clear();
    getColouredVerses();

    _flutterTts.setProgressHandler((text, start, end, word) {
      _currentlyPlayingSentence = text;
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('savedReader')) {
      String d = prefs.getString('savedReader').toString();
      _readerModel = ReaderModel.fromJsonJson(jsonEncode(jsonDecode(d)));
      setVoiceN();
      setState(() {});
    }

    if (Platform.isIOS) {
      _flutterTts.getVoices.then((data) {
        try {
          _voicesString.clear();
          _voices = List<Map>.from(data);
          setState(() {
            _voices = _voices
                .where((_voice) => _voice['locale'].contains('en'))
                .toList();
            // print(_voices);
            _voices = _voices
                .where((voice) =>
                    voice['name'] != 'Trinoids' &&
                    voice['name'] != 'Albert' &&
                    voice['name'] != 'Jester' &&
                    voice['name'] != 'Whisper' &&
                    voice['name'] != 'Superstar' &&
                    voice['name'] != 'Bells' &&
                    voice['name'] != 'Bad News' &&
                    voice['name'] != 'Bubbles' &&
                    voice['name'] != 'Bahh' &&
                    voice['name'] != 'Junior' &&
                    voice['name'] != 'Wobble' &&
                    voice['name'] != 'Zarvox' &&
                    voice['name'] != 'Boing')
                .toList();
            // _voices.forEach(
            //   (voi) => _voicesString.add(voi['name']),
            // );
            _voices.forEach((element) =>
                readerDesc.add(ReaderModel.fromJson(jsonEncode(element))));
            // print(_voices);
            print(_voices.length);
            if (prefs.containsKey('savedReader')) {
            } else {
              _currentVoice = _voices[0];
              setVoiceNow(_currentVoice!);
            }
          });
        } catch (e) {
          print(e);
        }
      });
    } else {
      _flutterTts.getVoices.then((data) {
        try {
          _voicesString.clear();
          _voices = List<Map>.from(data);
          setState(() {
            _voices = _voices
                .where((_voice) => _voice['name'].contains('en'))
                .toList();
            print(_voices);
            print(_voices.length);
            _voices = _voices
                .where((voice) =>
                    voice['name'] != 'Trinoids' &&
                    voice['name'] != 'Albert' &&
                    voice['name'] != 'Jester' &&
                    voice['name'] != 'Whisper' &&
                    voice['name'] != 'Superstar' &&
                    voice['name'] != 'Bells' &&
                    voice['name'] != 'Bad News' &&
                    voice['name'] != 'Bubbles' &&
                    voice['name'] != 'Bahh' &&
                    voice['name'] != 'Junior' &&
                    voice['name'] != 'Wobble' &&
                    voice['name'] != 'Zarvox' &&
                    voice['name'] != 'Boing')
                .toList();
            // _voices.forEach(
            //   (voi) => _voicesString.add(voi['name']),
            // );
            _voices.forEach((element) =>
                readerDesc.add(ReaderModel.fromJson(jsonEncode(element))));
            print(readerDesc);
            print(_voices.length);
            if (prefs.containsKey('savedReader')) {
            } else {
              _currentVoice = _voices[0];
              setVoiceNow(_currentVoice!);
            }
          });
        } catch (e) {
          print(e);
        }
      });
    }
  }

  void setVoiceN() {
    _flutterTts
        .setVoice({'name': _readerModel.name, 'locale': _readerModel.locale});
    selectedReader = _readerModel.name;
  }

  savePrefVoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(myReader);
    prefs.setString('savedReader', jsonEncode(myReader));

    String d = prefs.getString('savedReader').toString();
    print(d);
  }

  saveVoiceSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('voiceSettings', jsonEncode(_voiceSettings));

    String d = prefs.getString('voiceSettings').toString();
    print(jsonDecode(d));
  }

  saveFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('fontSize', appfontSize);
  }

  savePrefBbible(bible) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('prefBible', jsonEncode(bible));

    String d = prefs.getString('prefBible').toString();
    print(d);
  }

  setVoiceNow(Map voice) {
    _flutterTts.setVoice({'name': voice['name'], 'locale': voice['locale']});
  }

  getSavedVoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('savedReader')) {
      String d = prefs.getString('savedReader').toString();
      _readerModel = ReaderModel.fromJsonJson(jsonEncode(jsonDecode(d)));
    }
  }

  getColouredVerses() async {
    data.clear();
    data2.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notEmpty = prefs.containsKey('savedColor');
    if (notEmpty) {
      if (prefs.containsKey('savedColor')) {
        String d = prefs.getString('savedColor').toString();
        //  CustomsavedColorModel data= CustomsavedColorModel.fromJsonJson( prefs.getString('savedColor') as String);
        //  print(data.cohortId);
        for (int x = 0; jsonDecode(d).length > x; x++) {
          data2.add(SaveColor.fromJsonJson(jsonEncode(
              (json.decode(prefs.getString('savedColor').toString()))[x])));
        }

        for (int d = 0; data2.length > d; d++) {
          if (data2[d].color != 'white') {
            data.add(data2[d]);
          }
        }
      }

      print(data);
    }
    // print(data3);
    setState(() {});
  }

  bool checkbox1IsChecked = false;

  TimeOfDay selectedTime = TimeOfDay.now();
  bool checkbox1IsChecked2 = false;
  String dob = '';
  final TextEditingController _dateOfBirthController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _dateOfBirthController.dispose();
    _controller.dispose();
  }

  List<SaveColor> data = [];
  List<SaveColor> data2 = [];
  int indexNew = 0;
  List<String> selectedCourses = [];
  bool checkbox1IsChecked3 = false;
  String selection = 'KJV';
  String chipSelected = "";
  String readerchipSelected = "Male";
  List<String> chipData = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  List<String> reader = [
    'Male',
    'Female',
  ];

  final TextEditingController _controller = TextEditingController();

  void pickDate() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (newDate != null) {
      dob = newDate.toString().split(' ')[0];
    }

    //  print((newDate!).difference(DateTime.now()));
    //  print((newDate!).compareTo(DateTime.timestamp()));
    //  print(newDate);
    //  print((DateTime.timestamp()));
    //  print((DateTime.parse("2012-02-27 13:27:00")));
    print(TimeOfDay.fromDateTime(
        DateTime.parse(newDate.toString()).add(Duration(hours: 1))));

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Others',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18 + appfontSize),
          ),
          // backgroundColor: mentorScreenBgc,
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          height: double.infinity,
          decoration: BoxDecoration(
              // color: Colors.green,
              ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 25,
                // ),
                SizedBox(
                  height: 90,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Select default bible version',
                  style: TextStyle(
                      fontSize: 18 + appfontSize, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                  child: DropdownButton(
                      isExpanded: true,
                      value: selection,
                      items: [
                        DropdownMenuItem(
                          child: Text('King James Version (KJV)'),
                          value: 'KJV',
                        ),
                        DropdownMenuItem(
                          child: Text('Amplified (AMP)'),
                          value: 'AMP',
                        ),
                        DropdownMenuItem(
                          child: Text('New International Version (NIV)'),
                          value: 'NIV',
                        ),
                        DropdownMenuItem(
                          child: Text('New Living Translation (NLT)'),
                          value: 'NLT',
                        ),
                        DropdownMenuItem(
                          child: Text('Message Bible (MSG)'),
                          value: 'MSG',
                        ),
                        DropdownMenuItem(
                          child: Text('Revised Standard Version (RSV)'),
                          value: 'RSV',
                        ),
                        DropdownMenuItem(
                          child: Text('Derby Bible (DBY)'),
                          value: 'DBY',
                        ),
                        DropdownMenuItem(
                          child: Text('Basic Bible Editin (BBE)'),
                          value: 'BBE',
                        ),
                        DropdownMenuItem(
                          child: Text('American Standard Version (ASV)'),
                          value: 'ASV',
                        ),
                        DropdownMenuItem(
                          child: Text('Bishop Bible (BISHOP)'),
                          value: 'BISHOP',
                        ),
                      ],
                      onChanged: (value) {
                        selection = value!;
                        print(value);
                        savePrefBbible(value);
                        if (mounted) setState(() {});
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Change App font size',
                  style: TextStyle(
                      fontSize: 18 + appfontSize, fontWeight: FontWeight.w600),
                ),

                _appFontSize(),
                SizedBox(
                  height: 20,
                ),

                // Center(
                //   child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.deepPurple.withOpacity(.3),
                //           minimumSize:
                //               Size(MediaQuery.sizeOf(context).width * .7, 50)),
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (_) => Bibleplanselect())).then((e) {
                //           print(e);
                //                      if (e != null) {
                //             showsnack(
                //                 context, Colors.green, '${e} plan selected');
                //           }

                //         });
                //       },
                //       child: Text(
                //         'Daily Reading Plan',
                //         style: TextStyle(color: Colors.white),
                //       )),
                // ),
                // SizedBox(
                //   height: 35,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Preferred Reader',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18 + appfontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (Platform.isIOS)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    child: DropdownButton(
                        isExpanded: true,
                        value: selectedReader,
                        items: readerDesc
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(
                                  'Name: ${e.name}    Gender: ${e.gender}',
                                ),
                                value: e.name,
                                onTap: () async {
                                  myReader.gender = e.gender;
                                  myReader.name = e.name;
                                  myReader.identifier = e.identifier;
                                  myReader.locale = e.locale;
                                  savePrefVoice();
                                  _flutterTts.stop();
                                  _flutterTts.setVoice(
                                      {'name': e.name, 'locale': e.locale});
                                  await _flutterTts.setVolume(volume);
                                  await _flutterTts.setSpeechRate(rate);
                                  await _flutterTts.setPitch(pitch);
                                  _flutterTts.speak(playVoice);
                                  readerHeight = 100;
                                  setState(() {});
                                },
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          selectedReader = value!;
                          if (mounted) setState(() {});
                        }),
                  ),

                if (Platform.isAndroid)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    child: DropdownButton(
                        isExpanded: true,
                        value: selectedReaderAndroid,
                        items: readerDesc
                            .mapIndexed(
                              (index, e) => DropdownMenuItem(
                                child: Text('Voice ${index + 1}'),
                                // child: Text(e.name),
                                // Text(
                                //   'Name: ${e.name}    Gender: ${e.gender}',
                                // ),
                                value: e.name,
                                onTap: () {
                                  myReader.gender = e.gender;
                                  myReader.name = e.name;
                                  myReader.identifier = e.identifier;
                                  myReader.locale = e.locale;
                                  savePrefVoice();
                                  _flutterTts.stop();
                                  _flutterTts.setVoice(
                                      {'name': e.name, 'locale': e.locale});
                                  _flutterTts.speak(playVoice);
                                  readerHeight = 100;
                                  setState(() {});
                                },
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          selectedReaderAndroid = value!;
                          if (mounted) setState(() {});
                        }),
                  ),
                SizedBox(
                  height: 15,
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  padding: EdgeInsets.all(20),
                  height: readerHeight,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.2),
                      borderRadius: BorderRadius.circular(12)),
                  // child: Text(playVoice),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: _currentlyPlayingSentence == playVoice
                                ? playVoice.substring(0, _currentWordStart)
                                : playVoice,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16 + (appfontSize * .3))),
                        if (_currentWordStart != null &&
                            _currentlyPlayingSentence == playVoice)
                          TextSpan(
                            text: playVoice.substring(
                                _currentWordStart!, _currentWordEnd),
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Colors.black,
                                fontSize: 16 + appfontSize),
                          ),
                        if (_currentWordEnd != null &&
                            _currentlyPlayingSentence == playVoice)
                          TextSpan(
                              text: playVoice.substring(
                                _currentWordEnd!,
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16 + appfontSize)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: _buildSliders()),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'Set Notification Frequency',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                // ),
                // SizedBox(
                //   height: 10,
                // ),

                // Wrap(
                //   spacing: 20,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         if (freqheight == 140) {
                //           freqheight = 0;
                //           setState(() {});
                //         } else {
                //           freqheight = 140;
                //           setState(() {});
                //         }
                //       },
                //       child: Chip(
                //           backgroundColor: (saturdayelected == true &&
                //                   sundaySelected == true &&
                //                   mondaySelected == true &&
                //                   tuesdaySelected == true &&
                //                   wednesdaySelected == true &&
                //                   thursdaySelected == true &&
                //                   fridaySelected == true)
                //               ? Colors.green
                //               : Colors.orange,
                //           label: Text(
                //             'Days/Daily',
                //             style: TextStyle(color: Colors.white, fontSize: 14),
                //           )),
                //     ),
                //     // Chip(label: Text('Select Days')),
                //     Chip(
                //         backgroundColor: Colors.green,
                //         label: Wrap(
                //           runAlignment: WrapAlignment.center,
                //           crossAxisAlignment: WrapCrossAlignment.center,
                //           children: [
                //             Icon(
                //               Icons.timelapse,
                //               color: Colors.white,
                //             ),
                //             Text(
                //               ' Time',
                //               style:
                //                   TextStyle(color: Colors.white, fontSize: 14),
                //             ),
                //           ],
                //         )),
                //   ],
                // ),

                // AnimatedContainer(
                //   padding: EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(.2),
                //       borderRadius: BorderRadius.circular(12)),
                //   duration: Duration(milliseconds: 500),
                //   height: freqheight,
                //   child: AnimatedOpacity(
                //     duration: Duration(milliseconds: 800),
                //     opacity: freqheight == 140 ? 1 : 0,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text('set preferred days to be notified to take devotional'),
                //         Wrap(spacing: 5, children: [
                //           ChoiceChip(
                //             selectedColor:
                //                 sundaySelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Sunday",
                //               style: TextStyle(
                //                   color: sundaySelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: sundaySelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 sundaySelected = selected;
                //               });
                //             },
                //           ),
                //           ChoiceChip(
                //             selectedColor:
                //                 mondaySelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Monday",
                //               style: TextStyle(
                //                   color: mondaySelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: mondaySelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 mondaySelected = selected;
                //               });
                //             },
                //           ),
                //           ChoiceChip(
                //             selectedColor:
                //                 tuesdaySelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Tuesday",
                //               style: TextStyle(
                //                   color: tuesdaySelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: tuesdaySelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 tuesdaySelected = selected;
                //               });
                //             },
                //           ),
                //           ChoiceChip(
                //             selectedColor:
                //                 wednesdaySelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Wednesday",
                //               style: TextStyle(
                //                   color: wednesdaySelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: wednesdaySelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 wednesdaySelected = selected;
                //               });
                //             },
                //           ),
                //           ChoiceChip(
                //             selectedColor:
                //                 thursdaySelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Thursday",
                //               style: TextStyle(
                //                   color: thursdaySelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: thursdaySelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 thursdaySelected = selected;
                //               });
                //             },
                //           ),
                //           ChoiceChip(
                //             selectedColor:
                //                 fridaySelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Friday",
                //               style: TextStyle(
                //                   color: fridaySelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: fridaySelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 fridaySelected = selected;
                //               });
                //             },
                //           ),
                //           ChoiceChip(
                //             selectedColor:
                //                 saturdayelected ? Colors.green : Colors.grey,
                //             label: Text(
                //               "Saturday",
                //               style: TextStyle(
                //                   color: saturdayelected
                //                       ? Colors.white
                //                       : Colors.black),
                //             ),
                //             selected: saturdayelected,
                //             onSelected: (selected) {
                //               setState(() {
                //                 saturdayelected = selected;
                //               });
                //             },
                //           ),
                //         ]),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 20,
                ),

                InkWell(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DevorionScreen()))
                      .then((value) => getColouredVerses()),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(
                              -2,
                              2,
                            ),
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                      gradient: LinearGradient(colors: const [
                        Color.fromARGB(255, 237, 78, 136),
                        Color.fromARGB(246, 1, 32, 206)
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          // height: double.infinity,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset('assets/images/7.webp')),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          width: MediaQuery.of(context).size.width - 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Devotionals',
                                style: TextStyle(
                                    fontSize: Platform.isAndroid
                                        ? 18 + appfontSize
                                        : 20 + (appfontSize * .2),
                                    color: Colors.white),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                'Check all available devotionals',
                                style: TextStyle(
                                    fontSize: Platform.isAndroid ? 16 : 16,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedScriptures()))
                      .then((value) => getColouredVerses()),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(
                              -2,
                              2,
                            ),
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                      gradient: LinearGradient(colors: const [
                        Color.fromARGB(255, 65, 215, 15),
                        Color.fromARGB(246, 1, 32, 206)
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: double.infinity,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/9.webp',
                                height: 70,
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          width: MediaQuery.of(context).size.width - 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Marked Scriptures',
                                style: TextStyle(
                                    fontSize: Platform.isAndroid
                                        ? 18 + appfontSize
                                        : 20 + (appfontSize * .2),
                                    color: Colors.white),
                              ),
                              // Text(
                              //   '',
                              //   style: TextStyle(fontSize: 18, color: Colors.white),
                              // ),
                              data.isNotEmpty
                                  ? Text(
                                      textAlign: TextAlign.center,
                                      'Check all ${data.length} marked scriptures',
                                      style: TextStyle(
                                          fontSize:
                                              Platform.isAndroid ? 16 : 16,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      textAlign: TextAlign.center,
                                      'No marked scriptures available',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildSliders() {
    return Column(
      children: [_volume(), _pitch(), _rate()],
    );
  }

  Widget _appFontSize() {
    return Column(
      children: [
        Text('App fontsize ${appfontSize.toStringAsFixed(1)}'),
        Slider(
          value: appfontSize,
          onChanged: (newVolume) async {
            setState(() => appfontSize = newVolume);

            // await _flutterTts.setVolume(volume);
            // await _flutterTts.setSpeechRate(rate);
            // await _flutterTts.setPitch(pitch);
            // _flutterTts.speak(playVoice);
            // readerHeight = 100;
            // _voiceSettings.volume = newVolume;
            saveFontSize();
          },
          min: -2,
          max: 3,
          divisions: 10,
          label: "Font Size: $appfontSize",
          activeColor: Colors.deepPurple,
        ),
      ],
    );
  }

  Widget _volume() {
    return Column(
      children: [
        Text(
          'Reader volume ${volume.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 14 + appfontSize),
        ),
        Slider(
          value: volume,
          onChanged: (newVolume) async {
            setState(() => volume = newVolume);
            _flutterTts.stop();

            await _flutterTts.setVolume(volume);
            await _flutterTts.setSpeechRate(rate);
            await _flutterTts.setPitch(pitch);
            _flutterTts.speak(playVoice);
            readerHeight = 100;
            _voiceSettings.volume = newVolume;
            saveVoiceSettings();
            setState(() {});
          },
          min: 0.1,
          max: 1.0,
          divisions: 10,
          label: "Volume: $volume",
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget _pitch() {
    return Column(
      children: [
        Text(
          'Reader pitch ${pitch.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 14 + appfontSize),
        ),
        Slider(
          value: pitch,
          onChanged: (newPitch) async {
            setState(() => pitch = newPitch);
            _flutterTts.stop();

            await _flutterTts.setVolume(volume);
            await _flutterTts.setSpeechRate(rate);
            await _flutterTts.setPitch(pitch);
            _flutterTts.speak(playVoice);
            _voiceSettings.pitch = newPitch;
            saveVoiceSettings();
            readerHeight = 100;
            setState(() {});
          },
          min: 0.5,
          max: 2.0,
          divisions: 15,
          label: "Pitch: $pitch",
          activeColor: Colors.red,
        ),
      ],
    );
  }

  Widget _rate() {
    return Column(
      children: [
        Text(
          'Reader word rate ${rate}',
          style: TextStyle(fontSize: 14 + appfontSize),
        ),
        Slider(
          value: rate,
          onChanged: (newRate) async {
            setState(() => rate = newRate);
            _flutterTts.stop();

            await _flutterTts.setVolume(volume);
            await _flutterTts.setSpeechRate(rate);
            await _flutterTts.setPitch(pitch);
            _flutterTts.speak(playVoice);
            readerHeight = 100;
            _voiceSettings.rate = newRate;
            saveVoiceSettings();
            setState(() {});
          },
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: "Rate: $rate",
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
