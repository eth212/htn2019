import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squat/main.dart';

class CameraCalibration extends StatefulWidget {
  @override
  CameraCalibrationState createState() => CameraCalibrationState();
}

class CameraCalibrationState extends State<CameraCalibration> {
  String _email, _password;

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
                backgroundColor: SquatApp().squatPrimary)),
        // floatingActionButton: FloatingActionButton.extended(
        //   elevation: 0,
        //   // icon: const Icon(Icons.add),
        //   label: const Text('Workout',
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.w500,
        //           fontSize: 15)),
        //   onPressed: fastForward,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: CalibrationDecision(),
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
            color: SquatApp().squatPrimary));
  }
}

class CalibrationDecision extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CalibrationDecisionState();
  }
}

class CalibrationDecisionState extends State<CalibrationDecision> {
  static var size = Size(0, 0);

  /*24 is for notification bar on Android*/
  static double itemHeight = (size.height - kToolbarHeight - 24) / 2;
  static double itemWidth = size.width / 2;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    return Column(
      children: [
        Row(
          children: [Text('hi')],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5))),
                        elevation: 5.0,
                        minWidth: 164.0,
                        height: 50,
                        color: Color(0xff6A8ADB),
                        child: new Text('LEFT',
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  color: Color(0xff2D556B),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5))),
                        elevation: 5.0,
                        minWidth: 164.0,
                        height: 50,
                        color: Color(0xff6A8ADB),
                        child: new Text('RIGHT',
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  color: Color(0xff9B4D4D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
