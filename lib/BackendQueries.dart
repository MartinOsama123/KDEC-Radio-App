
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'QueueSystem.dart';

class BackendQueries {
  static Future<List<String>> getAllAlbums() async {
    print("entered");
    
    var response = await http.get(Uri.http("10.0.2.2:8080", "/file/albums"));
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
    var response = await http.get(Uri.http("10.0.2.2:8080", "/file/$album/songs"));
    AudioPlayer audioPlayer = new AudioPlayer();
    QueueSystem.clearQueue();
    for(var a in jsonDecode(response.body)){
      String download = "10.0.2.2:8080/file/downloads/$album/$a";
      print(download);
  //    await audioPlayer.setUrl(download);
    //  print(audioPlayer.duration);
      QueueSystem.add(new MediaItem(id: download, album: album, title:a.toString() , duration: audioPlayer.duration ?? Duration()));

    }
    return QueueSystem.getQueue;
  }

}
