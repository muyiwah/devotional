import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/save_color.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedScriptures extends StatefulWidget {
  SavedScriptures({super.key});

  @override
  State<SavedScriptures> createState() => _SavedScripturesState();
}

class _SavedScripturesState extends State<SavedScriptures> {
  @override
  initState() {
    super.initState();

    getColouredVerses();
  }

  List<SaveColor> data = [];
  List<SaveColor> data2 = [];
  List<int> data3 = [];
  getColouredVerses() async {
    data.clear();
    data2.clear();
    data3.clear();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('All marked references')),
      // body: Text(data.toString()),
      body: data.isNotEmpty
          ? Column(
              children: [
               if(data2.isNotEmpty) Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String my = data[index].color;
                        Color color = Colors.transparent;
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

                        return InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          ShowChapter(
                            bookName: data[index].book,
                            chapter: data[index].chapter,
                            verse: data[index].verse,
                          ),)).then((value) => getColouredVerses()),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data[index].book,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      data[index].chapter.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                     '${ data[index].verse+1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Text(
                                  data[index].content,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )
          : Center(
              child: Text('No saved scripture yet'),
            ),
    );
  }
}
