
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/models/AlbumInfo.dart';

import 'package:church_app/models/SessionInfoModel.dart';
import 'package:church_app/models/UserInfo.dart';


import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'QueueSystem.dart';

class BackendQueries {
  static const BASE_URL = "https://kdechurch.herokuapp.com";
  static Future<List<AlbumInfo>> getAllAlbums() async {
   
    var response = await http.get(Uri.parse("$BASE_URL/api/albums"));

    print("entered ${response.body}");
    List<AlbumInfo> list = <AlbumInfo>[];
    if (response.statusCode == 200) {
      try {
         var albums = jsonDecode(response.body);
         for(var a in albums){
           list.add(AlbumInfo.fromJson(a));
         }
      } catch (e) {
        print(e.toString());
      }
    }
    return list;
  }
  static Future<List<MediaItem>> getAllSongs(String album) async {

    var response = await http.get(Uri.parse("$BASE_URL/api/songs/$album"));

    AudioPlayer audioPlayer = new AudioPlayer();
    QueueSystem.clearQueue();
    for(var a in jsonDecode(response.body)){
      String download = "$BASE_URL/church/mp3/${a['songName']}";
      print(download);
      await audioPlayer.setUrl(download);
      print(audioPlayer.duration);
      QueueSystem.add(new MediaItem(id: download, album: album, title:a['songName'].toString() , duration: audioPlayer.duration ?? Duration()));
    }
    return QueueSystem.getQueue;
  }
  static Future<List<SessionInfo>> getAllChannels() async {
    var response = await http.get(Uri.parse("$BASE_URL/api/channels"));
    var list =   (jsonDecode(response.body) as List);
    List<SessionInfo> sessionList = <SessionInfo>[];
    list.forEach((e) => sessionList.add(SessionInfo.fromJson(e)));
    return sessionList;
  }
  static Future<UserModel> getUserInfo(String email) async {
    var response = await http.get(Uri.parse("$BASE_URL/api/users/$email"));
    var result = UserModel.fromJson(jsonDecode(response.body));
    return result;
  }
}
