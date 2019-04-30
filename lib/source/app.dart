import 'package:flutter/material.dart';
import 'package:silexcorp/source/screens/login.dart';
import 'package:silexcorp/source/screens/playlists.dart';
import 'package:silexcorp/source/screens/splashscreen.dart';
import 'package:silexcorp/utilities/global.dart' as globals;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: globals.appName,
      theme: ThemeData.light(),
      //theme: ThemeData.dark(),
      //home: RootScreen(),
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/playlist': (context) => Playlists(),
      },
    );
  }
}
