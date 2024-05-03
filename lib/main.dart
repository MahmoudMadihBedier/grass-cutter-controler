import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'initialScreen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: AnimatedSplashScreen(
        backgroundColor: Colors.deepOrange.shade900,
        splashIconSize: 200,
        splashTransition:SplashTransition.scaleTransition ,
        splash:'assets/images/car.png'
           ,
        nextScreen:const homepage() ,),
    );
  }
}

