import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/Widgets/FloatingContainer.dart';
import 'package:church_app/main.dart';
import 'package:church_app/models/NotificationInfo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import '../AppColor.dart';
import '../BackendQueries.dart';
import '../Search.dart';
import 'DiscoverScreen.dart';
import 'LibraryScreen.dart';
import 'LoginScreen.dart';
import 'NotificationScreen.dart';
import 'OfflineScreen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _selectedName = "live";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedName = index == 0
          ? "live"
          : index == 1
          ? "browse"
          : index == 2
          ? "notifications"
          : "offline";
    });
  }

  @override
  void initState() {
    connectAudio();
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? androidNotification = event.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.black,
                    playSound: true,
                    icon: "@mipmap/ic_launcher")));
        addNotification(new NotificationInfo(
            notification.title ?? "", notification.body ?? ""));
      }
    });

    super.initState();
  }

  Future<void> addNotification(NotificationInfo n) async {
    await BackendQueries.addNotification(
        await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "",
        jsonEncode(n.toJson()));
  }

  @override
  void dispose() {
    AudioService.disconnect();
    super.dispose();
  }

  Future<void> connectAudio() async {
    await AudioService.connect();
  }
  Future<void> uploadFile() async {
   /* FilePickerResult? result = await FilePicker.platform.pickFiles();
    final key = new DateTime.now().toString();
    File local =  File( "");
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      local = file;
    } else {
      // User canceled the picker
    }*/
    try {
      ListResult res = await Amplify.Storage.list();
      for(StorageItem s in res.items){
        print(s.key);
        print(s.eTag);
        print(s.size);

      }
    } on StorageException catch (e) {
      print(e.message);
    }
    print("DONE");

   /* try {
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key,
          local: local
      );
    } on StorageException catch (e) {
      print(e.message);
    }*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: _selectedIndex == 0
              ? LiveAnimation()
              : null,
          automaticallyImplyLeading: false,
          title: Text(_selectedName,
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )).tr(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                 // showSearch(context: context, delegate: Search());
                  uploadFile();
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundColor: AppColor.SecondaryColor,
                  child: IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen())),
                      icon: Icon(Icons.person))),
            ),
          ]),
      body: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingContainer(),
          body: Center(
            child: _buildScreens().elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.circle_fill),
                label: ("live").tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_list),
                label: ("browse").tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bell),
                label: ("notifications").tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.collections),
                label: ("offline").tr(),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColor.PrimaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    print(FirebaseAuth.instance.currentUser?.getIdToken(true));
    return [
      LibraryScreen(),
      DiscoverScreen(),
      NotificationScreen(),
      OfflineScreen(),
    ];
  }
}

class LiveAnimation extends StatefulWidget {
  const LiveAnimation({
    Key? key,
  }) :  super(key: key);


  @override
  _LiveAnimationState createState() => _LiveAnimationState();
}

class _LiveAnimationState extends State<LiveAnimation> with TickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
    opacity: _controller,
    child: Icon(
      CupertinoIcons.circle_fill,
      color: Colors.red,
      size: 13,
    ));
  }

}