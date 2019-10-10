import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squat/main.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginPage>{
  String _email, _password;

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
                TextField(
                  decoration: InputDecoration.collapsed(hintText: "Email",border: UnderlineInputBorder()),
                  onChanged: (value){
                    this.setState((){_email = value;});
                  },
                ),
                TextField(
                  decoration: InputDecoration.collapsed(hintText: "Password",border: UnderlineInputBorder()),
                  obscureText: true,
                  onChanged: (value){
                    this.setState((){_password = value;});
                  },
                ),
                RaisedButton(child: Text("Sign In"),onPressed: (){
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((onValue){
                  }).catchError((error){
                    debugPrint("Error: " +error);
                  });
                })
              ],
            ),
          ),
        ),
      )
    );
  }
}