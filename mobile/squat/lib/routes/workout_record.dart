import 'package:flutter/material.dart';
import 'package:squat/analyzers/factory.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:squat/camera.dart';
import 'package:squat/routes/workout_analyze.dart';
import 'package:squat/analyzers/analyzer.dart';
import 'package:squat/processor/processor.dart';
import 'package:progress_indicators/progress_indicators.dart';

class WorkoutRecordPage extends StatefulWidget {
  WorkoutRecordPage(
      {Key key,
      @required this.title,
      @required this.side,
      @required this.initialWorkout})
      : super(key: key);
  final String title;
  final bool side;
  final int initialWorkout;
  @override
  _WorkoutRecordPageState createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  int interactCounter = 0;
  String message = "Start";
  int workout;
  int state;

  static const int PRERECORDING = 0;
  static const int RECORDING = 1;
  static const int POSTRECORDING = 2;
  static const int IMAGE_PROCESSING = 3;
  static const int POSE_PROCESSING = 4;
  static const int KIN_PROCESSING = 5;
  List<CameraImage> collectedImages;
  List<dynamic> poseData;
  Analyzer analyzer;
  Processor processor;
  List<CameraDescription> cameras;
  Widget overlay;
  @override
  initState() {
    super.initState();
    workout = widget.initialWorkout;
    state = 0;
    cameras = null;
    setAnalyzer(workout);
    getCameras();
  }

  setAnalyzer(int workout) {
    collectedImages = List();
    analyzer = AnalyzerFactory.getAnalyzer(workout);
  }

  void alertComplete() {
    if (state == POSTRECORDING) {
      collectedImages = processor.getUnprocessed();
      poseData = processor.getProcessed();
      processor.kill();
      setState(() {});
    }
  }

  void getCameras() async {
    try {
      dynamic camerasNow = await availableCameras();
      setState(() {
        cameras = camerasNow;
      });
    } on CameraException catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay;
    if (state == PRERECORDING || state == RECORDING) {
      overlay = FloatingActionButton.extended(
        elevation: 0,
        label: Text(message + " Workout",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15)),
        onPressed: interact,
      );
    } else {
      overlay =
          Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Card(),
        Card(
          margin: EdgeInsets.all(8),
          child: JumpingDotsProgressIndicator(
            fontSize: 80.0,
          ),
        ),
      ]);
    }
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
            centerTitle: true,
            title: new Text(
              'ProForm',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 45),
            ),
            backgroundColor: SquatApp().squatPrimary),
      ),
      body: cameras == null && state != PRERECORDING && state != POSTRECORDING
          ? noCameraWidget()
          : Stack(
              children: <Widget>[
                Camera(cameras, POSENET, addImage, state == RECORDING),
                overlay,
              ],
            ),
    );
  }

  void interact() {
    interactCounter += 1;
    print("Number of interactions: " + interactCounter.toString());
    if (state == RECORDING) {
      setState(() {
        state = POSTRECORDING;
        message = "Done";
      });
    } else if (state == PRERECORDING) {
      buildProcessor();
      setState(() {
        state = RECORDING;
        message = "Stop";
      });
    }
  }

  void buildProcessor() async {
    if (processor == null) {
      processor = Processor(workout, alertComplete);
      processor.start();
    } else {}
  }

  Widget noCameraWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white60, const Color(0xff6A8ADB)]),
      ),
      child: Center(
        child: Text("No Camera Available"),
      ),
    );
  }

  void toAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutAnalyzePage(
            title: "ProForm", images: collectedImages, side: widget.side),
      ),
    );
  }

  //Callback for camera or reading from file, break file into images.
  addImage(CameraImage img) {
    processor.feed(img);
  }
}
