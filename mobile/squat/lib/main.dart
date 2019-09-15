import 'package:flutter/material.dart';
import 'package:squat/routes/cameracalibration.dart';
import 'package:squat/routes/login.dart';
import 'package:squat/routes/workout_selection.dart';
import 'routes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(SquatApp());

class SquatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squat',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: CameraCalibration(),
    );
  }
  final squatPrimary = const Color(0xff6A8ADB);

}
