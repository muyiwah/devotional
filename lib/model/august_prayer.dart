import 'dart:convert';

import 'package:flutter/foundation.dart';

class AugustPrayer {
  String date;
  String title;
  List<String>? scriptures;
  bool isMultilevel;
  String anchor_passage;
  String Discussion_title;
  List<PrayerFoci>? prayer_foci;
  AugustPrayer({
    this.date='',
    this.title='',
    this.scriptures,
    this.isMultilevel=false,
    this.anchor_passage='',
    this.Discussion_title='',
    this.prayer_foci,
  });

  // AugustPrayer(
  //     {this.date,
  //     this.title,
  //     this.scriptures,
  //     this.isMultilevel,
  //     this.anchor_passage,
  //     this.Discussion_title,
  //     this.prayer_foci});

  // AugustPrayer.fromJson(Map<String, dynamic> json) {
  //   date = json['date'];
  //   title = json['title'];
  //   scriptures = json['scriptures'].cast<String>();
  //   isMultilevel = json['isMultilevel'];
  //   anchor_passage = json['anchor_passage'];
  //   Discussion_title = json['Discussion_title'];
  //   if (json['prayer_foci'] != null) {
  //     prayer_foci = <PrayerFoci>[];
  //     json['prayer_foci'].forEach((v) {
  //       prayer_foci!.add(new PrayerFoci.fromJson(v));
  //     });
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['date'] = this.date;
  //   data['title'] = this.title;
  //   data['scriptures'] = this.scriptures;
  //   data['isMultilevel'] = this.isMultilevel;
  //   data['anchor_passage'] = this.anchor_passage;
  //   data['Discussion_title'] = this.Discussion_title;
  //   if (this.prayer_foci != null) {
  //     data['prayer_foci'] = this.prayer_foci!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }

  AugustPrayer copyWith({
    String? date,
    String? title,
    List<String>? scriptures,
    bool? isMultilevel,
    String? anchor_passage,
    String? Discussion_title,
    List<PrayerFoci>? prayer_foci,
  }) {
    return AugustPrayer(
      date: date ?? this.date,
      title: title ?? this.title,
      scriptures: scriptures ?? this.scriptures,
      isMultilevel: isMultilevel ?? this.isMultilevel,
      anchor_passage: anchor_passage ?? this.anchor_passage,
      Discussion_title: Discussion_title ?? this.Discussion_title,
      prayer_foci: prayer_foci ?? this.prayer_foci,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(date != null){
      result.addAll({'date': date});
    }
    if(title != null){
      result.addAll({'title': title});
    }
    if(scriptures != null){
      result.addAll({'scriptures': scriptures});
    }
    if(isMultilevel != null){
      result.addAll({'isMultilevel': isMultilevel});
    }
    if(anchor_passage != null){
      result.addAll({'anchor_passage': anchor_passage});
    }
    if(Discussion_title != null){
      result.addAll({'Discussion_title': Discussion_title});
    }
    if(prayer_foci != null){
      result.addAll({'prayer_foci': prayer_foci!.map((x) => x?.toMap()).toList()});
    }
  
    return result;
  }

  factory AugustPrayer.fromMap(Map<String, dynamic> map) {
    return AugustPrayer(
      date: map['date']??'',
      title: map['title']??'',
      scriptures: List<String>.from(map['scriptures'])??[],
      isMultilevel: map['isMultilevel']??false,
      anchor_passage: map['anchor_passage']??'',
      Discussion_title: map['Discussion_title']??'',
      prayer_foci: map['prayer_foci'] != null ? List<PrayerFoci>.from(map['prayer_foci']?.map((x) => PrayerFoci.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AugustPrayer.fromJson(String source) => AugustPrayer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AugustPrayer(date: $date, title: $title, scriptures: $scriptures, isMultilevel: $isMultilevel, anchor_passage: $anchor_passage, Discussion_title: $Discussion_title, prayer_foci: $prayer_foci)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AugustPrayer &&
      other.date == date &&
      other.title == title &&
      listEquals(other.scriptures, scriptures) &&
      other.isMultilevel == isMultilevel &&
      other.anchor_passage == anchor_passage &&
      other.Discussion_title == Discussion_title &&
      listEquals(other.prayer_foci, prayer_foci);
  }

  @override
  int get hashCode {
    return date.hashCode ^
      title.hashCode ^
      scriptures.hashCode ^
      isMultilevel.hashCode ^
      anchor_passage.hashCode ^
      Discussion_title.hashCode ^
      prayer_foci.hashCode;
  }

}

class PrayerFoci {
  String? title;
  List<String> scriptures;
  PrayerFoci({
    this.title,
   required this.scriptures,
  });

  // PrayerFoci({this.title, this.scriptures});

  // PrayerFoci.fromJson(Map<String, dynamic> json) {
  //   title = json['title'];
  //   scriptures = json['scriptures'].cast<String>();
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['title'] = this.title;
  //   data['scriptures'] = this.scriptures;
  //   return data;
  // }

  PrayerFoci copyWith({
    String? title,
    List<String>? scriptures,
  }) {
    return PrayerFoci(
      title: title ?? this.title,
      scriptures: scriptures ?? this.scriptures,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(title != null){
      result.addAll({'title': title});
    }
    if(scriptures != null){
      result.addAll({'scriptures': scriptures});
    }
  
    return result;
  }

  factory PrayerFoci.fromMap(Map<String, dynamic> map) {
    return PrayerFoci(
      title: map['title'],
      scriptures: map['scriptures'] != null
          ? List<String>.from(map['scriptures'])
          : [''],
    );
  }

  String toJson() => json.encode(toMap());

  factory PrayerFoci.fromJson(String source) => PrayerFoci.fromMap(json.decode(source));

  @override
  String toString() => 'PrayerFoci(title: $title, scriptures: $scriptures)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PrayerFoci &&
      other.title == title &&
      listEquals(other.scriptures, scriptures);
  }

  @override
  int get hashCode => title.hashCode ^ scriptures.hashCode;
}
