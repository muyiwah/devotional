import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mivdevotional/core/model/word_clinic.dart';
import 'package:mivdevotional/core/provider/bible.provider.dart';
import 'package:provider/provider.dart';

class WordClinicPage extends StatefulWidget {
  const WordClinicPage({super.key});

  @override
  State<WordClinicPage> createState() => _WordClinicPageState();
}

class _WordClinicPageState extends State<WordClinicPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllWordClinic();
  }

  List<WordClinicModel> allWordClinickkk = [];
  List<DISCUSSION> _discussion = [];
  getAllWordClinic() async {
    allWordClinickkk =
        await Provider.of<BibleModel>(context, listen: false).getWordClinic();
    // todayDevotional =
    //     (allDevotional.firstWhere((element) => element.date == refineDate()));
    _discussion = (allWordClinickkk[0].discussion)!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(allWordClinickkk[0].title.toString()),
          Text(allWordClinickkk[0].subtitle.toString()),
          Row(
            children: allWordClinickkk[0]
                .scriptures!
                .map((e) =>
                    InkWell(onTap: () => print(e), child: Text(e.toString())))
                .toList(),
          ),
          Text(allWordClinickkk[0].objective.toString()),
          Text(
            allWordClinickkk[0].iNTRODUCTION.toString(),
            style: TextStyle(fontSize: 22),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _discussion.length,
                  itemBuilder: (context, index) => Container(
                        child: Wrap(
                          children: [
                            Text(_discussion[index].title.toString(),
            style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Wrap(
                              children: _discussion[index]
                                  .scriptures
                                  .map((e) => InkWell(
                                      onTap: () => print(e),
                                      child: Container(
                                          padding: EdgeInsets.all(3),
                                          color: Colors.amber.withOpacity(.2),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Text(e,
            style: TextStyle(fontSize: 22),
                                          ))))
                                  .toList(),
                            )
                          ],
                        ),
                      ))),
          Text(allWordClinickkk[0].conclusion.toString(),
            style: TextStyle(fontSize: 22),
          ),
          // Spacer()
        ],
      ),
    );
  }
}
