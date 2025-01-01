import 'dart:async';
import 'dart:io';

// import 'package:alarm/alarm.dart';
// import 'package:alarm/model/alarm_settings.dart';
// import 'package:alarm/model/notification_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


// class ReminderScreen extends StatelessWidget {
//   Future<void> scheduleRecurringReminder(BuildContext context) async {
//     // Allow user to pick a time for the alarm
//     TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (selectedTime != null) {
//       final now = DateTime.now();
//       final initialAlarmTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         selectedTime.hour,
//         selectedTime.minute,
//       );

//       // Schedule the recurring alarm
//       await setRecurringAlarm(initialAlarmTime);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text('Daily reminder set for ${selectedTime.format(context)}.'),
//         ),
//       );
//     }
//   }

//   Future<void> setRecurringAlarm(DateTime alarmTime) async {
//     final alarmSettings = AlarmSettings(
//       id: alarmTime.hashCode, // Unique ID for this alarm
//       dateTime: alarmTime,
//       assetAudioPath: 'assets/audio/synthesis.wav', // Path to the audio file
//       loopAudio: true,
//       vibrate: true,
//       volume: 0.8,
//       fadeDuration: 3.0,
//       warningNotificationOnKill: Platform.isIOS,
//       androidFullScreenIntent: true,
//       notificationSettings: const NotificationSettings(
//         title: 'Bible Study Reminder',
//         body: 'It’s time for your daily Bible study!',
//         stopButton: 'Stop the alarm',
//         icon: 'notification_icon',
//       ),
//     );

//     // Schedule the alarm
//     await Alarm.set(alarmSettings: alarmSettings);

//     // Schedule the next day’s alarm
//     final nextDay = alarmTime.add(Duration(days: 1));
//     await Alarm.set(
//       alarmSettings: alarmSettings.copyWith(dateTime: nextDay),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bible Study Reminder'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => scheduleRecurringReminder(context),
//           child: Text('Set Daily Reminder'),
//         ),
//       ),
//     );
//   }
// }
class ReminderScreen extends StatefulWidget {
  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {


  @override
  void didChangeDependencies() {
    // TODO: implement initState
    print('hasdfasdfasdfasdfsdfrer yuer');
    Timer.periodic(Duration(milliseconds: 500), ((e) {
      print('herer yuer');
      checkUser();
      e.cancel();
    }));
    super.didChangeDependencies();
  }


  Future<void> scheduleDailyReminder(BuildContext context) async {
    // Allow user to pick a time for the alarm
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Schedule the alarm
      // final alarmSettings = AlarmSettings(
      //   id: 42, // Unique alarm ID
      //   dateTime: alarmTime,
      //   assetAudioPath:
      //       'assets/audio/synthesis.wav', // Replace with your custom sound file
      //   loopAudio: true,
      //   vibrate: true,
      //   volume: 0.8,
      //   fadeDuration: 3.0,
      //   warningNotificationOnKill: Platform.isIOS, // Specific for iOS
      //   androidFullScreenIntent: true,
      //   notificationSettings: const NotificationSettings(
      //     title: 'Bible Study Reminder',
      //     body: 'It’s time for your daily Bible study!',
      //     stopButton: 'Stop the alarm',
      //     icon: 'notification_icon', // Replace with your notification icon
      //   ),
      // );

      // Set the alarm
      // Alarm.set(alarmSettings: alarmSettings);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${selectedTime.format(context)}'),
        ),
      );
    }
  }



checkUser() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                padding: EdgeInsets.all(12),
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                            textAlign: TextAlign.center,
                            'Daily bible study reminder will be available shortly, you can check the playstore/appstore to know when update is available')
                        .animate()
                        .fadeIn(
                            delay: Duration(milliseconds: 400),
                            duration: Duration(milliseconds: 700)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
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
    return Scaffold(backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text('Daily Bible Study Reminder'),
      ),
      body: Center(
        // child: ElevatedButton(
        //   onPressed: () => scheduleDailyReminder(context),
        //   child: Text('Set Daily Reminder'),
        // ),
      ),
    );
  }
}
