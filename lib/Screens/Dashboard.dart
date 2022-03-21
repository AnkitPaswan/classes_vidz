import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:motion_tab_bar/MotionTabController.dart';
// import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:random_string/random_string.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:share/share.dart';
import 'package:vidg/Screens/documents.dart';
import 'package:vidg/Screens/history.dart';
import 'package:vidg/Screens/welcome/welcome_screen.dart';
import 'package:vidg/Services/jitsiMeetService.dart';
import 'package:vidg/Services/services.dart';

import 'SettingScreen.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  TabController _tabController;
  TextEditingController meeting = TextEditingController();
  TextEditingController joinmeeting = TextEditingController();
  TextEditingController subject = TextEditingController();
  bool enableAudio = true;
  bool enableVideo = true;
  bool isLoading = false;
  String meetingCode;
  final _formKey = GlobalKey<FormState>();
  JitsiMeets meets = JitsiMeets();
  String name, email;
  int option = 0;
  int bottom = 1;

  FirebaseServices services = FirebaseServices();

  @override
  void initState() {
    _tabController = TabController(initialIndex: 1, length: 4, vsync: this);
    rendomText();
    super.initState();
    getUserData();
  }

  getUserData() async {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser.uid);
    databaseReference.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value;
      name = values["name"];
      email = values["email"];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  shareMeetingCode() {
    Share.share(
        "Hey Buddy! Use This Code to Do meeting with me on VidZ Download App and in Join Meeting Use Code $meetingCode");
  }

  rendomText() {
    meetingCode = randomAlphaNumeric(10);
    meeting.text = meetingCode;
  }

  returnScreeen() {
    switch (option) {
      case 0:
        return createMeeting();
        break;
      case 1:
        return joinMeeting();
        break;
      default:
        return SettingScreen();
    }
  }

  handleBottomNavigationBar() {
    switch (bottom) {
      case 0:
        return History();
        break;
      case 1:
        return dashboardMain();
        break;
      case 2:
        return DocumentSection();
      case 3:
        return WelcomeScreen();
      default:
        return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xffff2d55),
          title: Text(
            "VidZ",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                icon: Icon(Icons.menu,size: 30.0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
              ),
            ),
          ],
          elevation: 6.0,
          centerTitle: true,
          shape: const MyShapeBorder(30),
        ),
        bottomNavigationBar: MotionTabBar(
          labels: ["History", "Call", "Document", "Quiz"],
          initialSelectedTab: "Call",
          tabIconColor: Colors.redAccent,
          tabSelectedColor: Color(0xffff2d55),
          onTabItemSelected: (int value) {
            setState(() {
              bottom = value;
              print(bottom);
              _tabController.index = value;
            });
          },
          icons: [
            Icons.history,
            Icons.video_call,
            Icons.file_copy_rounded,
            Icons.quiz_sharp,
          ],
          textStyle: TextStyle(color: Color(0xffff2d55)),
        ),
        body: handleBottomNavigationBar());
  }

  Widget dashboardMain() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: TabBar(
              onTap: (value) => {
                setState(() {
                  option = value;
                  print(option);
                })
              },
              tabs: [
                Tab(
                  text: "Create Meeting",
                ),
                Tab(
                  text: "Join Meeting",
                ),
              ],
              labelColor: Colors.black,
              indicator: RectangularIndicator(
                color: Color(0xffff2d55),
                bottomLeftRadius: 80,
                bottomRightRadius: 80,
                topLeftRadius: 80,
                topRightRadius: 80,
                paintingStyle: PaintingStyle.stroke,
              ),
            ),
          ),
        ),
        returnScreeen()
      ],
    );
  }

  Widget createMeeting() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black, // shadow direction: bottom right
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 10),
                  child: Container(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: subject,
                      validator: (meetings) {
                        if (meetings == null || meetings.isEmpty) {
                          return "Meeting Subject Is Empty";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Meeting Subject',
                          prefixIcon: Icon(Icons.subject),
                          labelStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: meeting,
                      validator: (meetings) {
                        if (meetings == null || meetings.isEmpty) {
                          return "Meeting Name Is Empty";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Meeting Name',
                          prefixIcon: Icon(Icons.videocam),
                          labelStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Mute Audio"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: FlutterSwitch(
                                width: 60.0,
                                height: 30.0,
                                valueFontSize: 12.0,
                                toggleSize: 20.0,
                                value: enableAudio,
                                activeColor: Color(0xffff2d55),
                                inactiveColor: Colors.grey,
                                inactiveToggleColor: Colors.black,
                                inactiveTextColor: Colors.white,
                                activeText: "",
                                inactiveText: "",
                                activeTextColor: Colors.black,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    enableAudio = val;
                                  });
                                }),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Mute Video"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: FlutterSwitch(
                                width: 60.0,
                                height: 30.0,
                                valueFontSize: 12.0,
                                toggleSize: 20.0,
                                value: enableVideo,
                                activeColor: Color(0xffff2d55),
                                inactiveColor: Colors.grey,
                                inactiveToggleColor: Colors.black,
                                inactiveTextColor: Colors.white,
                                activeText: "",
                                inactiveText: "",
                                activeTextColor: Colors.black,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    enableVideo = val;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      shareMeetingCode();
                    },
                    child: Text(
                      "Share This Meeting Code?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        services.addMeetingInFirebase(
                          subject.text,
                          meetingCode,
                          email,
                        );
                        meets.joinMeeting(meetingCode, name, email,
                            subject.text, enableAudio, enableVideo);
                      }
                    },
                    child: isLoading != true
                        ? Text(
                            'Create Meeting'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                    color: Color(0xffff2d55),
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget joinMeeting() {
    {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black, // shadow direction: bottom right
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: joinmeeting,
                        validator: (meetings) {
                          if (meetings == null || meetings.isEmpty) {
                            return "Meeting Name Is Empty";
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Meeting Name',
                            prefixIcon: Icon(Icons.videocam),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Mute Audio"),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: FlutterSwitch(
                                  width: 60.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: enableAudio,
                                  activeColor: Color(0xffff2d55),
                                  inactiveColor: Colors.grey,
                                  inactiveToggleColor: Colors.black,
                                  inactiveTextColor: Colors.white,
                                  activeText: "",
                                  inactiveText: "",
                                  activeTextColor: Colors.black,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      enableAudio = val;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Mute Video"),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: FlutterSwitch(
                                  width: 60.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: enableVideo,
                                  activeColor: Color(0xffff2d55),
                                  inactiveColor: Colors.grey,
                                  inactiveToggleColor: Colors.black,
                                  inactiveTextColor: Colors.white,
                                  activeText: "",
                                  inactiveText: "",
                                  activeTextColor: Colors.black,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      enableVideo = val;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          meets.joinMeeting(joinmeeting.text, name, email,
                              subject.text, enableAudio, enableVideo);
                        }
                      },
                      child: isLoading != true
                          ? Text(
                              'Join Meeting'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                      color: Color(0xffff2d55),
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);

  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 2,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
