import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/notepad_model.dart';
import 'package:mivdevotional/note_edit.dart';
import 'package:mivdevotional/notes_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uid/uid.dart';

class Notespad extends StatefulWidget {
  const Notespad({super.key});

  @override
  State<Notespad> createState() => _NotespadState();
}

class _NotespadState extends State<Notespad> {
  @override
  void initState() {
    super.initState();

    fetchNote();
  }

  List<NotepadModel> data = [];
  removeNotes(id) async{

 
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
        if (data[u].id ==id) {
          data.removeAt(u);
          
          //  print(data);
      prefs.setString('savedNote', jsonEncode(data));
        }
  //  print('saved note not found');
      }


    }
  
  }

  void fetchNote() async {
    print('fetching');
    data.clear();
    NotepadModel notepadModel =
        NotepadModel(title: '', noteContents: '', date: '', id: '');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notEmpty = false;
    notEmpty = prefs.containsKey('savedNote');

    if (notEmpty) {
      String togetNote = prefs.getString('savedNote').toString();
      for (int x = 0; jsonDecode(togetNote).length > x; x++) {
        data.add(NotepadModel.fromJsonJson(jsonEncode(
            (json.decode(prefs.getString('savedNote').toString()))[x])));
      }
    }
    setState(() {});
    print(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
      ),
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var id = UId.getId();

                return InkWell(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (cotext) => NoteEdit(data[index])))
                      .then((value) => fetchNote()),
                  child: Dismissible(
                    key: Key(id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      removeNotes(data[index].id);
                    },
                    secondaryBackground: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text('Delete from Notes',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        )),
                    background: Container(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: const [
                            Icon(Icons.favorite, color: Colors.red),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text('Move to favorites',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 100.0,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green,
                          )),
                      child: Column(children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data[index].title,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  'Last Edited ${data[index].date.toString().split('.')[0]}'),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              })
          : Center(
              child: Text('No saved note yet'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteScreen(),
            )).then((value) => fetchNote()),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
