import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class WorkoutAnalyzePage extends StatefulWidget {
  WorkoutAnalyzePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WorkoutAnalyzePageState createState() => _WorkoutAnalyzePageState();
}

class _WorkoutAnalyzePageState extends State<WorkoutAnalyzePage> {
  List<CameraDescription> cameras;
  int selectedCameraIdx;
  void initState() {
    super.initState();

    // Get the list of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
