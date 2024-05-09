import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/text.dart';

class WordClinicModel {
  String? title;
  String? subtitle;
  String? date;
  int? week;
  List<String>? scriptures;
  String? memoryVerse;
  String? discussion_title;
  String? objective;
  String? iNTRODUCTION;
  List<DISCUSSION>? discussion;
  String? conclusion;

  WordClinicModel(
      {this.title,
      this.subtitle,
      this.date,
      this.week,
      this.scriptures,
      this.discussion_title,
      this.memoryVerse,
      this.objective,
      this.iNTRODUCTION,
      this.discussion,
      this.conclusion});

  WordClinicModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    week = json['week'];
    subtitle = json['subtitle'];
    scriptures = json['scriptures'].cast<String>();
    memoryVerse = json['memory_verse'];
    objective = json['objective'];
    discussion_title = json['discussion_title'];
    iNTRODUCTION = json['INTRODUCTION'];
    if (json['DISCUSSION'] != null) {
      discussion = <DISCUSSION>[];
      json['DISCUSSION'].forEach((v) {
        discussion?.add(DISCUSSION.fromJson(v));
      });
    }
    conclusion = json['CONCLUSION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['week'] = week;
    data['date'] = date;
    data['subtitle'] = subtitle;
    data['scriptures'] = scriptures;
    data['discussion_title'] = discussion_title;
    data['memory_verse'] = memoryVerse;
    data['objective'] = objective;
    data['INTRODUCTION'] = iNTRODUCTION;
    if (discussion != null) {
      data['DISCUSSION'] = discussion!.map((v) => v.toJson()).toList();
    }
    data['CONCLUSION'] = conclusion;
    return data;
  }

  factory WordClinicModel.fromMap(Map<String, dynamic> map) {
    return WordClinicModel(
      title: map['title'] ?? '',
      week: map['week'] ?? 0,
      subtitle: map['subtitle'] ?? '',
      date: map['date'] ?? '',
      scriptures: List<String>.from(map['scriptures']) ?? [],
      memoryVerse: map['memory_verse'] ?? '',
      objective: map['objective'] ?? '',
      discussion_title: map['discussion_title'] ?? '',
      iNTRODUCTION: map['INTRODUCTION'] ?? '',
      discussion: map['DISCUSSION'] != null
          ? List<DISCUSSION>.from(
              map['DISCUSSION'].map((x) => DISCUSSION.fromMap(x)))
          : null,
      conclusion: map['CONCLUSION'] ?? '',
    );
  }
}

class DISCUSSION {
  String title;
  List<String> scriptures;

  DISCUSSION({
    required this.title,
    required this.scriptures,
  });

  // DISCUSSION.fromJson(Map<String, dynamic> json) {
  //   title = json['title'];
  //   scriptures = json['scriptures'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['title'] = this.title;
  //   data['scriptures'] = this.scriptures;
  //   return data;
  // }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'scriptures': scriptures});

    return result;
  }

  factory DISCUSSION.fromMap(Map<String, dynamic> map) {
    return DISCUSSION(
      title: map['title'] ?? '',
      scriptures: map['scriptures'] != null
          ? List<String>.from(map['scriptures'])
          : [''],
    );
  }

  String toJson() => json.encode(toMap());

  factory DISCUSSION.fromJson(String source) =>
      DISCUSSION.fromMap(json.decode(source));

  @override
  String toString() => 'DISCUSSION(title: $title, scriptures: $scriptures)';

  map(Text Function(dynamic e) param0) {}
}
