import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Basic AppBar'),
        ),
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white60, const Color(0xff6A8ADB)]),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(color: Colors.blue),
              ),
              Spacer(flex: 2),
            ],
          )),
    );
  }
}
