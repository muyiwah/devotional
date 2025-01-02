import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bibleplanselect extends StatefulWidget {
  const Bibleplanselect({super.key});

  @override
  State<Bibleplanselect> createState() => _BibleplanselectState();
}

class _BibleplanselectState extends State<Bibleplanselect> {
  show(data) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                padding: EdgeInsets.all(12),
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(textAlign: TextAlign.center, data).animate().fadeIn(
                        delay: Duration(milliseconds: 400),
                        duration: Duration(milliseconds: 700)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue),
                            child: Text(
                              'Dismiss',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('showChoice', false);
                            if (data ==
                                'You are about to select A Thematic plan, it is not advisable to change the plan once chosen') {
                              prefs.setString('plan', 'Thematic');
                             Navigator.pop(context, 'Thematic');  }
                            else{
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('showChoice', false);
                              if (data ==
                                  'You are about to select A Chronological plan, it is not advisable to change the plan once chosen') {
                                prefs.setString('plan', 'Chronological');
                               Navigator.pop(
                                  context,
                                  'Chronological'
                                );
                              } 
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green),
                            child: Text(
                              'Select plan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ).animate().fadeIn(
                        delay: Duration(milliseconds: 900),
                        duration: Duration(milliseconds: 1100))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select your preferred daily bible plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/chronological.webp')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'A Chronological plan focuses on reading the Bible in the order events occurred, such as Genesis, Exodus, and Numbers. This daily reading plan combines passages from the Old Testament, New Testament, Proverbs, and Psalms, offering a balanced mix of Scripture each day',
                      style: TextStyle(height: 1.6, fontSize: 16),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(250, 50)),
                        onPressed: () {
                          show(
                              'You are about to select A Chronological plan, it is not advisable to change the plan once chosen');
                        },
                        child: Text(
                          'Select Plan',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/thematic.jpg')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'A Thematic Bible Reading Plan organizes daily readings around specific themes or topics found throughout Scripture. Instead of following a chronological or sequential order, it groups passages that share similar ideas, teachings, or events, providing a deeper understanding of biblical concepts. For example, a day might include readings on faith, love, or prayer, drawn from both the Old and New Testaments',
                      style: TextStyle(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(250, 50)),
                        onPressed: () {
                          show(
                              'You are about to select A Thematic plan, it is not advisable to change the plan once chosen');
                        },
                        child: Text(
                          'Select Plan',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
