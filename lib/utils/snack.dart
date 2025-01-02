import 'package:flutter/material.dart';

 void showsnack(BuildContext context,color, String text) {
   ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * .1,
            left: 10,
            right: 10),
        content: Center(
            child: Text(
              text))));
            
}