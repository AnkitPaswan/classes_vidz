import 'package:flutter/material.dart';
import 'package:vidg/views/create_quiz.dart';
import 'package:vidg/views/home.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        children: [
          SizedBox(height: 40,),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 55, 20, 0),
        child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: Container(
          height: 120,
          width: double.infinity,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Click To Play Quiz",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )),
          ),
        ),
        ),
      ),SizedBox(height: 40,),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateQuiz()));
        },
        child: Container(
          height: 120,
          width: double.infinity,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Click To Create New Quize",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )),
          ),
        ),
        ),
      ),
        ],
      ),
      ),
    );
  }
}
