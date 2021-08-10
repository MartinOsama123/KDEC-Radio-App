
import 'dart:convert';

import 'package:audio_service/audio_service.dart';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'QueueSystem.dart';

class BackendQueries {
  static const BASE_URL = "https://kdechurch.herokuapp.com";
  static Future<List<String>> getAllAlbums() async {
    print("entered");
    
    var response = await http.get(Uri.http(BASE_URL, "/church/albums"));
    print("entered ${response.body}");
    List<String> list = <String>[];
    if (response.statusCode == 200) {
      try {
         var albums = jsonDecode(response.body);
         for(var a in albums){
           list.add(a.toString());
         }
      } catch (e) {
        print(e.toString());
      }
    }
    return list;
  }
  static Future<List<MediaItem>> getAllSongs(String album) async {
    var response = await http.get(Uri.http(BASE_URL, "/church/$album/songs"));
    AudioPlayer audioPlayer = new AudioPlayer();
    QueueSystem.clearQueue();
    for(var a in jsonDecode(response.body)){
      String download = "$BASE_URL/church/downloads/$album/$a";
      print(download);
      await audioPlayer.setUrl(download);
      print(audioPlayer.duration);
      QueueSystem.add(new MediaItem(id: download, album: album, title:a.toString() , duration: audioPlayer.duration ?? Duration()));

    }
    return QueueSystem.getQueue;
  }

}
