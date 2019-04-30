import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:silexcorp/source/utils/state.dart';
import 'package:silexcorp/source/utils/statewidget.dart';

import 'package:silexcorp/utilities/global.dart' as globals;
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  StateModel appState;
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/playlist');
  }

  @override
  void initState() {
    startTime();
    //AUIDO
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    audioCache.play(globals.audioLoading, volume: 0.5);
    super.initState();
  }

  @override
  void dispose() {
    if(audioCache != null){
      advancedPlayer.release();
      audioCache.clearCache();
    }
    super.dispose();
  }

  Future<Null> _getPath(BuildContext context) async {
    Directory appDocDir = await getApplicationDocumentsDirectory(); //getTemporaryDirectory();
    final myDir = new Directory(appDocDir.path + '/audio/');
    myDir.exists().then((isThere) {
      isThere ?
      print('###### exists')
          :
      new Directory(appDocDir.path + '/audio/').create(recursive: true)
          .then((Directory directory) {
            print(directory.path);
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;
    _getPath(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(globals.logo, fit: BoxFit.fill,),
            ],
          ),
        ],
      ),
    );
  }
}
