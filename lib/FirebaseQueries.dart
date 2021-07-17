import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



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
    for(firebase_storage.Reference r in result.items.toList()){
      String download = await r.getDownloadURL();
      await audioPlayer.setUrl(download);
      QueueSystem.add(new  MediaItem(id: download, album: albumName, title: r.name,duration: audioPlayer.duration ?? Duration()));
    }
    return QueueSystem.getQueue;
  }
}
class QueueSystem {
   static  List<MediaItem> _queue =  <MediaItem>[];
   static void add(MediaItem item) => _queue.add(item);
   static MediaItem getItem(index) => _queue[index];
   static bool isLast(int index) => index == _queue.length-1;
   static bool isFirst(int index) => index == 0;
   static void clearQueue() => _queue.clear();
   static void isEmpty() => _queue.isEmpty;
   static void isNotEmpty() => _queue.isNotEmpty;
   static get getQueue => _queue;
}