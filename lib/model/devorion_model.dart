import 'dart:convert';

class DevotionModel {
    final String title;
    final String reference;
    final String scripture;
    final String action_plan;
    final String thought;
    final String prayer;
    final String text;
    final String date;
  DevotionModel({
    required this.title,
    required this.reference,
    required this.scripture,
    required this.action_plan,
    required this.thought,
    required this.prayer,
    required this.text,
    required this.date,
  });

  DevotionModel copyWith({
    String? title,
    String? reference,
    String? scripture,
    String? action_plan,
    String? thought,
    String? prayer,
    String? text,
    String? date,
  }) {
    return DevotionModel(
      title: title ?? this.title,
      reference: reference ?? this.reference,
      scripture: scripture ?? this.scripture,
      action_plan: action_plan ?? this.action_plan,
      thought: thought ?? this.thought,
      prayer: prayer ?? this.prayer,
      text: text ?? this.text,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'title': title});
    result.addAll({'reference': reference});
    result.addAll({'scripture': scripture});
    result.addAll({'action_plan': action_plan});
    result.addAll({'thought': thought});
    result.addAll({'prayer': prayer});
    result.addAll({'text': text});
    result.addAll({'date': date});
  
    return result;
  }

  factory DevotionModel.fromMap(Map<String, dynamic> map) {
    return DevotionModel(
      title: map['title'] ?? '',
      reference: map['reference'] ?? '',
      scripture: map['scripture'] ?? '',
      action_plan: map['action_plan'] ?? '',
      thought: map['thoughts'] ?? '',
      prayer: map['prayer'] ?? '',
      text: map['text'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DevotionModel.fromJson(String source) => DevotionModel.fromMap(json.decode(source));


}
