import 'package:flutter/material.dart';
import 'routes/home.dart';
import 'routes/workout_selection.dart';

void main() => runApp(SquatApp());

class SquatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squat',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
