import 'package:audio_service/audio_service.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/LibraryScreen.dart';
import 'package:church_app/NewScreen.dart';
import 'package:church_app/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'AudioPlayerTask.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final language = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: AppColor.PrimaryColor,
          accentColor: AppColor.SecondaryColor,
          fontFamily: language ? 'GESSTwo' : 'ABEAKRG'),
      home: AudioServiceWidget(child: SplashScreen()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _buildScreens().elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_bullet),
              label: ("Library"),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.mic),
              label: ("New"),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: ("Profile"),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColor.PrimaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      LibraryScreen(),
      NewScreen(),
      Container(),
    ];
  }
}
