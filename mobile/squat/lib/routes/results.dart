import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:squat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squat/routes/workout_record.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage(
      {Key key,
      this.title,
      this.shoulderHipValue,
      this.hipKneeValue,
      this.kneeAnkleValue})
      : super(key: key);
  final String title;
  final dynamic shoulderHipValue;
  final dynamic hipKneeValue;
  final dynamic kneeAnkleValue;

  @override
  ResultsPagestate createState() {
    // shoulderHipValue,hipKneeValue,kneeAnkleValue
    return ResultsPagestate();
  }
}

class ResultsPagestate extends State<ResultsPage> {
  dynamic sHip = 0;
  dynamic hKnee = 0;
  dynamic kAnkle = 0;
  @override
  void initState() {
    super.initState();
    sHip = widget.shoulderHipValue;
    hKnee = widget.hipKneeValue;
    kAnkle = widget.kneeAnkleValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
            centerTitle: true,
            title: new Text('ProForm',
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
  ResultsList(
      {Key key,
      this.title,
      this.shoulderHipValue,
      this.hipKneeValue,
      this.kneeAnkleValue})
      : super(key: key);
  final String title;
  final dynamic shoulderHipValue;
  final dynamic hipKneeValue;
  final dynamic kneeAnkleValue;
  ResultsListState createState() => ResultsListState();
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
  final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
  final double itemWidth = size.width / 2;
  double sHip = 0;
  double hKnee = 0;
  double kAnkle = 0;
  @override
  void initState() {
    super.initState();
    sHip = widget.shoulderHipValue;
    hKnee = widget.hipKneeValue;
    kAnkle = widget.kneeAnkleValue;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    dynamic itemHeight = (size.height - kToolbarHeight - 24) / 2;
    dynamic itemWidth = size.width / 2;
    dynamic values = [sHip, hKnee, kAnkle];
    dynamic hipInsight = '',
        kneeInsight = '',
        ankleInsight = '',
        fullInsight = '';
    if (sHip > 0.4) {
      hipInsight = 'Try and drop your shoulders down slightly more';
    }
    if (hKnee > 0.4) kneeInsight = 'Stick your butt out!';

    if (kAnkle > 0.4)
      ankleInsight = 'Remember to bend your knees but never past your feet :)';
    if (sHip < 0.4 && hKnee < 0.4 && kAnkle < 0.4)
      fullInsight = 'All your metrics were near-perfect. Great job!';
    else {
      fullInsight = hipInsight + '\n' + kneeInsight + '\n' + ankleInsight;
    }
    print("STUFF:" +
        sHip.toString() +
        " " +
        hKnee.toString() +
        " " +
        kAnkle.toString());
    return Column(
      children: <Widget>[
        Text(sHip.toString()),
        Text(hKnee.toString()),
        Text(kAnkle.toString()),
      ],
    );
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
            fullInsight,
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
// shoulderHipValue,hipKneeValue,kneeAnkleValue
    final headerText = [
      'Shoulder-Hip',
      'Hip-Knee',
      'Knee-Ankle',
      // 'Breadth',
      // 'Shoulder Inflection'
    ];
    dynamic values = [sHip, hKnee, kAnkle];
    dynamic hipInsight = '',
        kneeInsight = '',
        ankleInsight = '',
        fullInsight = '';
    if (sHip > 0.4) {
      hipInsight = 'Try and drop your shoulders down slightly more';
    }
    if (hKnee > 0.4) kneeInsight = 'Stick your butt out!';

    if (kAnkle > 0.4)
      ankleInsight = 'Remember to bend your knees but never past your feet :)';
    if (sHip < 0.4 && hKnee < 0.4 && kAnkle < 0.4)
      fullInsight = 'All your metrics were near-perfect. Great job!';
    else {
      fullInsight = hipInsight + '\n' + kneeInsight + '\n' + ankleInsight;
    }

    for (int i = 0; i < values.length; i++) {
      // values[i] = values[i]*50 + 50;
      values[i] = values[i] * 50;
    }

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
