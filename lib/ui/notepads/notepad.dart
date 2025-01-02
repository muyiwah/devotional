// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:mivdevotional/model/notepad_model.dart';
// import 'package:mivdevotional/ui/notepads/note_edit.dart';
// import 'package:mivdevotional/ui/notepads/notes_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uid/uid.dart';

// class Notespad extends StatefulWidget {
//   const Notespad({super.key});

//   @override
//   State<Notespad> createState() => _NotespadState();
// }

// class _NotespadState extends State<Notespad> {
//   @override
//   void initState() {
//     super.initState();

//     fetchNote();
//   }

//   Color borderColor = Colors.teal;
//   List<NotepadModel> data = [];
//   removeNotes(id) async {
//     List<NotepadModel> data = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool notEmpty = false;
//     notEmpty = prefs.containsKey('savedNote');

//     if (notEmpty) {
//       String togetNote = prefs.getString('savedNote').toString();
//       for (int x = 0; jsonDecode(togetNote).length > x; x++) {
//         data.add(NotepadModel.fromJsonJson(jsonEncode(
//             (json.decode(prefs.getString('savedNote').toString()))[x])));
//       }

//       for (int u = 0; data.length > u; u++) {
//         print(data[u].id);
//         if (data[u].id == id) {
//           data.removeAt(u);

//           //  print(data);
//           prefs.setString('savedNote', jsonEncode(data));
//         }
//         //  print('saved note not found');
//       }
//     }
//   }

//   void fetchNote() async {
//     print('fetching');
//     data.clear();
//     NotepadModel notepadModel =
//         NotepadModel(title: '', noteContents: '', date: '', id: '');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool notEmpty = false;
//     notEmpty = prefs.containsKey('savedNote');

//     if (notEmpty) {
//       String togetNote = prefs.getString('savedNote').toString();
//       for (int x = 0; jsonDecode(togetNote).length > x; x++) {
//         data.add(NotepadModel.fromJsonJson(jsonEncode(
//             (json.decode(prefs.getString('savedNote').toString()))[x])));
//       }
//     }
//     setState(() {});
//     print(data);
//     setState(() {});
//   }

//   void SaveNote() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     prefs.setString('savedNote', jsonEncode(data));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Notepad',
//         ),
//       ),
//       body: data.isNotEmpty
//           ? Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 10),
//                       child: Text(
//                         '',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     )
//                         .animate()
//                         .fadeIn(
//                             delay: Duration(milliseconds: 800),
//                             duration: Duration(milliseconds: 800))
//                         .slideX(begin: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 10),
//                       child: Text(
//                         'Slide note left to delete',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     )
//                         .animate()
//                         .fadeIn(
//                             delay: Duration(milliseconds: 500),
//                             duration: Duration(milliseconds: 500))
//                         .slideX(begin: 10),
//                   ],
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     reverse: false,
//                     itemCount: data.length,
//                     itemBuilder: (context, index) {
//                       var id = UId.getId();
//                       var id2 = UId.getId();

//                       return InkWell(
//                         key: Key(id2.toString()),
//                         onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (cotext) => NoteEdit(data[index])))
//                             .then((value) => fetchNote()),
//                         child: Dismissible(
//                           key: Key(id.toString()),
//                           direction: DismissDirection.endToStart,
//                           onDismissed: (direction) {
//                             removeNotes(data[index].id);
//                           },
//                           secondaryBackground: Container(
//                               color: Colors.red,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: const [
//                                     Icon(Icons.delete, color: Colors.white),
//                                     SizedBox(
//                                       width: 8.0,
//                                     ),
//                                     Text('Delete from Notes',
//                                         style: TextStyle(color: Colors.white)),
//                                   ],
//                                 ),
//                               )),
//                           background: Container(
//                             color: Colors.blue,
//                             child: Padding(
//                               padding: const EdgeInsets.all(15),
//                               child: Row(
//                                 children: const [
//                                   Icon(Icons.favorite, color: Colors.red),
//                                   SizedBox(
//                                     width: 8.0,
//                                   ),
//                                   Text('Move to favorites',
//                                       style: TextStyle(color: Colors.white)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             height: 80.0,
//                             margin: EdgeInsets.symmetric(
//                               horizontal: 10.0,
//                               vertical: 3.0,
//                             ),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: borderColor,
//                                 )),
//                             child: Column(children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     maxLines: 2,
//                                     data[index].title,
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       'Last Edited ${data[index].date.toString().split('.')[0]}',
//                                       style: TextStyle(fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ]),
//                           ),
//                         ),
//                       );
//                     },
//                     // onReorderStart: (index) {
//                     //   print(index);
//                     //   borderColor = Colors.orange;
//                     //   setState(() {});
//                     // },
//                     // onReorderEnd: (index) {
//                     //   borderColor = Colors.teal;
//                     //   setState(() {});
//                     // },
//                     // onReorder: (oldIndex, newIndex) {
//                     //   setState(() {
//                     //     if (oldIndex < newIndex) {
//                     //       newIndex -= 1;
//                     //     }
//                     //     final item = data.removeAt(oldIndex);
//                     //     data.insert(newIndex, item);
//                     //     SaveNote();
//                     //   });
//                     // },
//                   ),
//                 ),
//               ],
//             )
//           : Center(
//               child: Text('No saved note yet'),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NoteScreen(),
//             )).then((value) => fetchNote()),
//         child: Icon(
//           Icons.add,
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mivdevotional/model/notepad_model.dart';
import 'package:mivdevotional/ui/notepads/note_edit.dart';
import 'package:mivdevotional/ui/notepads/notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notespad extends StatefulWidget {
  const Notespad({super.key});

  @override
  State<Notespad> createState() => _NotespadState();
}

class _NotespadState extends State<Notespad> {
  Color borderColor = Colors.teal;
  List<NotepadModel> data = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNotesJson = prefs.getString('savedNote');
    if (savedNotesJson != null) {
      List<dynamic> savedNotes = jsonDecode(savedNotesJson);
      setState(() {
        data = savedNotes.map((e) => NotepadModel.fromJson(e)).toList();
      });
    } else {
      setState(() {
        data = [];
      });
    }
  }

  Future<void> removeNoteById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.removeWhere((note) => note.id == id);
    prefs.setString('savedNote', jsonEncode(data));
    setState(() {});
  }

  Future<void> saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedNote', jsonEncode(data));
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = data.removeAt(oldIndex);
      data.insert(newIndex, item);
    });
    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notepad'),
      ),
      body: data.isNotEmpty
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      child: Text(
                        'long press note to reorder',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 800))
                        .slideX(begin: 10),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      child: Text(
                        'Slide note left to delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: const Duration(milliseconds: 500),
                            duration: const Duration(milliseconds: 500))
                        .slideX(begin: 10),
                  ],
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    onReorder: onReorder,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(data[index].id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => removeNoteById(data[index].id),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                SizedBox(width: 8.0),
                                Text(
                                  'Delete from Notes',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        background: Container(
                          color: Colors.blue,
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red),
                                SizedBox(width: 8.0),
                                Text(
                                  'Move to favorites',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(color: Colors.amber.withOpacity(.1),
                          borderRadius: BorderRadius.circular(12), border: Border.all()),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteEdit(data[index]),
                              ),
                            ).then((_) => fetchNotes()),
                            title: Text(
                              data[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            subtitle: Text(
                              data[index].noteContents,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            trailing: Column(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Last Edited: ${data[index].date.split('.')[0]}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('No saved note yet'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoteScreen(),
          ),
        ).then((_) => fetchNotes()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
