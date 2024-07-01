import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/core/utility/config.dart';
import 'package:mivdevotional/ui/book/show_book.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowTestamentBooks extends StatefulWidget {
  final List<BibleBookWithChapters> books;

  const ShowTestamentBooks({required this.books});

  @override
  State<ShowTestamentBooks> createState() => _ShowTestamentBooksState();
}

class _ShowTestamentBooksState extends State<ShowTestamentBooks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFontSize();
  }

  double appfontSize = 0;
  getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fontSize')) {
      appfontSize = prefs.getDouble('fontSize') ?? 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.screenHeight * 72.5,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.books.length,
          itemBuilder: (BuildContext context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Text(
                        '${++index}.',
                        style: TextStyle(fontSize: 18+ appfontSize),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        widget.books[--index].name,
                        style: TextStyle(fontSize: 18+ appfontSize),
                      )
                    ],
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ShowBook(
                                book: widget.books[index],
                              ))),
                ),
              )),
    );
  }
}
