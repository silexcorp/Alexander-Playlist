
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:silexcorp/source/utils/statewidget.dart';
import 'package:silexcorp/source/widgets/googlesigninbutton.dart';
import 'package:silexcorp/utilities/global.dart' as globals;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();
  String _animation = "grabar";
  String _pass, _mail;


  bool isOffline = false;
  var subscription;

  @override
  initState() {
    super.initState();
  }

  Future verifyConnectivity() async {
    try{
      final result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        print('connected');
        isOffline = true;
      }
    }on SocketException catch (_){
      print('not connected');
      isOffline = false;
    }
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }



  void submit() {
    // First validate form.
    if(this._formKey.currentState.validate()){
      _formKey.currentState.save(); // Save our form now.

      print('Printing the login data.');
      print('Email: ${_data.email}');
      print('Password: ${_data.password}');
    }
  }

  final decorationEmail = InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    hintText: 'you@example.com',
    contentPadding: EdgeInsets.all(20.0),
    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),),
  );

  final decorationPass = InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    hintText: 'Password',
    contentPadding: EdgeInsets.all(20.0),
    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18.0), bottomRight: Radius.circular(18.0)),),
    suffixIcon: IconButton(icon: Icon(Icons.visibility), onPressed: () {}),
  );

  /*
  * final decorationPass = InputDecoration(
    //counterText: "100",
    filled: true,
    fillColor: Colors.grey[200],
    hintText: 'Password',
    contentPadding: EdgeInsets.all(20.0),
    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18.0)),),
    suffixIcon: IconButton(icon: Icon(Icons.visibility), onPressed: () {}),
  );
  * */

  @override
  Widget build(BuildContext context) {

    final key = new GlobalKey<ScaffoldState>();


    return Scaffold(
      key: key,
      backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
      body: Container(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      // Box decoration takes a gradient
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        stops: [0.0, 1.0],
                        colors: [
                          Color.fromRGBO(170, 207, 211, 1.0),
                          Color.fromRGBO(93, 142, 155, 1.0),
                        ],
                      ),
                    ),
                  )),


              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[

                    Container(
                      height: 40.0,
                      margin: new EdgeInsets.all(20.0),
                      child: GoogleSignInButton(
                        onPressed: (){
                          verifyConnectivity();
                          if(isOffline){
                            StateWidget.of(context).signInWithGoogle();
                          }else{
                            key.currentState.showSnackBar(new SnackBar(
                              content: new Text("No internet connection :("),
                            ));
                          }

                        },
                      ),
                    ),

                  ],
                ),
              )


            ],
          )),
    );

  }
}