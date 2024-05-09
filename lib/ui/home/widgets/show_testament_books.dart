import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/ui/book/show_book.dart';
import 'package:flutter/material.dart';

class ShowTestamentBooks extends StatelessWidget {
  final List<BibleBookWithChapters> books;

  const ShowTestamentBooks({required this.books});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.screenHeight * 72.5,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (BuildContext context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Text(
                        '${++index}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        books[--index].name,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ShowBook(
                                book: books[index],
                              ))),
                ),
              )),
    );
  }
}
