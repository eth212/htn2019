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
    outputs["shoulder_hip_value"] = tanh((70 - imageVals["min_theta_1"]) / 8.13);
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
    double theta_1, theta_2, theta_3;
    double knee_x,
        knee_y,
        hip_x,
        hip_y,
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

      if (part == "leftHip") {
        leftHip_x = element['x'];
        leftHip_y = element['y'];
      }
      if (part == "rightHip") {
        rightHip_x = element['x'];
        rightHip_y = element['y'];
      }
      if (part == "leftKnee") {
        leftKnee_x = element['x'];
        leftKnee_y = element['y'];
      }
      if (part == "rightKnee") {
        rightKnee_x = element['x'];
        rightKnee_y = element['y'];
      }
      if (part == "leftShoulder") {
        leftShoulder_x = element['x'];
        leftShoulder_y = element['y'];
      }
      if (part == "rightShoulder") {
        rightShoulder_x = element['x'];
        rightShoulder_y = element['y'];
      }
      if (part == "leftAnkle") {
        leftAnkle_x = element['x'];
        leftAnkle_y = element['y'];
      }
      if (part == "rightAnkle") {
        rightAnkle_x = element['x'];
        rightAnkle_y = element['y'];
      }
    }
    if (leftHip_x == null ||
        leftKnee_x == null ||
        leftShoulder_x == null ||
        leftAnkle_x == null ||
        rightHip_x == null ||
        rightKnee_x == null ||
        rightShoulder_x == null ||
        rightAnkle_x == null) {
      return {};
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

    if (side) {
      //left side
      shoulder_x = leftShoulder_x;
      shoulder_y = leftShoulder_y;
      hip_x = rightHip_x;
      hip_y = rightHip_y;
      theta_1 = atan((hip_x - shoulder_x) / (hip_y - shoulder_y));
      theta_2 = atan((knee_y - hip_y) / (hip_x - knee_y));
      theta_3 = atan((knee_x - ankle_x) / (knee_y - ankle_y));
    } else {
      //right side
      shoulder_x = rightShoulder_x;
      shoulder_y = rightShoulder_y;
      hip_x = leftHip_x;
      hip_y = leftHip_y;
      theta_1 = atan((shoulder_x - hip_x) / (hip_y - shoulder_y));
      theta_2 = atan((knee_x - hip_x) / (knee_y - hip_y));
      theta_3 = (90 - atan((knee_x - ankle_x) / (ankle_y - knee_y)));
    }
    return {
      "shoulder_x": shoulder_x,
      "shoulder_y": shoulder_y,
      "hip_x": hip_x,
      "hip_y": hip_y,
      "theta_1": theta_1,
      "theta_2": theta_2,
      "theta_3": theta_3,
    };
  }
}
