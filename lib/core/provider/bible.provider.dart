import 'dart:convert';

import 'package:mivdevotional/model/august_prayer.dart';
import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/model/devorion_model.dart';
import 'package:mivdevotional/model/word_clinic.dart';
import 'package:mivdevotional/core/repository/repository.dart';
import 'package:flutter/foundation.dart';

class BibleModel extends ChangeNotifier {
  final String path = 'assets/bibleJson/';
  Repository _repository = Repository();
  List _bible = [];
  List _bibleAsv = [];
  List _bibleNiv = [];
  List _bibleNlt = [];
  List _bibleMsg = [];
  List _bibleAmp = [];
  List _bibleBbe = [];
  List _bibleDby = [];
  List _bibleRsv = [];
  List _bibleBishop = [];
  List<BibleBookWithChapters> _oldTestamentBooks = [];
  List<BibleBookWithChapters> _newTestamentBooks = [];
  List _chaptersPerBook = [];

  List get bible => _bible;
  List get bibleAsv => _bibleAsv;
  List get bibleNiv => _bibleNiv;
  List get bibleNlt => _bibleNlt;
  List get bibleMsg => _bibleMsg;
  List get bibleAmp => _bibleAmp;
  List get bibleBbe => _bibleBbe;
  List get bibleRsv => _bibleRsv;
  List get bibleDby => _bibleDby;
  List get bibleBishop => _bibleBishop;

  List get oldTestamentBooks => _oldTestamentBooks;
  List get newTestamentBooks => _newTestamentBooks;
  List get chaptersPerBook => _chaptersPerBook;
  List<Bible> searchData = [];
  List<Bible> searchDataAsv = [];
  List<Bible> searchResult = [];
  Future getBibleText() async {
    List bibleText =[];

    await _repository.getBible(path + 'bible.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bible = bibleText;
     for(int x=0;bibleText.length>x;x++){
      searchData.add(bibleText[x]);
     }
    });
    notifyListeners();
  }

Future getAsvText() async {
    List bibleText =[];

    await _repository.getBible(path + 'asv.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleAsv = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }




Future getDbyText() async {
    List bibleText =[];

    await _repository.getBible(path + 'dby.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleDby = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }
Future getBbeText() async {
    List bibleText =[];

    await _repository.getBible(path + 'bbe.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleBbe = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }


  
Future getRsvText() async {
    List bibleText =[];

    await _repository.getBible(path + 'rsv.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleRsv = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }
























Future getAmpText() async {
    List bibleText =[];

    await _repository.getBible(path + 'amplified.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleAmp = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }


Future getNltText() async {
    List bibleText =[];

    await _repository.getBible(path + 'nlt.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      // print(bibleText.length);
      _bibleNlt = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }
  
  Future getNivText() async {
    List bibleText =[];

    await _repository.getBible(path + 'niv.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      // print(bibleText.length);
      _bibleNiv = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }
  
  Future getMsgText() async {
    List bibleText =[];

    await _repository.getBible(path + 'msgBible.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleMsg = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }
  
  Future getBishopText() async {
    List bibleText =[];

    await _repository.getBible(path + 'bishop.json').then((bibleData) {
      var decodedJson = jsonDecode(bibleData);
      // searchData = decodedJson.map((row) => Bible.fromJson(row)).toList();
      bibleText = decodedJson.map((row) => Bible.fromJson(row)).toList();
      _bibleBishop = bibleText;
    //  for(int x=0;bibleText.length>x;x++){
    //   searchDataAsv.add(bibleText[x]);
    //  }
    });
    notifyListeners();
  }




  List<Bible> search(data) {

    searchResult.clear();
    for (int x = 0; searchData.length > x; x++) {
      if (searchData[x].text.toLowerCase().contains(data)) {
        searchResult.add(searchData[x]);
      }
    }
    return searchResult;
  }

  Future getBibleBook() async {
    print('called');
    await _repository
        .getBible(path + 'bible_books.json')
        .then((bibleBooksList) {
      var decodedJson = jsonDecode(bibleBooksList);
      List bibleBooks =
          decodedJson.map((book) => BibleBook.fromJson(book)).toList();
      partitionBooks(bibleBooks);
    });
    notifyListeners();
  }

  void partitionBooks(bibleBooks) {
    try {
      // partition books
      _oldTestamentBooks = [];
      _newTestamentBooks = [];
      for (int i = 0; i < bibleBooks.length; i++) {
        if (i < 39) {
          _oldTestamentBooks.add(bibleBooks[i]);
        } else {
          _newTestamentBooks.add(bibleBooks[i]);
        }
      }
    } catch (e) {
      // print(e.toString());
    }
    notifyListeners();
  }

  Future getChapterPerBook() async {
    await _repository.getBible(path + 'chapter_per_book.json').then((data) {
      var decodedJson = jsonDecode(data);
      // print(decodedJson.length); // 1 then no looping else loop
      final sourceMap = decodedJson.first;
      // print(sourceMap);
      final books = sourceMap.keys;
      List chapters = [];
      for (var book in books) {
        var bibleBook_ = {'name': book, 'chapters': sourceMap[book]};

        chapters.add(bibleBook_);
      }
      List bookChapters = [];
      chapters.forEach((book) {
        bookChapters.add(BibleBookWithChapters.fromJson(book));
      });

      partitionBooks(bookChapters);
    });
    notifyListeners();
  }

  // List<DevotionModel> get allDevotional => _allDevotional;
  Future<List<DevotionModel>> getDevotional() async {
    List<DevotionModel> allDevotional = [];

    await _repository.getBible('${path}devotion_data.json').then((data) {
      var decodedJson = jsonDecode(data);
      for (int i = 0; decodedJson.length > i; i++) {
        allDevotional.add(DevotionModel.fromMap(decodedJson[i]));
      }
      // print('locatipn');

      return allDevotional;
    });

    return allDevotional;
    // notifyListeners();
  }

  Future<List<WordClinicModel>> getWordClinic() async {
    List<WordClinicModel> allWordClinic = [];

    await _repository.getBible('${path}word_clinic.json').then((data) {
      var decodedJson = jsonDecode(data);
      for (int i = 0; decodedJson.length > i; i++) {
        allWordClinic.add(WordClinicModel.fromMap(decodedJson[i]));
      }
      // print(decodedJson);
      // print(allDevotional.firstWhere((element) => element.date=="March 23"));
      return allWordClinic;
    });

    return allWordClinic;
    // notifyListeners();
  }

  Future<List<AugustPrayer>> getAllPrayerConference() async {
    List<AugustPrayer> allWordClinic = [];

    await _repository.getBible('${path}august_prayers.json').then((data) {
      var decodedJson = jsonDecode(data);
      for (int i = 0; decodedJson.length > i; i++) {
        allWordClinic.add(AugustPrayer.fromMap(decodedJson[i]));
      }
      // print(decodedJson);
      // print(allDevotional.firstWhere((element) => element.date=="March 23"));
      return allWordClinic;
    });

    return allWordClinic;
    // notifyListeners();
  }

}
