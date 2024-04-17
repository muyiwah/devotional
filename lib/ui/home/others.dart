import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/save_color.dart';
import 'package:mivdevotional/devotion_screen.dart';
import 'package:mivdevotional/ui/home/saved_scriptures.dart';
import 'package:mivdevotional/ui/home/word_clinic_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Others extends StatefulWidget {
  const Others({super.key});

  @override
  State<Others> createState() => _OthersState();
}

class _OthersState extends State<Others> {
@override
initState(){
 super.initState();
  getColouredVerses();
}
   List<SaveColor> data = [];
  List<SaveColor> data2 = [];
  getColouredVerses() async {print('GETIIIIIING VERESESESESE');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Text('Others'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bible3.png',
                ),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           Expanded(flex: 2,
            child: SizedBox.shrink()),
            Expanded(flex: 3,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
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
                          Color.fromARGB(246, 1, 32, 206),
                          Color.fromARGB(255, 155, 118, 167),
                        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.amber),
                    child: Row(
                      children: [
                        Container(
                          height: double.infinity,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset('assets/images/2.jpeg')),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>WordClinicPage())).then((value) => getColouredVerses()),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            width: MediaQuery.of(context).size.width - 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Word clinic',
                                  style: TextStyle(fontSize:Platform.isAndroid? 18:20, color: Colors.white),
                                ),
                                Text(textAlign:TextAlign.center,
                                  'Check all avaailable word clinic',
                                  style: TextStyle(fontSize:Platform.isAndroid?  16:18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
               InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DevorionScreen())).then((value) => getColouredVerses()),
                 child: Container(
                             margin: EdgeInsets.symmetric(vertical: 4),
                             height: 100,
                             width: double.infinity,
                             decoration: BoxDecoration(
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
                    color: Colors.amber),
                             child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red),
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
                decoration: BoxDecoration(
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
                    color: Colors.amber),
                child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
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
            ),  ],
              ),
            ),
           
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 4),
            //   height: 100,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //       boxShadow: [
            //         BoxShadow(
            //             color: Colors.black,
            //             offset: Offset(
            //               -2,
            //               2,
            //             ),
            //             blurRadius: 1,
            //             spreadRadius: 1)
            //       ],
            //       gradient: const LinearGradient(colors: [
            //         Color.fromARGB(255, 184, 237, 78),
            //         Color.fromARGB(246, 1, 32, 206)
            //       ], begin: Alignment.topRight, end: Alignment.bottomLeft),
            //       borderRadius: BorderRadius.circular(12),
            //       color: Colors.amber),
            //   child: Row(
            //     children: [
            //       Container(
            //         height: double.infinity,
            //         margin: EdgeInsets.all(3),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(12),
            //             color: Colors.red),
            //         child: ClipRRect(
            //             borderRadius: BorderRadius.circular(12),
            //             child: Image.asset('assets/images/9.webp')),
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(vertical: 4),
            //         width: MediaQuery.of(context).size.width - 200,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             Text(
            //               'App use statistics',
            //               style: TextStyle(fontSize: 20, color: Colors.white),
            //             ),
            //             Text(
            //               'Check',
            //               style: TextStyle(fontSize: 18, color: Colors.white),
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
