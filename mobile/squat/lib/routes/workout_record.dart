import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:squat/camera.dart';
import 'package:squat/routes/workout_analyze.dart';
class WorkoutRecordPage extends StatefulWidget {
  WorkoutRecordPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WorkoutRecordPageState createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  bool isRecording = false;
  String message = "Start";
  List<CameraImage> collectedImages;

  List<CameraDescription> cameras;
  @override
  initState() {
    super.initState();
    cameras = null;
    collectedImages = List();
    getCameras();
  }

  Future<Null> getCameras() async {
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
              'JUMPY',
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
                    children: <Widget>[
                      RaisedButton(
                        child: Text(message + "Recording"),
                        onPressed: interact,
                      ),
                      Container(child: Text(collectedImages.length.toString())),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void interact() {
    setState(() {
      if (isRecording) {
        isRecording = false;
        message = "Done";
        toAnalysis();
      } else {
        isRecording = true;
        message = "Stop";
      }
    });
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
        builder: (context) => WorkoutAnalyzePage(),
      ),
    );
  }

  //Callback for camera or reading from file, break file into images.
  addImage(CameraImage img) {
    collectedImages.add(img);
  }
}
