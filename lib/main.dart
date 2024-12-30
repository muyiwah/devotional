// import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:mivdevotional/core/provider/bible.provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mivdevotional/ui/home/welcome.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
bool showOnce=true;

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
    await Alarm.init();
  // await Firebase.initializeApp();
  
   ErrorWidget.builder = (FlutterErrorDetails details) {
    bool isDebug = false;
    assert(() {
      isDebug = false;
      return true;
    }());
    if (isDebug == true) {
      return ErrorWidget(details.exception);
    }
    return Scaffold(
        body: Dialog(
      child: Container(padding: EdgeInsets.all(20),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('sorry, a little problem, probably wrong scripture parsing. pls dismiss',textAlign: TextAlign.center,)),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('dismiss'));
            })
          ],
        ),
      ),
    ));
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarColor: Theme.of(context)
          .scaffoldBackgroundColor, //Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      // For iOS.
      // Use [dark] for white status bar and [light] for black status bar.
      statusBarBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BibleModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Miv Devotional',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: Testexample(),
        home: Welcome(),
         builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: Platform.isAndroid ? .9 : 1,
          ),
          child: child!),
      ),
    );
  }
}
