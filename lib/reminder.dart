// // import 'package:alarm/alarm.dart';
// // import 'package:alarm/model/alarm_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ReminderScreen extends StatefulWidget {
//   @override
//   _ReminderScreenState createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   TimeOfDay? selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     loadSavedTime();
//   }

//   Future<void> scheduleAlarm(TimeOfDay time) async {
//     final now = DateTime.now();
//     final alarmTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//     ).isBefore(now)
//         ? DateTime(
//             now.year,
//             now.month,
//             now.day + 1,
//             time.hour,
//             time.minute,
//           )
//         : DateTime(
//             now.year,
//             now.month,
//             now.day,
//             time.hour,
//             time.minute,
//           );

//     final alarmSettings = AlarmSettings(
//       id: 1,
//       dateTime: alarmTime,
//       assetAudioPath: 'assets/alarm.mp3',
//       loopAudio: true,
//       vibrate: true,
//       fadeDuration: 3.0,  notificationSettings: const NotificationSettings(
//     title: 'This is the title',
//     body: 'This is the body',
//     stopButton: 'Stop the alarm',
//     icon: 'notification_icon',
//   ),
//     );

//     await Alarm.set(alarmSettings: alarmSettings);
//   }

//   Future<void> saveTime(TimeOfDay time) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('hour', time.hour);
//     await prefs.setInt('minute', time.minute);
//   }

//   Future<void> loadSavedTime() async {
//     final prefs = await SharedPreferences.getInstance();
    
//     final hour = prefs.getInt('hour');
//     final minute = prefs.getInt('minute');

//     if (hour != null && minute != null) {
//       setState(() {
//         selectedTime = TimeOfDay(hour: hour, minute: minute);
//       });
//       scheduleAlarm(TimeOfDay(hour: hour, minute: minute));
//     }
//   }

//   void pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: selectedTime ?? TimeOfDay.now(),
//     );

//     if (time != null) {
//       setState(() {
//         selectedTime = time;
//       });
//       saveTime(time);
//       scheduleAlarm(time);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Daily Reminder'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               selectedTime == null
//                   ? 'No time selected'
//                   : 'Reminder set for: ${selectedTime!.format(context)}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickTime,
//               child: Text('Set Reminder Time'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
