import 'package:flutter/material.dart';
import 'package:squat/analyzers/factory.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:squat/camera.dart';
import 'package:squat/routes/workout_analyze.dart';
import 'package:squat/analyzers/analyzer.dart';
import 'package:squat/processor/processor.dart';

class WorkoutRecordPage extends StatefulWidget {
  WorkoutRecordPage({Key key, this.title, this.side, this.initialWorkout})
      : super(key: key);
  final String title;
  final bool side;
  final int initialWorkout;
  @override
  _WorkoutRecordPageState createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  bool isRecording = false;
  String message = "Start";
  int processed;
  int workout;
  List<CameraImage> collectedImages;
  Analyzer analyzer;
  Processor processor;
  //ImageProcessor processor;
  List<CameraDescription> cameras;
  @override
  initState() {
    workout = widget.initialWorkout;
    super.initState();
    cameras = null;
    setAnalyzer(widget.initialWorkout);
    getCameras();
  }

  setAnalyzer(int workout) {
    processed = 0;
    collectedImages = List();
    analyzer = AnalyzerFactory.getAnalyzer(workout);
  }

  void alertComplete() {
    if (!isRecording) {
      processor.kill();
      //Todo: Add rest of processing here, along with a setstate to
      //the results route.
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
      body: cameras == null
          ? getInteractionWidget()
          : Stack(
              children: <Widget>[
                Camera(cameras, POSENET, addImage, isRecording),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: FloatingActionButton.extended(
                          elevation: 0,
                          // icon: const Icon(Icons.add),
                          label: Text(message + " Workout",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          onPressed: interact,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void interact() {
    if (isRecording) {
      processor.kill();
      setState(() {
        isRecording = false;
        message = "Done";
        //toAnalysis();
      });
    } else {
      // TODO: Starting indicator, maybe reorganize startup as much as possible?
      processor = Processor(workout, alertComplete);
      processor.start();
      setState(() {
        isRecording = true;
        message = "Stop";
      });
    }
  }

  Widget getInteractionWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white60, const Color(0xff6A8ADB)]),
      ),
      child: Center(
        child: Text("No Camera Found"),
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
    //collectedImages.add(img);
  }
}
