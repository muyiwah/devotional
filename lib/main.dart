import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/devotion_screen.dart';
import 'package:mivdevotional/ui/home/dashboard.dart';
import 'package:mivdevotional/ui/home/home_screen.dart';
import 'package:mivdevotional/ui/home/sliver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mivdevotional/ui/home/welcome.dart';
import 'package:provider/provider.dart';

void main() {
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
        title: 'Bible App ',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: HomeScreen(),
        // home: MySilverScreen(),
        home: Welcome(),
      ),
    );
  }
}
