// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:mivdevotional/model/notepad_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uid/uid.dart';

// class NoteScreen extends StatefulWidget {
//   const NoteScreen({super.key});

//   @override
//   State<NoteScreen> createState() => _NoteScreenState();
// }

// class _NoteScreenState extends State<NoteScreen> {
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _notesController = TextEditingController();

//   DateTime dateEdited = DateTime.now();

//   void SaveNote() async {
//     var uid = UId.getId();

//     NotepadModel notepadModel = NotepadModel(
//         title: _titleController.text,
//         noteContents: _notesController.text,
//         date: dateEdited.toString(),
//         id: uid);
//     List<NotepadModel> data = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool notEmpty = false;
//     notEmpty = prefs.containsKey('savedNote');
//     if (_notesController.text.isNotEmpty || _titleController.text.isNotEmpty) {
//       if (notEmpty) {
//         String togetNote = prefs.getString('savedNote').toString();
//         for (int x = 0; jsonDecode(togetNote).length > x; x++) {
//           data.add(NotepadModel.fromJsonJson(jsonEncode(
//               (json.decode(prefs.getString('savedNote').toString()))[x])));
//         }
//         data.insert(0, notepadModel);
//         prefs.setString('savedNote', jsonEncode(data));
//       } else {
//         data.add(notepadModel);
//         prefs.setString('savedNote', jsonEncode(data));
//       }
//       String f = prefs.getString('savedNote').toString();
//       print(f);
//       canpop=true;setState(() {

//       });
//       Navigator.pop(context);
//     }
//   }

//   show() {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (context) => Dialog(
//               child: Container(
//                 padding: EdgeInsets.all(12),
//                 height: 150,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                             textAlign: TextAlign.center,
//                             'You have an unsaved note, will you like to save?')
//                         .animate()
//                         .fadeIn(
//                             delay: Duration(milliseconds: 400),
//                             duration: Duration(milliseconds: 700)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             alignment: Alignment.center,
//                             width: 120,
//                             height: 40,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: Colors.blue),
//                             child: Text(
//                               'Dont save',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             SaveNote();
//                           },
//                           child: Container(
//                             alignment: Alignment.center,
//                             width: 120,
//                             height: 40,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: Colors.green),
//                             child: Text(
//                               'Save',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         )
//                       ],
//                     ).animate().fadeIn(
//                         delay: Duration(milliseconds: 900),
//                         duration: Duration(milliseconds: 1100))
//                   ],
//                 ),
//               ),
//             ));
//   }

//   bool canpop = true;
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: canpop,
//       onPopInvoked: (didPop) {
//         print(didPop);
//         if (_notesController.text.isNotEmpty) show();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Make a note'),
//           actions: [
//             InkWell(
//               onTap: () => SaveNote(),
//               child: Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.only(right: 20),
//                   child: Text(
//                     'SAVE',
//                     style: TextStyle(fontSize: 18),
//                   )),
//             )
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   child: TextField(
//                     controller: _titleController,
//                     decoration: InputDecoration(
//                       hintText: 'Title',
//                       // focusedBorder: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 10,
//                 child: Container(
//                   child: TextField(
//                     onChanged: (value) {
//                       if (value.isNotEmpty)
//                     {  canpop = false;
//                     }setState(() {

//                     });
//                     },
//                     controller: _notesController,
//                     maxLines: 100,
//                     decoration: InputDecoration(
//                       hintText: 'Notes....',
//                       // focusedBorder: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mivdevotional/model/notepad_model.dart';
import 'package:mivdevotional/utils/snack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uid/uid.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool canPop = true;
  DateTime dateEdited = DateTime.now();

  Future<void> saveNote() async {
    String uid = UId.getId();
    NotepadModel notepadModel = NotepadModel(
      title: _titleController.text,
      noteContents: _notesController.text,
      date: dateEdited.toString(),
      id: uid,
    );
    print(notepadModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<NotepadModel> notesList = [];

    if (prefs.containsKey('savedNote')) {
      String savedNotesJson = prefs.getString('savedNote') ?? '[]';
      List<dynamic> savedNotes = jsonDecode(savedNotesJson);
      notesList = savedNotes.map((e) => NotepadModel.fromJson(e)).toList();
    }

    if (_titleController.text.isNotEmpty || _notesController.text.isNotEmpty) {
      notesList.insert(0, notepadModel);
      prefs.setString('savedNote', jsonEncode(notesList));
      print(jsonEncode(notesList));
      setState(() {
        canPop = true;
      });
      print('pooooooooop');
      showsnack(context, Colors.green, 'Note saved');
      Navigator.pop(context);
    }
  }

  void showSaveDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'You have an unsaved note, would you like to save it?',
                textAlign: TextAlign.center,
              ).animate().fadeIn(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 700),
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                       canPop = true;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: const Text(
                        'Don\'t Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      saveNote();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ).animate().fadeIn(
                    delay: const Duration(milliseconds: 900),
                    duration: const Duration(milliseconds: 1100),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!canPop && _notesController.text.isNotEmpty) {
          showSaveDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Make a Note'),
          actions: [
            InkWell(
              onTap: saveNote,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 20),
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _notesController,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      canPop = value.isEmpty;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Notes...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
