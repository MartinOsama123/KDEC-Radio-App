
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:church_app/models/NotificationInfo.dart';

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
  static Future<List<NotificationInfo>> getAllNotifications(String idToken) async {
    print("http://10.0.2.2:8080/api/notification/$idToken");
    var response = await http.get(Uri.parse("$BASE_URL/api/notification/$idToken"));
    var list =   (jsonDecode(response.body) as List);
    print(list);
    List<NotificationInfo> notifications = <NotificationInfo>[];
    list.forEach((e) => notifications.add(NotificationInfo.fromJson(e)));
    print(notifications);
    return notifications;
  }

  static Future<UserModel> getUserInfo(String idToken) async {
    var response = await http.get(Uri.parse("$BASE_URL/api/users/$idToken"));
    var result = UserModel.fromJson(jsonDecode(response.body));
    return result;
  }

  static Future<String> createUser(String token,String user) async {
    var response = await http.post(Uri.parse("$BASE_URL/api/users/create/$token"),  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },body: user);
    return response.body;
  }
  static Future<String> addNotification(String token,String notification) async {
    print(notification);
    var response = await http.post(Uri.parse("$BASE_URL/api/notification/add/$token"),  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },body: notification);
    return response.body;
  }

  static Future<void> addSub(String token,String topic) async {
    var response = await http.post(Uri.parse("$BASE_URL/api/users/subscription/$topic/$token"));
  }
  static Future<void> deleteSub(String token,String topic) async {
    var response = await http.delete(Uri.parse("$BASE_URL/api/users/subscription/$topic/$token"));
  }
}
