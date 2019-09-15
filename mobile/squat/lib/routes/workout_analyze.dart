import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:async';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'dart:isolate';

class WorkoutAnalyzePage extends StatefulWidget {
  WorkoutAnalyzePage({Key key, this.title, this.images}) : super(key: key);
  final String title;
  final List<CameraImage> images;
  @override
  _WorkoutAnalyzePageState createState() => _WorkoutAnalyzePageState();
}

class _WorkoutAnalyzePageState extends State<WorkoutAnalyzePage> {
  List<dynamic> _recognitions;
  bool isRecognizing = false;
  String initialOutput = "Output not computed.";
  @override
  initState() {
    super.initState();
    _recognitions = List();
    isRecognizing = false;
    process(widget.images);
  }

  void process(List<CameraImage> images) async {
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
