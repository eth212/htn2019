import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'authenticator.dart';
import '../routes/workout_selection.dart';


class GoogleLogInPage extends StatelessWidget{ //debugging page that displays info for google logging in and out
  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), child: AppBar(
          centerTitle: true,
          title: new Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 45)),
          backgroundColor: SquatApp().squatPrimary
        )),
      body: Container(
        child: Center(
          child: Container(
            width:300,
            height:200,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LogoutButton(),
                MainLoginButton(),
                UserProfile()
                ],
            ),
          ),
        ),
      )
    );
  }
}

class UserProfile extends StatefulWidget {
  
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  initState(){
    super.initState();
    authService.profile
      .listen((state) => setState(() => _profile = state));

    authService.loading
      .listen((state) => setState(() => _loading = state));
  }

    @override
    Widget build(BuildContext context){
      return Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Text(_profile.toString()), color: Colors.red,
        ),
        Text(_loading.toString())
      ]);
    }
  }


  class LogoutButton extends StatelessWidget {

    @override 
    Widget build(BuildContext context) {
      return StreamBuilder(
        stream: authService.user, 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.5))),
                  elevation: 5.0,
                  minWidth: 164.0,
                  height: 50,
                  color: Color(0xff6A8ADB),
                  child: new Text('Sign out',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  onPressed: () => authService.signOut(),
                );
          }
          else{// hide if user is not signed in yet
            return new Container();
          }
        }
      );
    }
  }

  class MainLoginButton extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user, 
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.5))),
                  elevation: 5.0,
                  minWidth: 164.0,
                  height: 50,
                  color: Color(0xff6A8ADB),
                  child: new Text('Login With Google',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  onPressed: () => authService.signInWithGoogle(),
                    );
                  
        }
        else {
          return  MaterialButton
              (
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.5))),
                  elevation: 5.0,
                  minWidth: 164.0,
                  height: 50,
                  color: Color(0xff6A8ADB),
                  child: new Text('Press here to get YOKED',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutSelectionPage()
                      ),
                    );
                  },);
        }
      }
    );
  }
}
