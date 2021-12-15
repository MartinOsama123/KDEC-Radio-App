import 'package:church_app/models/playlist.dart';
import 'package:get_it/get_it.dart';

import '../audio_handler.dart';
import '../page_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
  getIt.registerLazySingleton<Playlist>(() => Playlist());
}