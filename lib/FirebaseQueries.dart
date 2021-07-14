import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  static Future<String> getMp3Link(String fullPath) async {
    String downloadLink = await firebase_storage.FirebaseStorage.instance.ref().child(fullPath).getDownloadURL();
    print(downloadLink);
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setUrl(downloadLink);

    await for (var value in audioPlayer.onDurationChanged){
     return "${value.inMinutes}:${value.inSeconds - value.inMinutes * 60}";
    }
    return "0:00";
  }
}
class GetDuration extends ChangeNotifier {
  String _duration = "0:00";

  String get duration => _duration;

   Future<void> getMp3Lin(String fullPath) async {
    String downloadLink = await firebase_storage.FirebaseStorage.instance.ref().child(fullPath).getDownloadURL();
    print(downloadLink);
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setUrl(downloadLink);
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      _duration = d.toString();
    });
  }
}