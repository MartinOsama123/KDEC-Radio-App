import 'package:audio_service/audio_service.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/AudioPlayerUI.dart';
import 'package:church_app/LibraryScreen.dart';
import 'package:church_app/NewScreen.dart';
import 'package:church_app/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel("channel", "title", "Description"
,importance: Importance.high,playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print("a bg message just showed up ${message.messageId}");
}
Future<void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
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
      home:  SplashScreen(),
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
  void initState() {
    connectAudio();
    FirebaseMessaging.onMessage.listen((event) {RemoteNotification? notification = event.notification;
    AndroidNotification? androidNotification = event.notification?.android;
    if(notification != null && androidNotification != null){
      flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.title,
          NotificationDetails(android: AndroidNotificationDetails(channel.id,channel.name,channel.description,color: Colors.black,playSound: true,icon: "@mipmap/ic_launcher")));

    }
    });
    super.initState();
  }

  @override
  void dispose() {
    AudioService.disconnect();
    super.dispose();
  }

  Future<void> connectAudio() async {
    await AudioService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingContainer(),
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

class FloatingContainer extends StatelessWidget {
  const FloatingContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
                    stream: AudioService.currentMediaItemStream,
                    builder: (context, mediaSnap) => mediaSnap.hasData
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 20,
                              decoration: BoxDecoration(
                                  color: AppColor.SecondaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      PlayButton(radius: 15,iconSize: 15),
                                      IconButton(onPressed: (){}, icon: Icon(Icons.stop))
                                ]),
                              )),
                        )
                        : Container());
  }
}
