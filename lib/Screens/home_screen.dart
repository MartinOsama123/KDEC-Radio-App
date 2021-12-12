import 'dart:convert';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/Widgets/floating_container.dart';
import 'package:church_app/models/album_info.dart';
import 'package:church_app/models/notification_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import '../app_color.dart';
import '../backend_queries.dart';
import '../page_manager.dart';
import '../search.dart';
import 'discover_screen.dart';
import 'live_screen.dart';
import 'notification_screen.dart';
import 'offline_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final IOSInitializationSettings iOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings);
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? androidNotification = event.notification?.android;
      if (notification != null) {

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    notification.hashCode.toString(), notification.title!,channelDescription: notification.body!,
                    color: Colors.black,
                    playSound: true,
                    icon: "@mipmap/ic_launcher"),iOS: IOSNotificationDetails()));
        addNotification(new NotificationInfo(
            notification.title ?? "", notification.body ?? ""));
      }
    });
    print("CALL");

    initDynamicLinks();
    super.initState();
    getIt<PageManager>().init();
  }
  void handleLinkData(PendingDynamicLinkData data) {
    print(data);
    final Uri? uri = data.link;
    if(uri != null) {
      final queryParams = uri.queryParameters;
      print(uri.queryParameters.entries);/*
      if(queryParams.length > 0) {
        String? userName = queryParams["username"];
        // verify the username is parsed correctly
        print("My users username is: $userName");
      }*/
    }
  }
  initDynamicLinks() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path,arguments: AlbumInfo.fromJson(deepLink.queryParameters));
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      handleLinkData(dynamicLinkData);
      Navigator.pushNamed(context, dynamicLinkData.link.path,arguments: AlbumInfo.fromJson(dynamicLinkData.link.queryParameters));
    }).onError((error) {
      // Handle errors
    });
  }

  Future<void> addNotification(NotificationInfo n) async {
    await BackendQueries.addNotification(
        await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "",
        jsonEncode(n.toJson()));
  }
  Future<dynamic> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }


 /* @override
  void dispose() {
    print("dispose");
    getIt<PageManager>().stop();
  //  getIt<PageManager>().dispose();
    super.dispose();
  }*/





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
                 showSearch(context: context, delegate: Search());},
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundColor: AppColor.SecondaryColor,
                  child: IconButton(
                      onPressed: () => Navigator.pushNamed(context, "/login"),
                      icon: Icon(Icons.person,color: Colors.white,))),
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
      LiveScreen(),
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