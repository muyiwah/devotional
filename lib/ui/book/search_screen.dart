import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/model/bible.model.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:mivdevotional/ui/book/show_chapter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Bible> result = [];
  final TextEditingController _controller = TextEditingController();
bool isSearched=false;
  searchBible(context) {
 isSearched=false;

    print(_controller.text);
    result = Provider.of<BibleModel>(context, listen: false)
        .search(_controller.text);
    result.forEach((element) {
      print(element.text);
    });
    setState(() {});
    isSearched=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('word search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 150,
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_controller.text.length > 1) {
                      searchBible(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 40,
                    color: Colors.green,
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          if(isSearched)  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
            '${ result.length} hits',          style: TextStyle(color: Colors.black),
              ),
          ),
            if (result.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: ((context, index) {
                  return    InkWell(onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowChapter(bookName:result[index].book ,fromSearch:true,searchedText: _controller.text,hits: result.length,
                                  chapter: result[index].chapter,verse: result[index].verse,autoRead: false,)));
                  },
                    child: Container(padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(4),
                          height: 72,
                          decoration: BoxDecoration(color: Colors.green.withOpacity(.4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Text(
                                result[index].text,
                                maxLines: 2,
                                style: TextStyle(color: Colors.black,fontSize: 16),
                              ),
                           Align(alignment: Alignment.bottomRight,
                             child: Text(
                                 '${ result[index].book} ${ result[index].chapter}:${ result[index].verse}',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                ),
                           ),  ],
                          ),
                        ),
                  );
                    })),
              )
          ],
        ),
      ),
    );
  }
}
