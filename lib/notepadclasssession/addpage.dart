import 'package:flutter/material.dart';
import 'package:mivdevotional/notepadclasssession/global.dart';

class addNote extends StatefulWidget {
  const addNote({super.key});

  @override
  State<addNote> createState() => _addNoteState();
}

class _addNoteState extends State<addNote> {
  List data = noteData;
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_body.text.isNotEmpty) {
            data.add(
              {
                'title': _title.text,
                'body': _body.text,
                'time': DateTime.now().toString().split('.')[0]
              },
            );
            // print(data);
            Navigator.pop(context);
          }
        },
        child: Container(
          child: Text(
            'save',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width - 180,
                  child: TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '30 aug 2024',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Container(
              color: Colors.green.withOpacity(0.1),
              height: MediaQuery.sizeOf(context).height - 150,
              child: TextField(
                controller: _body,
                maxLines: 30,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: 'Body'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
