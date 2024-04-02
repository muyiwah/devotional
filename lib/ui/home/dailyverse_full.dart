import 'dart:math';

import 'package:mivdevotional/core/model/dail_verse.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DailverseFullScreen extends StatelessWidget {
  DailverseFullScreen(this.vers, {super.key});
  DailyVerseModel vers;
  int ran = Random().nextInt(15);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/dailyimages/$ran.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.3),
          ),
          Positioned(
            top: 80,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Text(
                  vers.verse,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
                ),
                Text(
                  'STUDY BIBLE',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 230,
            left: 30,
            right: 30,
            child: Text(
              vers.ref,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 130,
            right: 130,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.withOpacity(.1)),
              child: InkWell(
                onTap: () async {
                  final result = await Share.share(
                      '${vers.verse}${vers.ref}\n\n@The Men of Issachar Vision Inc\n  download app for more https://www.menofissacharvision.com');

// if (result.status == ShareResultStatus.success) {
//     print('Thank you for sharing my website!');
// }
                },
                child: Text(
                  'share',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
