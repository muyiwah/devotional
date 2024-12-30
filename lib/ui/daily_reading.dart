
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mivdevotional/model/bible.model.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyBiblePage extends StatefulWidget {
  @override
  _DailyBiblePageState createState() => _DailyBiblePageState();
}

class _DailyBiblePageState extends State<DailyBiblePage> {
  List<Bible>? bibleData;
  List<dynamic>? readingPlan;
  int completedDays = 0;

  @override
  void initState() {
    super.initState();
    loadResources();
  }

  Future<void> loadResources() async {
    bibleData = await loadBibleData();
    final planData =
        await rootBundle.loadString('assets/bibleJson/monthone.json');
    readingPlan = json.decode(planData);
  // Load progress
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completedDays = prefs.getInt('completedDays') ?? 0;
    });
  }
  Future<void> markAsCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completedDays += 1;
    });
    await prefs.setInt('completedDays', completedDays);
  }
  Future<List<Bible>> loadBibleData() async {
    final data = await rootBundle.loadString('assets/bibleJson/asv.json');
    final jsonData = json.decode(data) as List<dynamic>;
    return jsonData.map((entry) => Bible.fromJson(entry)).toList();
  }

  List<Bible> extractVerses(
      List<Bible> bibleData, String book, int startChapter, int endChapter) {
    return bibleData.where((entry) {
      return entry.book == book &&
          entry.chapter >= startChapter &&
          entry.chapter <= endChapter;
    }).toList();
  }

  String buildPassageText(List<Bible> verses, int d) {
    return verses
        .mapIndexed((count, verse) => "${count + 1}. ${verse.text}")
        .join('\n');
  }

  Map<String, dynamic>? getDailyReadings(List<dynamic> readingPlan, int day) {
    return readingPlan.firstWhere((plan) => plan['day'] == day,
        orElse: () => null);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final day = today.day;
    final dayPlan = getDailyReadings(readingPlan ?? [], day);

    if (bibleData == null || dayPlan == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Daily Bible Readings')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    List ref = [];
    final readings = <String, List<Bible>>{};
    dayPlan['readings'].forEach((key, value) {
      print(value);
      ref.add(value);
      final parts = value.split(RegExp(r'[\s:-]'));
      final book = parts[0];
      final startChapter = int.parse(parts[1]);
      final endChapter = parts.length > 2 ? int.parse(parts[2]) : startChapter;
      readings[key] = extractVerses(bibleData!, book, startChapter, endChapter);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Daily Bible Readings $day')),
      body: Column(
        children: [
               Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Progress: $completedDays / ${readingPlan?.length ?? 0} days completed',
                  style: TextStyle(fontSize: 16),
                ),
                LinearProgressIndicator(
                  value: (completedDays / (readingPlan?.length ?? 1)).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 8,
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView(
                children: readings.entries.mapIndexed((i, entry) {
                  print(i);
                  final category = entry.key.replaceAll('_', ' ').toUpperCase();
                  final verses = entry.value;
                  final text = buildPassageText(verses, i);
                  return ListTile(
                    title: Text(ref[i]),
                    subtitle: Text(
                      text,
                      style: TextStyle(fontSize: 18, height: 1.6),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
