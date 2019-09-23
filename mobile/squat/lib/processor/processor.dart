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
  ReceivePort _receivePort;
  Queue<CameraImage> _unprocessed; //Handles data in an imageQueue
  CameraImage _processing;
  List<dynamic> _processed;
  int totalProcessed;
  Processor(int workout) {
    _isolate = null;
    _workout = workout;
    _unprocessed = Queue();
    _processed = List();
    _processing = null;
    totalProcessed = 0;
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

  void runProcessor() {
    _receivePort = _start();
    _process();
  }

  void feed(CameraImage image) {
    if (_isInitialized) {
      _unprocessed.add(image);
      if (isNotProcessing()) {
        _process();
      }
    } else {
      throw Exception("Called Feed before Processor was initialized!");
    }
  }

  void _process() async {
    while (_unprocessed.isNotEmpty) {
      _processing = _unprocessed.removeFirst();
      var sendPort = await _receivePort.first;
      var msg = await sendReceive(
        sendPort,
        [
          _processing.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          _processing.height,
          _processing.width
        ],
      );
      _processed.add([msg, _processing]);
      _processing = null;
      totalProcessed += 1;
    }
  }

  ReceivePort _start() {
    if (_isolate != null) {
      _loadModel();
      return _buildIsolate();
    } else {
      throw Exception(["Processor already started!"]);
    }
  }

  void _loadModel() async {
    await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  }

  dynamic _buildIsolate() async {
    ReceivePort receivePort = ReceivePort();
    _isolate =
        await FlutterIsolate.spawn(processPoseFromImage, receivePort.sendPort);
    return receivePort;
  }

  void kill() {
    if (_isolate == null) {
      throw Exception(["Processor isn't yet started!"]);
    } else
      _isolate.kill();
  }
}

//Spawns separate isolate
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
