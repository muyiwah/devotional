class Bible {
  final String book;
  final int chapter;
  final int verse;
  final String text;

  Bible({required this.book, required this.chapter, required this.verse, required this.text});

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
        book: json['Book'],
        chapter: json['Chapter']??0,
        verse: json['Verse']??0,
        text: json['Text']??'');
  }
}

class Book {
  final String name;
  final List<Chapter> chapter;

  Book({required this.name, required this.chapter});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        name: json['Book'],
        chapter: json['Chapter'].map((row) => Chapter.fromJson(row)).toList());
  }
}

class Chapter {
  final int chapter;
  final List<Verse> verse;

  Chapter({required this.chapter, required this.verse});
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(chapter: json['chapter'], verse: json['verse']);
  }
}

class Verse {
  final int verse;
  final String text;

  Verse({required this.verse, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(verse: json['Verse'], text: json['Text']);
  }
}

class BibleBook {
  final String name;
  BibleBook({required this.name});
  factory BibleBook.fromJson(json) {
    return BibleBook(name: json);
  }
}

class BibleBookWithChapters {
  final String name;
  final int chapters;

  BibleBookWithChapters({required this.name, required this.chapters});

  factory BibleBookWithChapters.fromJson(json) {
      // print(json);
      // print(json['name']);
      return BibleBookWithChapters(
          name: json['name'], chapters: json['chapters'].length);
   
  }
}

class Chapters {
  final List<int> chapters;
  final List<int> verses;

  Chapters({required this.chapters, required this.verses});

  factory Chapters.fromJson(Map json) {
    print(json);
    return Chapters(chapters: [], verses: []);
  }
}
