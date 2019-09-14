import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(color: Colors.blue, child: Text("Kyrel Rocks")),
                ),
                Expanded(
                  child: Container(color: Colors.blue),
                )
              ],
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
