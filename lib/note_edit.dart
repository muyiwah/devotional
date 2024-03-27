import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/notepad_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uid/uid.dart';

class NoteEdit extends StatefulWidget {
   NoteEdit(this.data, {super.key});
NotepadModel data;
  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
 _titleController = TextEditingController(text: widget.data.title);
 _notesController = TextEditingController(text: widget.data.noteContents);

  }
 late TextEditingController _titleController =TextEditingController();
 late TextEditingController _notesController = TextEditingController();

  DateTime dateEdited = DateTime.now();

  void SaveNote() async {

print(widget.data.id);
    NotepadModel notepadModel = NotepadModel(
        title: _titleController.text,
        noteContents: _notesController.text,
        date: dateEdited.toString(),
        id:widget.data.id);
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

 for (int u = 0; data.length > u; u++) {print(data[u].id);
        if (data[u].id == widget.data.id) {
          data.removeAt(u);
           data.add(notepadModel);
          
          //  print(data);
      prefs.setString('savedNote', jsonEncode(data));
        }
  //  print('saved note not found');
      }



  
    } 
    // String f =prefs.getString('savedNote').toString();
    // print(f);
    Navigator.pop(context);
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
