import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:church_app/Screens/LoginScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset('images/img.png'),
        splashIconSize: MediaQuery.of(context).size.height / 1.5,
        nextScreen: LoginScreen(skip: true),
        splashTransition: SplashTransition.fadeTransition,
       pageTransitionType: PageTransitionType.fade,
      );
  }

}