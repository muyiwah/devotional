import 'package:flutter/material.dart';
import 'package:mivdevotional/notepadclasssession/addpage.dart';
import 'package:mivdevotional/notepadclasssession/global.dart';
import 'package:mivdevotional/notepadclasssession/read.dart';

class NotepadClass extends StatefulWidget {
  NotepadClass({super.key});

  @override
  State<NotepadClass> createState() => _NotepadClassState();
}

class _NotepadClassState extends State<NotepadClass> {
  List data = noteData;
  rebuildSreen() {
    data = noteData;
    print(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notepad'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => addNote()))
              .then((value) => rebuildSreen());
        },
        child: Container(
          child: Icon(Icons.add),
        ),
      ),
      body: Container(
          width: double.infinity,
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(data[index]['body']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Read(
                                title: data[index]['title'],
                                time: data[index]['time'],
                                body: data[index]['body'])));
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    height: 80,
                    color: Colors.blue.withOpacity(.2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(data[index]['title']),
                            Spacer(),
                            Text(data[index]['time']),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              data.length>=25?
                              data[index]['body']
                                .toString()
                                .substring(0, 25): data[index]['body'].toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
