import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:async';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'dart:isolate';
import 'dart:math';

class WorkoutAnalyzePage extends StatefulWidget {
  WorkoutAnalyzePage({Key key, this.title, this.images}) : super(key: key);
  final String title;
  final List<CameraImage> images;
  @override
  _WorkoutAnalyzePageState createState() => _WorkoutAnalyzePageState();
}

class _WorkoutAnalyzePageState extends State<WorkoutAnalyzePage> {
  List<dynamic> _recognitions;
  List<dynamic> _calculations;
  bool isRecognizing = false;
  String initialOutput = "Output not computed.";
  String identifier;
  bool side;
  List calculations;

  double error_bias = 3.7377;
  double error_slope = 0.10292;
  double min_theta_1, min_theta_2, min_theta_3;
  double height;

  @override
  initState() {
    super.initState();
    _recognitions = List();
    _calculations = List();
    isRecognizing = false;
    processModelA(widget.images);
    for (dynamic pose in _recognitions) {
      modelB(pose);
    }
  }

  void processModelA(List<CameraImage> images) async {
    ReceivePort receivePort = ReceivePort();
    await FlutterIsolate.spawn(processPoseFromImage, receivePort.sendPort);
    var sendPort = await receivePort.first;
    for (CameraImage image in images) {
      var msg = await sendReceive(
        sendPort,
        [
          image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          image.height,
          image.width
        ],
      );
      _recognitions.add(msg);
    }
    await sendReceive(sendPort, null);

    print("Processed the stream!");
  }

  void modelB(pose) {
    calculations = List();
    double rightKnee_y,
        leftKnee_y,
        rightKnee_x,
        leftKnee_x,
        rightAnkle_y,
        rightAnkle_x,
        leftAnkle_y,
        leftAnkle_x;
    double rightShoulder_x,
        rightShoulder_y,
        leftShoulder_x,
        leftShoulder_y,
        rightHip_x,
        rightHip_y,
        leftHip_x,
        leftHip_y;
    double rightEar_x,
        rightEar_y,
        leftEar_x,
        leftEar_y,
        theta_1,
        theta_2,
        theta_3;
    double knee_x,
        knee_y,
        hip_x,
        hip_y,
        ear_x,
        ear_y,
        shoulder_x,
        shoulder_y,
        ankle_x,
        ankle_y;
    for (int i = 0; i < 14; i++) {
      dynamic element = pose[i];
      dynamic part = pose[i]['part'];
      if (element['score'] < 0.4) {
        break;
      }
      if (part == "leftEye") {
        leftEar_x = element['x'];
        leftEar_y = element['y'];
      } else if (identifier == "rightEye") {
        rightEar_x = element['x'];
        rightEar_y = element['y'];
      }
      if (identifier == "leftHip") {
        leftHip_x = element['x'];
        leftHip_y = element['y'];
      }
      if (identifier == "rightHip") {
        rightHip_x = element['x'];
        rightHip_y = element['y'];
      }
      if (identifier == "leftKnee") {
        leftKnee_x = element['x'];
        leftKnee_y = element['y'];
      }
      if (identifier == "rightKnee") {
        rightKnee_x = element['x'];
        rightKnee_y = element['y'];
      }
      if (identifier == "leftShoulder") {
        leftShoulder_x = element['x'];
        leftShoulder_y = element['y'];
      }
      if (identifier == "rightShoulder") {
        rightShoulder_x = element['x'];
        rightShoulder_y = element['y'];
      }
      if (identifier == "leftAnkle") {
        leftAnkle_x = element['x'];
        leftAnkle_y = element['y'];
      }
      if (identifier == "rightAnkle") {
        rightAnkle_x = element['x'];
        rightAnkle_y = element['y'];
      }
    }
    if (leftEar_x == null ||
        leftHip_x == null ||
        leftKnee_x == null ||
        leftShoulder_x == null ||
        leftAnkle_x == null ||
        rightEar_x == null ||
        rightHip_x == null ||
        rightKnee_x == null ||
        rightShoulder_x == null ||
        rightAnkle_x == null) {
      _calculations.add(null);
      return;
    }
    knee_y = (leftKnee_y + rightKnee_y) / 2;
    knee_x = (leftKnee_x + rightKnee_x) / 2;

    double comparison = rightAnkle_y;
    if (comparison > leftAnkle_y) {
      ankle_y = leftAnkle_y;
      ankle_x = leftAnkle_x;
    } else {
      ankle_y = rightAnkle_y;
      ankle_x = rightAnkle_x;
    }

    if (side == true) {
      //left side
      shoulder_x = leftShoulder_x;
      shoulder_y = leftShoulder_y;
      ear_x = leftEar_x;
      ear_y = leftEar_y;
      hip_x = rightHip_x;
      hip_y = rightHip_y;
      theta_1 = atan((hip_x - shoulder_x) / (hip_y - shoulder_y));
      theta_2 = atan((knee_y - hip_y) / (hip_x - knee_y));
      theta_3 = atan((knee_x - ankle_x) / (knee_y - ankle_y));
    }

    if (side == false) {
      //right side
      shoulder_x = rightShoulder_x;
      shoulder_y = rightShoulder_y;
      ear_x = rightEar_x;
      ear_y = rightEar_y;
      hip_x = leftHip_x;
      hip_y = leftHip_y;
      theta_1 = atan((shoulder_x - hip_x) / (hip_y - shoulder_y));
      theta_2 = atan((knee_x - hip_x) / (knee_y - hip_y));
      theta_3 = (90 - atan((knee_x - ankle_x) / (ankle_y - knee_y)));
    }

// if confidence score is low at a point, calculate potential_error which should take in the last 3 points
// when iterating through different frames, calculate potantial_error at each point

    dynamic shoulder_hip_value = tanh((70 - theta_1) / 8.13);
    dynamic hip_knee_value = tanh((12.9 - theta_2) / 9.5);
    dynamic knee_ankle_value = tanh((62 - theta_3) / 6.8);
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
              widget.title,
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
            Text(initialOutput),
            Spacer(),
          ],
        )),
      ),
    );
  }
}

processPoseFromImage(SendPort sendPort) async {
  ReceivePort port = new ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);
  await Tflite.loadModel(
      model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");

  await for (dynamic msg in port) {
    if (msg[0] != null) {
      var img = msg[0];
      SendPort replyTo = msg[1];
      dynamic formattedData = await Tflite.runPoseNetOnFrame(
        bytesList: img[0],
        imageHeight: img[1],
        imageWidth: img[2],
        numResults: 2,
      );
      replyTo.send(formattedData);
    }
    if (msg[0] == null) port.close();
  }
}

/// sends a message on a port, receives the response,
/// and returns the megit ssage
Future sendReceive(SendPort port, msg) {
  ReceivePort response = new ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}

double tanh(num x) {
  final a = exp(x), b = exp(-x);
  return a.isInfinite ? 1 : b.isInfinite ? -1 : (a - b) / (a + b);
}
