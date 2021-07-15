import 'package:just_audio/just_audio.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class FirebaseQueries {
  static Future<List<firebase_storage.Reference>> getAllAlbums() async {
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref().listAll();
    print(result.prefixes.length);
    return result.prefixes.toList();
  }
  static Future<List<firebase_storage.Reference>> getAlbumPlaylist(String albumName) async {
    print("entered");
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref().child(albumName).listAll();
    print(result.items.length);
    return result.items.toList();
  }
  static Future<Map<String,Duration>> getMp3Link(String fullPath) async {
    String downloadLink = await firebase_storage.FirebaseStorage.instance.ref().child(fullPath).getDownloadURL();
    print(downloadLink);
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setUrl(downloadLink);

     return {downloadLink: audioPlayer.duration ?? Duration()};

  }
}