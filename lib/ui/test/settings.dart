import 'package:flutter/material.dart';

class ola extends StatelessWidget {
  const ola({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 32, 32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QuickBite',
              style: TextStyle(fontSize: 55, color: Colors.white),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                counter: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color.fromRGBO(255, 0, 0, 0.965),
                        Color.fromRGBO(241, 153, 21, 0.965)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
