import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:squat/camera.dart';

class WorkoutAnalyzePage extends StatefulWidget {
  WorkoutAnalyzePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WorkoutAnalyzePageState createState() => _WorkoutAnalyzePageState();
}

class _WorkoutAnalyzePageState extends State<WorkoutAnalyzePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int _model = POSENET;
  bool isRecording = false;
  String message = "Start";
  List<CameraImage> collectedImages;
  List<CameraDescription> cameras;
  @override
  initState() {
    cameras = null;
    _recognitions = List();
    collectedImages = List();

    getCameras();
  }

  Future<Null> getCameras() async {
    try {
      dynamic camerasNow = await availableCameras();
      setState(() {cameras = camerasNow;});
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
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      RaisedButton(
                        child: Text("${message} Recording"),
                        onPressed: interact,
                      ),
                      Spacer(),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void interact() {
    setState(() {
      if(isRecording){
        isRecording = false;
        message = "Start";
      }
      else{
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

  void processPoseFromImage(CameraImage img) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    await Tflite.runPoseNetOnFrame(
      bytesList: img.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: img.height,
      imageWidth: img.width,
      numResults: 2,
    ).then((recognitions) {
      int endTime = new DateTime.now().millisecondsSinceEpoch;
      print("Detection took ${(endTime - startTime) / 1000}");
      setRecognitions(recognitions, img.height, img.width);
    });
  }

  //Callback for camera or reading from file, break file into images.
  addImage(CameraImage img) {
    collectedImages.add(img);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }
}
