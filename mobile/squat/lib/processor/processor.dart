import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:squat/analyzers/analyzer.dart';
import 'package:squat/analyzers/factory.dart';
import 'package:squat/utils/isolate.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'dart:isolate';

// Generates Slave Isolates to perform certain analysis on
// A separate thread, such that UI is unblocked, and analysis
// may be done in real time during recording.
class Processor {
  int _workout;
  bool _isInitialized;
  FlutterIsolate _isolate;
  Function _alertComplete;
  SendPort _sendPort;
  Queue<CameraImage> _unprocessed; //Handles data in an imageQueue
  CameraImage _processing;
  List<dynamic> _processed;
  int totalFed;
  int totalProcessed;
  Processor(int workout, Function alertComplete) {
    _isolate = null;
    _workout = workout;
    _unprocessed = Queue();
    _processed = List();
    _processing = null;
    _isInitialized = false;
    totalFed = 0;
    totalProcessed = 0;
    _alertComplete = alertComplete;
  }

  int numUnprocessed() {
    return _unprocessed.length;
  }

  bool isProcessing() {
    return _unprocessed.isNotEmpty && _processing == null;
  }

  bool isNotProcessing() {
    return _unprocessed.isNotEmpty && _processing == null;
  }

  void start() {
    //Ensure safe to start isolate.
    if (_isInitialized || _isolate != null) {
      Exception(["Start called on an already started Processor!"]);
    }
    _start();
    _isInitialized = true;
    if (totalFed != totalProcessed) {
      _process();
    }
    //process call is safe, so call just in case.
  }

  void feedMultiple(List<CameraImage> images) {
    if (_isInitialized) {
      totalFed += images.length;
      _unprocessed.addAll(images);
      if (isNotProcessing()) {
        _process();
      }
    } else {
      throw Exception("Called feed before Processor was initialized!");
    }
  }

  void feed(CameraImage image) {
    if (_isInitialized) {
      totalFed += 1;
      _unprocessed.add(image);
      if (isNotProcessing()) {
        _process();
      }
    } else {
      throw Exception("Called feed before Processor was initialized!");
    }
  }

  void kill() {
    if (_isolate == null) {
      throw Exception(["Processor isn't yet started!"]);
    }
    _isolate.kill();
    _isolate = null;
  }

  void _start() {
    if (_isolate == null) {
      _loadModel();
      _buildIsolate();
    } else {
      throw Exception(["Processor already started!"]);
    }
  }

  void _loadModel() async {
    await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  }

  void _buildIsolate() async {
    ReceivePort receivePort = ReceivePort();
    _isolate =
        await FlutterIsolate.spawn(processPoseFromImage, receivePort.sendPort);
    //Get the port to send data to isolate
    _sendPort = await receivePort.first;
    //Give isolate initial workout data for setup
    if (!await sendReceive(_sendPort, _workout)) {
      throw Exception("Initial Communication with isolate Failed!");
    }
  }

  void _process() async {
    while (_unprocessed.isNotEmpty) {
      _processing = _unprocessed.removeFirst();
      int currentImage = totalFed - totalProcessed;
      print("Processing image: " + currentImage.toString());
      var msg = await sendReceive(
        _sendPort,
        [
          _processing.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          _processing.height,
          _processing.width
        ],
      );
      print("Processed image: "+  currentImage.toString());
      _processed.add([msg, _processing]);
      _processing = null;
      totalProcessed += 1;
    }
    _alertComplete();
  }
}

//Entrypoint for slave isolate, will process however it is told.
void processPoseFromImage(dynamic sendPort) async {
  ReceivePort port = new ReceivePort();
  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);
  Analyzer analyzer;
  int workout = -1;
  bool hasInitialized = false;
  await for (dynamic msg in port) {
    if (hasInitialized) {
      if (msg[0] != null) {
        var img = msg[0];
        SendPort replyTo = msg[1];
        dynamic formattedData = analyzer.imageProcess(img);
        replyTo.send(formattedData);
      } else
        port.close();
    } else {
      workout = msg[0];
      SendPort replyTo = msg[1];
      analyzer = AnalyzerFactory.getAnalyzer(workout);
      replyTo.send(true);
    }
  }
}
