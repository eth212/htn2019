import 'package:flutter/material.dart';
import 'package:squat/routes/workout_selection.dart';
import 'routes/home.dart';
import 'routes/results.dart';

void main() => runApp(SquatApp());

class SquatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squat',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: WorkoutSelectionPage(title: 'JUMPY'),
    );
  }
  final squatPrimary = const Color(0xff6A8ADB);

}
