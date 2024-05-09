import 'dart:convert';

class NotepadModel {
  String title;
  String noteContents;
  String date;
  String id;
  NotepadModel({
    required this.title,
    required this.noteContents,
    required this.date,
    required this.id,
  });

 

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'title': title});
    result.addAll({'noteContents': noteContents});
    result.addAll({'date': date});
    result.addAll({'id': id});
  
    return result;
  }

  factory NotepadModel.fromMap(Map<String, dynamic> map) {
    return NotepadModel(
      title: map['title'] ?? '',
      noteContents: map['noteContents'] ?? '',
      date: map['date'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotepadModel.fromJson(String source) => NotepadModel.fromMap(json.decode(source));
  factory NotepadModel.fromJsonJson(String source) => NotepadModel.fromJson(json.decode(source));

  @override
  String toString() => 'NotepadModel(title: $title, noteContents: $noteContents, date: $date)';

}
