import 'package:mivdevotional/core/utility/config.dart';
import 'package:flutter/material.dart';

class TestamentLabel extends StatelessWidget {
  final String testamentName;

  const TestamentLabel({required this.testamentName});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        '$testamentName Testament',
        style: TextStyle(fontSize: Config.screenWidth * 5),
      )),
    ));
  }
}
