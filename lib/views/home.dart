import 'package:flutter/material.dart';
import 'package:vidg/Screens/welcome.dart';
import 'package:vidg/Services/database.dart';
import 'package:vidg/views/create_quiz.dart';
import 'package:vidg/views/quiz_play.dart';
import 'package:vidg/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: quizStream,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Center(
                        child: Container(
                          child: Text(
                            "Their is no quize",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return QuizTile(
                            noOfQuestions: snapshot.data.docs.length,
                            // imageUrl:
                            //     snapshot.data.docs[index].data()['quizImgUrl'],
                            title:
                                snapshot.data.docs[index].data()['quizTitle'],
                            description:
                                snapshot.data.docs[index].data()['quizDesc'],
                            id: snapshot.data.docs[index].data()["quizId"],
                          );
                        });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
            icon: Icon(Icons.arrow_back)),
        title: AppLogo(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xffff2d55),
        //brightness: Brightness.li,
      ),
      body: quizList(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xffff2d55),
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => CreateQuiz()));
      //   },
      // ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title, id, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
      // @required this.imageUrl,
      @required this.description,
      @required this.id,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(id)));
      },
      child: Container(
        //
        padding: EdgeInsets.only(bottom: 8, right: 8, left: 8, top: 8),
        height: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              //   width: MediaQuery.of(context).size.width,
              // ),
              Container(
                decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 231, 80, 108),
                    Color.fromARGB(255, 50, 53, 53)
                  ],
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title ?? 'default value',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description ?? 'default value',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
