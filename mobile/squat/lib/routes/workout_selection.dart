import 'package:flutter/material.dart';
import 'package:squat/main.dart';

class WorkoutSelectionPage extends StatefulWidget {
  WorkoutSelectionPage({
    Key key,
    this.title
  }): super(key: key);
  final String title;
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State < WorkoutSelectionPage > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), child: AppBar(
          centerTitle: true,
          title: new Text('JUMPY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 45)),
          backgroundColor: SquatApp().squatPrimary
        )),
      body: Center(
        child: Column(

          // mainAxisAlignment: MainAxisAlignment.center,
          children: < Widget > [
            Row(
              children: < Widget > [
                Expanded(
                  child: Container(color: Color(0xff272727), child: Padding(padding: EdgeInsets.all(10), child: Text('WORKOUTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 28)))),
                ),
                Expanded(
                   child: Container(color: Colors.blue),
                )
              ],
            )
          ],
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}