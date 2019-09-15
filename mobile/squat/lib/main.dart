import 'package:flutter/material.dart';
import 'package:squat/routes/login.dart';
import 'package:squat/routes/workout_selection.dart';
import 'routes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: ResultsPage(),
    );
  }
  final squatPrimary = const Color(0xff6A8ADB);

}

Widget _handleWindowDisplay(){
  return WorkoutSelectionPage();
  return StreamBuilder(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: Text("Loading"));
      } else {
        if(snapshot.hasData){
          return WorkoutSelectionPage();
        } else{
          return Login();
          } 
        }
  },);
}
