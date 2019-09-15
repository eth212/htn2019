import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;

typedef void ImageCallback(CameraImage img);
const POSENET = 0;

class Camera extends StatefulWidget {
  final ImageCallback addImage;
  final int model;
  final bool isDetecting;
  final List<CameraDescription> cameras;

  Camera(this.cameras, this.model, this.addImage, this.isDetecting);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found, this is an error.');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.low,
        enableAudio: false,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (widget.isDetecting) {
            widget.addImage(img);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Center(child: Container());
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
