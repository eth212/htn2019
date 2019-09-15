import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class WorkoutAnalyzePage extends StatefulWidget {
  WorkoutAnalyzePage({Key key, this.title, this.images}) : super(key: key);
  final String title;
  final List<CameraImage> images;
  @override
  _WorkoutAnalyzePageState createState() => _WorkoutAnalyzePageState();
}

class _WorkoutAnalyzePageState extends State<WorkoutAnalyzePage> {
  List<dynamic> _recognitions;
  bool isRecording = false;
  String output = "Output not computed.";
  List<CameraImage> collectedImages;

  List<CameraDescription> cameras;
  @override
  initState() {
    super.initState();
    cameras = null;
    _recognitions = List();
    //process();
  }
  process(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
            centerTitle: true,
            title: new Text(
              'JUMPY ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 45),
            ),
            backgroundColor: SquatApp().squatPrimary),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white70, const Color(0xff6A8ADB)]),
        ),
        child: Center(
            child: Column(
          children: <Widget>[
            Spacer(),
            Text("Please rest"),
            Text("Output  not computed"),
            Spacer(),
          ],
        )),
      ),
    );
  }
}
