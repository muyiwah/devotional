import 'package:flutter/material.dart';

class Read extends StatelessWidget {
   Read(
      {super.key, required this.title, required this.time, required this.body});
  String title;
  String time;
  String body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width - 180,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Text(
                 time,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Text(body),
          )
        ]),
      ),
    );
  }
}
