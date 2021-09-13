import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Screens/AlbumScreen.dart';
import 'package:church_app/Screens/AudioPlayerUI.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/Screens/DiscoverScreen.dart';
import 'package:church_app/Screens/LibraryScreen.dart';
import 'package:church_app/Screens/LoginScreen.dart';
import 'package:church_app/Screens/OfflineScreen.dart';
import 'package:church_app/Search.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:church_app/models/NotificationInfo.dart';
import 'package:church_app/models/UserInfo.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'Screens/MessegeScreen.dart';
import 'Screens/NotificationScreen.dart';
import 'Screens/SplashScreen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "channel", "title", "Description",
    importance: Importance.high, playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("a bg message just showed up ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  await FirebaseMessaging.instance.subscribeToTopic("Global");


  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR'), Locale('ar', 'AR')],
        path: 'assets/translation', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()
    ),
  );
}


class MyApp extends StatelessWidget {
  final language = false;
  @override
  Widget build(BuildContext context) {
context.locale = Locale("ar","AR");
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(email: "", name: "", phone: "", subs: [], notifications: []),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirebaseAuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        onGenerateRoute: (settings) {
          // Handle '/'
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => MyHomePage());
          }

          // Handle '/details/:id'
          var uri = Uri.parse(settings.name ?? "");
          if (uri.pathSegments.first == 'album') {
            var id = uri.pathSegments[1];
            var path = uri.pathSegments[2];
            return MaterialPageRoute(
                builder: (context) => AlbumScreen(
                    albumInfo: new AlbumInfo(albumName: id, imgPath: path)));
          }
        },
        theme: ThemeData(
            primaryColor: AppColor.PrimaryColor,
            accentColor: AppColor.SecondaryColor,
            fontFamily: language ? 'GESSTwo' : 'ABEAKRG'),
        home: SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget  {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  int _selectedIndex = 0;
  String _selectedName = "live";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedName = index == 0
          ? "live"
          : index == 1
              ? "browse"
              : index == 2 ? "notifications" : "offline";
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
        addNotification(new NotificationInfo( notification.title ?? "" , notification.body ?? "" ));
      }
    });

    super.initState();
  }
  Future<void> addNotification(NotificationInfo n) async {
   await BackendQueries.addNotification(await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "", jsonEncode(n.toJson()));
  }

  @override
  void dispose() {
    AudioService.disconnect();
    super.dispose();
  }

  Future<void> connectAudio() async {
    await AudioService.connect();
  }
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:_selectedIndex == 0 ? FadeTransition(
          opacity: _controller,
         child:Icon(CupertinoIcons.circle_fill,color: Colors.red,size: 13,)):null,
          automaticallyImplyLeading: false,
          title: Text(_selectedName,
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )).tr(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: () {showSearch(context: context, delegate: Search());}, icon: Icon(Icons.search,color: Colors.black,)),
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
            items:  <BottomNavigationBarItem>[
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
                icon: Icon(CupertinoIcons.wifi_slash),
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

class FloatingContainer extends StatelessWidget {
  const FloatingContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream,
            builder: (context, mediaSnap) => mediaSnap.hasData
                ? GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AudioPlayerUI(
                                songName: mediaSnap.data?.title ?? "",albumName: mediaSnap.data?.album ?? ""))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width /1.2 ,
                          decoration: BoxDecoration(
                              color: AppColor.SecondaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(mediaSnap.data?.title ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                      Text(mediaSnap.data?.album ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10)),
                                    ],
                                  ),
                                  Spacer(),
                                  PlayButton(radius: 15, iconSize: 15),
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.stop))
                                ]),
                          )),
                    ),
                  )
                : Expanded(child: SizedBox(width: MediaQuery.of(context).size.width))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: CircleAvatar(child: IconButton(onPressed: ()=>  Navigator.push(context, MaterialPageRoute(builder: (context) => MessegeScreen())),icon: Icon(Icons.message))),
        ),
      ],
    );
  }
}
