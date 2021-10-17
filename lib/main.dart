
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/Screens/AlbumScreen.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'amplifyconfiguration.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:church_app/models/UserInfo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Screens/HomeScreen.dart';
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
Future<void> configureAmplify()async {
  await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);
// ... add other plugins, if any
  await Amplify.configure(amplifyconfig);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
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
        supportedLocales: [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ar', 'AR')
        ],
        path:
            'assets/translation', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(
              email: "", name: "", phone: "", subs: [], notifications: []),
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
            fontFamily: EasyLocalization.of(context)?.currentLocale ==
                    Locale("ar", "AR")
                ? 'GESSTwo'
                : 'ABEAKRG'),
        home: SplashScreen(),
      ),
    );
  }
}



