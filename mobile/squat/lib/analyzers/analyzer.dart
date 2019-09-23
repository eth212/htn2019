import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import '../utils/math.dart';

//This class is designed to allow for analysis to be independent of workout, allowing for one "Route" to be
//designed for recording and processing.
abstract class Analyzer {
  static const int TYPE_SQUAT = 0;
  static const int TYPE_PUSHUP = 0;
  int type;
  //Convert image to primitive datatype.
  List<dynamic> imagePreprocess(CameraImage image) {
    return [
      image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      image.height,
      image.width
    ];
  }

  Future<List<dynamic>> imageProcess(
      List<dynamic> image); // Output points of pose
  Map<String, dynamic> postProcess(
      Map<String, dynamic> posePoints); // Process a given pose
  Map<String, dynamic> processPose(
      List<dynamic> imageVals); // Process a chain of pose data
}

class SquatAnalyzer extends Analyzer {
  SquatAnalyzer() {
    type = Analyzer.TYPE_SQUAT;
  }

  @override
  Future<List<dynamic>> imageProcess(List<dynamic> image) {
    return Tflite.runPoseNetOnFrame(
      bytesList: image[0],
      imageHeight: image[1],
      imageWidth: image[2],
      numResults: 2,
    );
  }

//TODO: add postprocess properly.
  @override
  Map<String, dynamic> postProcess(Map<String, dynamic> imageVals) {
    Map<String, double> outputs = {};
    outputs["shoulder_hip_value"] =
        tanh((70 - imageVals["min_theta_1"]) / 8.13);
    outputs["hip_knee_value"] = tanh((12.9 - imageVals["min_theta_2"]) / 9.5);
    outputs["knee_ankle_value"] = tanh((62 - imageVals["min_theta_3"]) / 6.8);
    return outputs;
  }

  @override
  Map<String, dynamic> processPose(List<dynamic> posePoints) {
    if (posePoints == null || posePoints.length == 0) {
      return {};
    }
    bool side = posePoints[posePoints.length];
    dynamic pose = posePoints[0];
    double rightKneeY,
        leftKneeY,
        rightkneeX,
        leftkneeX,
        rightAnkleY,
        rightAnkleX,
        leftAnkleY,
        leftAnkleX;
    double rightShoulderX,
        rightShoulderY,
        leftShoulderX,
        leftShoulderY,
        rightHipX,
        rightHipY,
        leftHipX,
        leftHipY;
    double theta_1, theta_2, theta_3;
    double kneeX, kneeY, hipX, hipY, shoulderX, shoulderY, ankleX, ankleY;
    for (int i = 0; i < 14; i++) {
      dynamic element = pose[i];
      dynamic part = pose[i]['part'];
      if (element['score'] < 0.4) {
        break;
      }

      if (part == "leftHip") {
        leftHipX = element['x'];
        leftHipY = element['y'];
      }
      if (part == "rightHip") {
        rightHipX = element['x'];
        rightHipY = element['y'];
      }
      if (part == "leftKnee") {
        leftkneeX = element['x'];
        leftKneeY = element['y'];
      }
      if (part == "rightKnee") {
        rightkneeX = element['x'];
        rightKneeY = element['y'];
      }
      if (part == "leftShoulder") {
        leftShoulderX = element['x'];
        leftShoulderY = element['y'];
      }
      if (part == "rightShoulder") {
        rightShoulderX = element['x'];
        rightShoulderY = element['y'];
      }
      if (part == "leftAnkle") {
        leftAnkleX = element['x'];
        leftAnkleY = element['y'];
      }
      if (part == "rightAnkle") {
        rightAnkleX = element['x'];
        rightAnkleY = element['y'];
      }
    }
    if (leftHipX == null ||
        leftkneeX == null ||
        leftShoulderX == null ||
        leftAnkleX == null ||
        rightHipX == null ||
        rightkneeX == null ||
        rightShoulderX == null ||
        rightAnkleX == null) {
      return {};
    }
    kneeY = (leftKneeY + rightKneeY) / 2;
    kneeX = (leftkneeX + rightkneeX) / 2;

    double comparison = rightAnkleY;
    if (comparison > leftAnkleY) {
      ankleY = leftAnkleY;
      ankleX = leftAnkleX;
    } else {
      ankleY = rightAnkleY;
      ankleX = rightAnkleX;
    }

    if (side) {
      //left side
      shoulderX = leftShoulderX;
      shoulderY = leftShoulderY;
      hipX = rightHipX;
      hipY = rightHipY;
      theta_1 = atan((hipX - shoulderX) / (hipY - shoulderY));
      theta_2 = atan((kneeY - hipY) / (hipX - kneeY));
      theta_3 = atan((kneeX - ankleX) / (kneeY - ankleY));
    } else {
      //right side
      shoulderX = rightShoulderX;
      shoulderY = rightShoulderY;
      hipX = leftHipX;
      hipY = leftHipY;
      theta_1 = atan((shoulderX - hipX) / (hipY - shoulderY));
      theta_2 = atan((kneeX - hipX) / (kneeY - hipY));
      theta_3 = (90 - atan((kneeX - ankleX) / (ankleY - kneeY)));
    }
    return {
      "shoulderX": shoulderX,
      "shoulderY": shoulderY,
      "hipX": hipX,
      "hipY": hipY,
      "theta_1": theta_1,
      "theta_2": theta_2,
      "theta_3": theta_3,
    };
  }
}
