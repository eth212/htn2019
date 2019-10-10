import 'package:flutter/material.dart';
import 'package:squat/routes/googleLoginDebugging.dart';
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
                  child: Text('ProForm',
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
                padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                child: MainLoginButton(),
              ),
               Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                child: LogoutButton(),
              ),
            ],
          )),
    );
  }
}
