
import 'package:flutter/material.dart';
import 'package:silexcorp/source/utils/statewidget.dart';
import 'source/app.dart';
import 'package:flutter/services.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((context) {
    StateWidget stateWidget = new StateWidget(child:new MyApp());
    runApp(stateWidget);
  });
}
