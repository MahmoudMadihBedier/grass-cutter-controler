import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        backgroundColor: Colors.deepOrange.shade900,
        splashIconSize: 200,
        splashTransition:SplashTransition.scaleTransition ,
        splash:'assets/images/car.png'
           ,
        nextScreen:homepage() ,),
    );
  }
}
class homepage  extends StatelessWidget {
  const homepage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

