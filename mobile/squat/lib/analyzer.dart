import 'package:camera/camera.dart';
//This class is designed to allow for analysis to be independent of workout, allowing for one "Route" to be 
//designed for recording and processing.
abstract class Analyzer{
Map<String,dynamic> imagePreprocess(CameraImage image);
Map<String,dynamic> imageProcess(Map<String,dynamic> imageVals);
Map<String,dynamic> genProcessor(List<Map<String,dynamic>> outputs);
}