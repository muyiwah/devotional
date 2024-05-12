import 'package:flutter/material.dart';
import 'package:mivdevotional/ui/home/dashboard.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/bible3.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Devotional',
                        style: TextStyle(color: Colors.white, fontSize: 60,),
                      ),
                   Text(
                  'The Men of Issachar Vision',
                  style: TextStyle(color: Colors.white, fontSize: 20,),
                ),    ],
                  ),
                ),
             
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 62),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromARGB(255, 15, 179, 18).withOpacity(.5)),
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.w200,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                            'click on all references to see scripture',
                            style: TextStyle(color: Colors.white, fontSize: 14,),
                          ),
             SizedBox(
                  height: 30,
                ),  ],
            ),
          ),
        ],
      ),
    );
  }
}
