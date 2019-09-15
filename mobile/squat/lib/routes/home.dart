import 'package:flutter/material.dart';
import 'workout_selection.dart';
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
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, const Color(0xff6A8ADB)]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/splash.png'),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 410 / 274,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text('JUMPY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w300,
                          height: 1,
                          fontSize: 48)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text('A calmer personal trainer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w300,
                        height: 1,
                        fontSize: 30)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.5))),
                  elevation: 5.0,
                  minWidth: 164.0,
                  height: 50,
                  color: Color(0xff6A8ADB),
                  child: new Text('Login',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.5))),
                  elevation: 5.0,
                  minWidth: 164.0,
                  height: 50,
                  color: Color(0xff6A8ADB),
                  child: new Text('Login',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutSelectionPage(
                          title: "JUMPY",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
