import 'package:get_it/get_it.dart';

import '../AudioHandler.dart';
import '../PageManager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());

  getIt.registerLazySingleton<PageManager>(() => PageManager());
  print("finished");
}