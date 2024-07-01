import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:mivdevotional/ui/constants/constant_widgets.dart';
import 'package:flutter/material.dart';

class ShowBook extends StatelessWidget {
  final BibleBookWithChapters book;

  const ShowBook({required this.book});
  autoGotoNextChapter(context, index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowChapter(
                fromSearch: false,
                bookName: book.name,
                chapter: index + 1,
                autoRead: true))).then((value) {
      if (value.contains('next') &&
          int.parse(value.split(' ')[1]) < book.chapters) {
        autoGotoNextChapter(context, index + 1);
      }
    });
  }

  nextChapterRead(context, index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowChapter(
                fromSearch: false,
                notfFomSwipe: true,
                bookName: book.name,
                chapter: index + 1,
                autoRead: false))).then((value) {
      print(value);
      if (value.contains('forward') &&
          int.parse(value.split(' ')[1]) < book.chapters) {
        nextChapterRead(context, index + 1);
      }else   if (value.contains('backward') &&
          int.parse(value.split(' ')[1]) < book.chapters) {
              previousChapterRead(context, index +1);

      }
    });
  }

  previousChapterRead(context, index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowChapter(
                fromSearch: false,
                notfFomSwipe: true,
                bookName: book.name,
                chapter: index - 1,
                autoRead: false))).then((value) {
      print(value);
      if (value.contains('backward') && int.parse(value.split(' ')[1]) > 0) {
        previousChapterRead(context, index - 1);
      }else if (value.contains('forward') &&
          int.parse(value.split(' ')[1]) > 0) {
          nextChapterRead(context, index -1);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(child: back, onTap: () => Navigator.pop(context)),
        title: Text(
          book.name,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemCount: book.chapters,
        itemBuilder: (BuildContext context, index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ShowChapter(
                          fromSearch: false,
                          bookName: book.name,
                          lastChapter: book.chapters,
                          chapter: index,
                          autoRead: false,
                        ))).then((value) {
              print(value);
              if (value.contains('next') &&
                  int.parse(value.split(' ')[1]) < book.chapters) {
                autoGotoNextChapter(context, index);
              } else if (value.contains('forward') &&
                  int.parse(value.split(' ')[1]) < book.chapters) {
                nextChapterRead(context, index);
              } else if (value.contains('backward') &&
                  int.parse(value.split(' ')[1]) > 0) {
                previousChapterRead(context, index);
              }
            }),
            child: Card(
              child: Center(
                  child: Text(
                '${++index}',
                style: TextStyle(fontSize: 18),
              )),
            ),
          );
        },
      ),
    );
  }
}
