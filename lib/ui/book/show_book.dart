import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:mivdevotional/ui/constants/constant_widgets.dart';
import 'package:flutter/material.dart';

class ShowBook extends StatelessWidget {
  final BibleBookWithChapters book;

  const ShowBook({required this.book});

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
                    builder: (_) => ShowChapter(fromSearch: false,
                          bookName: book.name,
                          chapter: index,
                        ))),
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
