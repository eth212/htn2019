import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  static const PrimaryColor = const Color(0xff6A8ADB);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        centerTitle: true,
        title: new Text('JUMPY',style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300, fontSize: 30)),
        backgroundColor: PrimaryColor,
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
