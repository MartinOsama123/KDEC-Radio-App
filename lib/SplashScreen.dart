import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:church_app/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('images/logo.jpg'),
      nextScreen: MyHomePage(),
      splashTransition: SplashTransition.rotationTransition,
     pageTransitionType: PageTransitionType.fade,
    );
  }

}