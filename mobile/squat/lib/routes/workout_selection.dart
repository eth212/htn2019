import 'package:flutter/material.dart';
import 'package:squat/main.dart';

class WorkoutSelectionPage extends StatefulWidget {
  WorkoutSelectionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar( 
        centerTitle: true,
        title: new Text('JUMPY',style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300, fontSize: 45)),
        backgroundColor: SquatApp().squatPrimary
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(color: Colors.blue,child:Text('WORKOUTS',style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300, fontSize: 45))),
                  ),
                  // Expanded(
                  //   child: Container(color: Colors.blue),
                  // )
                ],
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
