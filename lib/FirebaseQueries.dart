import 'package:audio_service/audio_service.dart';
import 'package:church_app/QueueSystem.dart';
import 'package:just_audio/just_audio.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'AudioPlayerTask.dart';



class FirebaseQueries {
  static Future<List<firebase_storage.Reference>> getAllAlbums() async {
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref().listAll();
    print(result.prefixes.length);
    return result.prefixes.toList();
  }
  static Future<List<MediaItem>> getAlbumPlaylist(String albumName) async {
    firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref().child(albumName).listAll();

    AudioPlayer audioPlayer = new AudioPlayer();
    QueueSystem.clearQueue();
    for(firebase_storage.Reference r in result.items.toList()){
      String download = await r.getDownloadURL();
      await audioPlayer.setUrl(download);
      QueueSystem.add(new MediaItem(id: download, album: albumName, title: r.name , duration: audioPlayer.duration ?? Duration()));

    }

    return QueueSystem.getQueue;
  }
}
