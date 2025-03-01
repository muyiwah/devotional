import 'dart:convert';


class SaveColor {
 final String book;
final int chapter;
final int verse;
final String color;
final String content;
  SaveColor({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.color,
    required this.content,
  });

  SaveColor copyWith({
    String? book,
    int? chapter,
    int? verse,
    String? color,
    String? content,
  }) {
    return SaveColor(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      color: color ?? this.color,
      content: color ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'book': book});
    result.addAll({'chapter': chapter});
    result.addAll({'verse': verse});
    result.addAll({'color': color});
    result.addAll({'content': content});
  
    return result;
  }

  factory SaveColor.fromMap(Map<String, dynamic> map) {
    return SaveColor(
      book: map['book'] ?? '',
      chapter: map['chapter']?.toInt() ?? 0,
      verse: map['verse']?.toInt() ?? 0,
      color: map['color'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveColor.fromJson(String source) => SaveColor.fromMap(json.decode(source));
  factory SaveColor.fromJsonJson(String source) => SaveColor.fromJson(json.decode(source));

  @override
  String toString() {
    return 'SaveColor(book: $book, chapter: $chapter, verse: $verse, color: $color, content: $content)';
  }

 
}
