import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mivdevotional/core/model/reader_model.dart';
import 'package:mivdevotional/core/model/save_color.dart';
import 'package:mivdevotional/devotion_screen.dart';
import 'package:mivdevotional/ui/home/saved_scriptures.dart';
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
  }

  String selectedReader = "Karen";

  int? _currentWordStart, _currentWordEnd;
  String _currentlyPlayingSentence = '';
  String playVoice =
      "This is my voice texture. You can select from the list of other voices for your preferred audio bible reader";
  List<Map> _voices = [];
  FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;
  List<ReaderModel> readerDesc = [];
  ReaderModel _readerModel =
      ReaderModel(name: '', gender: '', identifier: '', locale: '');
double readerHeight=0;
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

    _flutterTts.getVoices.then((data) {
      try {
        _voicesString.clear();
        _voices = List<Map>.from(data);
        setState(() {
          _voices = _voices
              .where((_voice) => _voice['locale'].contains('en'))
              .toList();
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
          // print(readerDesc);
          //  if (prefs.containsKey('savedReader')) {}
          //  else{
          _currentVoice = _voices[0];
          setVoice(_currentVoice!);
          // }
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoiceN() {
    _flutterTts
        .setVoice({'name': _readerModel.name, 'locale': _readerModel.locale});
    selectedReader = _readerModel.name;
  }

  savePrefVoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('savedReader', jsonEncode(myReader));

    String d = prefs.getString('savedReader').toString();
    print(d);
  }

  setVoice(Map voice) {
    _flutterTts.setVoice({'name': voice['name'], 'locale': voice['locale']});
  }

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

        for(int d=0;data2.length>d;d++){
          if(data2[d].color!='white'){
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
  int selection = 1;
  String chipSelected = "";
  String readerchipSelected = "Male";
  List<String> chipData = [
    'Once',
    'Hourly',
    'Daily',
    'Weekly',
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
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
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
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .92,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      // Text(
                      //   'Create an event',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w800, fontSize: 18),
                      // ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Preffered Reader',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                          // Text(
                          //   'select from enrolled courses',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w500, fontSize: 14),
                          // ),
                        ],
                      ),
                      // Wrap(
                      //     spacing: 5,
                      //     children: readerDesc
                      //         .map(
                      //           (e) => InkWell(
                      //             onTap: () async {
                      //               if (e == 'Once') {

                      //               }
                      //               readerchipSelected = e.name;
                      //            if(mounted)    setState(() {});
                      //             },
                      //             child: Chip(
                      //                 labelPadding:
                      //                     EdgeInsets.symmetric(horizontal: 16),
                      //                 backgroundColor: readerchipSelected == e
                      //                     ? Colors.green
                      //                     : Colors.white,
                      //                 label: Text(
                      //                   e.toString(),
                      //                   style: TextStyle(
                      //                       color: readerchipSelected == e
                      //                           ? Colors.white
                      //                           : Colors.black,
                      //                       fontSize: 12),
                      //                 )),
                      //           ),
                      //         )
                      //         .toList()),

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
                                  readerHeight=100;setState(() {
                                    
                                  });  },
                                  ),
                                )
                                .toList(),

                            //  [

                            //   DropdownMenuItem(
                            //     child: Text('5 minutes before event'),
                            //     value: 5,
                            //   ),
                            //   DropdownMenuItem(
                            //     child: Text('30 minutes before event'),
                            //     value: 30,
                            //   ),
                            // ],
                            onChanged: (value) {
                              selectedReader = value!;
                              if (mounted) setState(() {});
                            }),
                      ),
                    
                      AnimatedContainer(duration: Duration(seconds: 1),
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
                                      ? playVoice.substring(
                                          0, _currentWordStart)
                                      : playVoice,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              if (_currentWordStart != null &&
                                  _currentlyPlayingSentence == playVoice)
                                TextSpan(
                                  text: playVoice.substring(
                                      _currentWordStart!, _currentWordEnd),
                                  style: TextStyle(
                                      backgroundColor: Colors.white,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              if (_currentWordEnd != null &&
                                  _currentlyPlayingSentence == playVoice)
                                TextSpan(
                                    text: playVoice.substring(
                                      _currentWordEnd!,
                                    ),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),

                      Text(
                        'Set frequency',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      Wrap(
                          spacing: 5,
                          children: chipData
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    if (e == 'Once') {
                                      final TimeOfDay? time =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: selectedTime,
                                              initialEntryMode:
                                                  TimePickerEntryMode.dial);
                                      // if(time!=null){selectedTime=time;setState(() {
                                      //   print(selectedTime);
                                      // });}

                                      print(time);
                                      print(TimeOfDay.now());
                                      // print(TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(minutes: 10))));
                                      print(DateTime.now().difference(
                                          DateTime.now().add(
                                              Duration(days: 0, minutes: 0))));
                                    }
                                    chipSelected = e;
                                    if (mounted) setState(() {});
                                  },
                                  child: Chip(
                                      labelPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      backgroundColor: chipSelected == e
                                          ? Colors.green
                                          : Colors.white,
                                      label: Text(
                                        e.toString(),
                                        style: TextStyle(
                                            color: chipSelected == e
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12),
                                      )),
                                ),
                              )
                              .toList()),
                      // TextFormField(
                      //   readOnly: true,
                      //   controller: _dateOfBirthController,
                      //   decoration: InputDecoration(
                      //     fillColor: Colors.white,
                      //     filled: true,
                      //     suffixIcon: InkWell(
                      //         onTap: () {
                      //           pickDate();
                      //         },
                      //         child: Icon(Icons.calendar_view_day_rounded)),
                      //     isDense: true,
                      //     hintText: dob.isNotEmpty ? dob.toString() : 'date',
                      //     border: OutlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.black)),
                      //   ),
                      //   validator: (value) {
                      //     if (value == null) {
                      //       return 'Please enter some text';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      Text(
                        'Reminder notification',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.white,
                        child: DropdownButton(
                            isExpanded: true,
                            value: selection,
                            items: [
                              DropdownMenuItem(
                                child: Text('1 minute before event'),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text('5 minutes before event'),
                                value: 5,
                              ),
                              DropdownMenuItem(
                                child: Text('30 minutes before event'),
                                value: 30,
                              ),
                            ],
                            onChanged: (value) {
                              selection = value!;
                              if (mounted) setState(() {});
                            }),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                         InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DevorionScreen())).then((value) => getColouredVerses()),
                 child: Container(
                             margin: EdgeInsets.symmetric(vertical: 4),
                             height: 100,
                             width: double.infinity,
                             decoration: BoxDecoration(border: Border.all(),
                             boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(
                            -2,
                            2,
                          ),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],    gradient: LinearGradient(colors: const [
                      Color.fromARGB(255, 237, 78, 136),
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
                            style: TextStyle(fontSize:Platform.isAndroid?  18:20, color: Colors.white),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Check all available devotionals',
                            style: TextStyle(fontSize:Platform.isAndroid?  16:18, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                             ),
                           ),
               ),
            InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedScriptures())).then((value) => getColouredVerses()),

              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(),
                 boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(
                            -2,
                            2,
                          ),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],   gradient: LinearGradient(colors: const [
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
                      decoration: BoxDecoration(border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset('assets/images/9.webp')),
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
                            style: TextStyle(fontSize:Platform.isAndroid?  18:20, color: Colors.white),
                          ),
                          // Text(
                          //   '',
                          //   style: TextStyle(fontSize: 18, color: Colors.white),
                          // ),
                       data.isNotEmpty?   Text(textAlign:TextAlign.center,
                            'Check all ${data.length} marked scriptures',
                            style: TextStyle(fontSize:Platform.isAndroid?  16:18, color: Colors.white),
                          ): Text(textAlign:TextAlign.center,
                            'No marked scriptures available',
                            style: TextStyle(fontSize: Platform.isAndroid? 16:18, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),  
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //     // MyNotificatinApi.cancelAll();
                      //   },
                      //   child: Text(
                      //     'Check All Devvotional',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //       fixedSize: Size(
                      //           MediaQuery.of(context).size.width - 20, 50),
                      //       backgroundColor: Colors.green,
                      //       shape: ContinuousRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12))),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     MyNotificatinApi.showScheduledNotification(
                      //       title: 'test',
                      //       body: 'we testing',
                      //       payload: 'payload',
                      //     );
                      //   },
                      //   child: Text(
                      //     'Creat periodic',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //       fixedSize: Size(
                      //           MediaQuery.of(context).size.width - 20, 50),
                      //       backgroundColor: Provider.of<UserProvider>(context,
                      //                   listen: false)
                      //               .isChildren
                      //           ? Colors.green
                      //           : myColor,
                      //       shape: ContinuousRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12))),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     MyNotificatinApi.runOnce(
                      //         title: 'Reminder for ${_controller.text}',
                      //         body: selectedCourses.toString(),
                      //         payload: 'payload',
                      //         duration: 1);
                      //   },
                      //   child: Text(
                      //     'Run once',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //       fixedSize: Size(
                      //           MediaQuery.of(context).size.width - 20, 50),
                      //       backgroundColor: Provider.of<UserProvider>(context,
                      //                   listen: false)
                      //               .isChildren
                      //           ? Colors.green
                      //           : myColor,
                      //       shape: ContinuousRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12))),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     MyNotificatinApi.showNotification(
                      //         title: 'Reminder for ${_controller.text}',
                      //         body: selectedCourses.toString(),
                      //         payload: 'payload');
                      //   },
                      //   child: Text(
                      //     'Create now',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //       fixedSize: Size(
                      //           MediaQuery.of(context).size.width - 20, 50),
                      //       backgroundColor: Provider.of<UserProvider>(context,
                      //                   listen: false)
                      //               .isChildren
                      //           ? Colors.green
                      //           : myColor,
                      //       shape: ContinuousRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12))),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
