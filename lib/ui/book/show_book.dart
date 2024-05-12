import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:mivdevotional/ui/constants/constant_widgets.dart';
import 'package:flutter/material.dart';

class ShowBook extends StatelessWidget {
  final BibleBookWithChapters book;

  const ShowBook({required this.book});
autoGotoNextChapter(context,index){
    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>    ShowChapter(fromSearch: false,
                          bookName: book.name,
                          chapter: index+1,autoRead:true
                        ))).then((value) {
                          if(value.contains('next') && int.parse( value.split(' ')[1])<book.chapters){
                      autoGotoNextChapter(context, index+1);
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
                    builder: (_) => ShowChapter(fromSearch: false,
                          bookName: book.name,lastChapter:book.chapters,
                          chapter: index,autoRead: false,
                        ))).then((value) {
                          if(value.contains('next') && int.parse( value.split(' ')[1])<book.chapters){
                      autoGotoNextChapter(context, index);
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
