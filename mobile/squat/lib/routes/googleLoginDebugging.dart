import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import '../utils/authenticator.dart';


class GoogleLogInPage extends StatelessWidget{
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
                LoginButton(),
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


  class LoginButton extends StatelessWidget {

    @override 
    Widget build(BuildContext context) {
      return StreamBuilder(
        stream: authService.user, 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return MaterialButton(
                  onPressed: () => authService.signOut(),
                  color: Colors.red,
                  textColor: Colors.black,
                  child: Text('logout'),
                );
          }
          else {
            return  MaterialButton
                (onPressed: () => authService.signInWithGoogle(),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Sign in With Google'),
                );
          }
        }
      );
    }
  }
