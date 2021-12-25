
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:church_app/Screens/audioplayer_ui.dart';
import 'package:church_app/Screens/discover_screen.dart';
import 'package:church_app/Screens/live_screen.dart';
import 'package:church_app/Screens/login_screen.dart';
import 'package:church_app/Screens/notification_screen.dart';
import 'package:church_app/Screens/password_reset_screen.dart';
import 'package:church_app/Screens/profile_screen.dart';
import 'package:church_app/Screens/signup_screen.dart';
import 'package:church_app/app_color.dart';
import 'package:church_app/Screens/album_screen.dart';
import 'package:church_app/firebase_auth.dart';
import 'package:church_app/models/playlist.dart';
import 'package:church_app/models/recently_played.dart';
import 'Services/service_locator.dart';
import 'amplifyconfiguration.dart';
import 'package:church_app/models/album_info.dart';
import 'package:church_app/models/user_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Screens/home_screen.dart';
import 'Screens/splash_screen.dart';


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
  await setupServiceLocator();
  await configureAmplify();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


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
              email: "", name: "", phone: "", messages: [], notifications: [],/*age: 0*/),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirebaseAuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider<RecentlyPlayed>(
          create: (_) => RecentlyPlayed(),
        ),
      ],
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
       initialRoute: '/splash',
       routes: {'/splash' : (_) => SplashScreen(),
         '/home' : (_) => MyHomePage(),
         '/live' : (_) => LiveScreen(),
       '/album' : (_) => AlbumScreen(),
         '/browse' : (_) => DiscoverScreen(),
         '/library' : (_) => LiveScreen(),
         '/profile' : (_) => ProfileScreen(),
         '/signup' : (_) => SignupScreen(),
         '/login' : (_) =>LoginScreen(),
         '/song' : (_) => AudioPlayerUI(),
         '/reset' : (_) => PasswordResetScreen(),
         '/notification' : (_) => NotificationScreen()},
        theme: ThemeData(
            primaryColor: AppColor.PrimaryColor,
            accentColor: AppColor.SecondaryColor,
            fontFamily: EasyLocalization.of(context)?.currentLocale ==
                    Locale("ar", "AR")
                ? 'GESSTwo'
                : 'ABEAKRG'),

      ),
    );
  }
}



