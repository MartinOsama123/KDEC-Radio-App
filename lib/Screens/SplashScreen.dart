import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:audio_service/audio_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:church_app/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset('images/kdec.png'),
        splashIconSize: MediaQuery.of(context).size.height / 1.5,
        nextScreen: AudioServiceWidget(child: MyHomePage()),
        splashTransition: SplashTransition.fadeTransition,
       pageTransitionType: PageTransitionType.fade,
      );
  }

}