
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:squat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squat/routes/workout_record.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage(
      {Key key,
      this.title,
      this.shoulder_hip_value,
      this.hip_knee_value,
      this.knee_ankle_value}) 
      : super(key: key);
  final String title;
  final dynamic shoulder_hip_value;
  final dynamic hip_knee_value;
  final dynamic knee_ankle_value;

  @override
  ResultsPagestate createState() {
    s_hip = shoulder_hip_value;
    h_knee = hip_knee_value;
    k_ankle = knee_ankle_value;
    // shoulder_hip_value,hip_knee_value,knee_ankle_value
    return ResultsPagestate();
  } 
}
dynamic s_hip = 0;
dynamic h_knee = 0;
dynamic k_ankle = 0;
class ResultsPagestate extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
            centerTitle: true,
            title: new Text('JUMPY',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 45)),
            backgroundColor: SquatApp().squatPrimary),
      ),
      body: ResultsList(),
      bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 45)),
              )
            ],
          ),
          color: SquatApp().squatPrimary),
    );
  }

  fastForward() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutRecordPage(),
      ),
    );
  }
}

class ResultsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ResultsListState();
  }
}

class ResultsListState extends State<ResultsList> {
  static var size = Size(0, 0);
  final imageLinks = ['Hi', 'Nah', 'You', 'Right?'];
  final headerText = ['Squats', 'Pullups', 'Running', 'Wow'];
  final contentText = [
    'Time for your glutes.',
    'You think you got form?',
    'Great',
    'New apartment!'
  ];

  /*24 is for notification bar on Android*/
  static double itemHeight = (size.height - kToolbarHeight - 24) / 2;
  static double itemWidth = size.width / 2;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 7.5, right: 15, top: 15),
            child: Text('RESULTS',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.normal,
                    height: 1,
                    fontSize: 28))),
        Align(
          child: AspectRatio(aspectRatio: 1.1, child: buildList()),
        ),
        Center(
          child: Text(
            'Great job!\nDo better next time.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 24,
                height: 1.5,
                fontFamily: "RobotoCondensed"),
          ),
        ),
      ],
    );
  }

  Widget buildList() {
    final imageLinks = [
      'assets/squatRecognition.png',
      'assets/splash.png',
      'assets/squat.png'
    ];

    return Container(
        child: ListView.builder(
            itemCount: 4,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) {
              return buildCard(index);
            }));
  }

  Widget buildCard(index) {
// shoulder_hip_value,hip_knee_value,knee_ankle_value
    final headerText = [
      'Shoulder-Hip',
      'Hip-Knee',
      'Knee-Ankle',
      // 'Breadth',
      // 'Shoulder Inflection'
    ];
    dynamic values = [s_hip, h_knee,k_ankle];

    return new Center(
      child: Column(children: [
        Row(
          children: <Widget>[
            SizedBox(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                  child: Text(
                    headerText[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        fontFamily: "RobotoCondensed"),
                  )),
              width: 100,
            ),
            SizedBox(
              width: 250,
              child: IconRoundedProgressBar(
                widthIconSection: 70,
                icon: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.person, color: Colors.white)),
                style: RoundedProgressBarStyle(
                    colorBackgroundIcon: Color(0xffc0392b),
                    colorProgress: Color(0xffe74c3c),
                    colorProgressDark: Color(0xffc0392b),
                    colorBorder: Color(0xff2c3e50),
                    backgroundProgress: Color(0xff4a627a),
                    borderWidth: 0,
                    widthShadow: 3),
                margin: EdgeInsets.symmetric(vertical: 16),
                borderRadius: BorderRadius.circular(4),
                percent: values[index],
              ),
            ),
          ],
        ),
      ]),
      // child: Card(
      //   elevation: 5,
      //   child: Container(
      //     height: 80.0,
      //     width: 80.0,
      //     child: Row(
      //       children: <Widget>[
      //         Container(
      //           height: 80.0,
      //           width: 100.0,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(0),
      //                 topLeft: Radius.circular(0)),
      //             image: DecorationImage(
      //               fit: BoxFit.fill,
      //               image: AssetImage(imageLinks[index]),
      //             ),
      //           ),
      //         ),
      //         Container(
      //           height: 100,
      //           child: Padding(
      //             padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: <Widget>[
      //                 Text(
      //                   headerText[index],
      //                 ),
      //                 Padding(
      //                   padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
      //                   child: Container(
      //                     width: 30,
      //                     decoration: BoxDecoration(
      //                         border: Border.all(color: Colors.teal),
      //                         borderRadius:
      //                             BorderRadius.all(Radius.circular(10))),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
      //                   child: Container(
      //                     width: 200,
      //                     child: new LinearPercentIndicator(
      //                       width: 140.0,
      //                       lineHeight: 14.0,
      //                       percent: 0.5,
      //                       backgroundColor: Colors.grey,
      //                       progressColor: Colors.blue,
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
