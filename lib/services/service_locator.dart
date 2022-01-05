import 'package:church_app/audio_service/audio_handler.dart';
import 'package:church_app/audio_service/page_manager.dart';
import 'package:church_app/models/playlist.dart';
import 'package:church_app/models/recently_played.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
/*  getIt.registerLazySingleton<Playlist>(() => Playlist());*/
  getIt.registerLazySingleton<RecentlyPlayed>(() => RecentlyPlayed());
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    return SharedPreferences.getInstance();
  });
}