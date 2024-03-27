import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/notepad_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uid/uid.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  DateTime dateEdited = DateTime.now();

  void SaveNote() async {
var uid = UId.getId();

    NotepadModel notepadModel = NotepadModel(
        title: _titleController.text,
        noteContents: _notesController.text,
        date: dateEdited.toString(),
        id:uid );
    List<NotepadModel> data = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notEmpty = false;
    notEmpty = prefs.containsKey('savedNote');

    if (notEmpty) {
      String togetNote = prefs.getString('savedNote').toString();
      for (int x = 0; jsonDecode(togetNote).length > x; x++) {
        data.add(NotepadModel.fromJsonJson(jsonEncode(
            (json.decode(prefs.getString('savedNote').toString()))[x])));
      }
      data.add(notepadModel);
      prefs.setString('savedNote', jsonEncode(data));
    } else {
      data.add(notepadModel);
      prefs.setString('savedNote', jsonEncode(data));
    }
    String f =prefs.getString('savedNote').toString();
    print(f);Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a note'),
        actions: [
          InkWell(onTap: () => SaveNote(),
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  'SAVE',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    // focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                child: TextField(
                  controller: _notesController,
                  maxLines: 100,
                  decoration: InputDecoration(
                    hintText: 'Notes....',
                    // focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
