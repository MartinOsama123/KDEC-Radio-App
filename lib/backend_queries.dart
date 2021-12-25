
import 'dart:convert';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/models/album_info.dart';
import 'package:church_app/models/notification_info.dart';
import 'package:church_app/models/radioking_track.dart';

import 'package:church_app/models/session_info.dart';
import 'package:church_app/models/song_info.dart';
import 'package:church_app/models/user_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'queue_system.dart';

class BackendQueries {
  static const BASE_URL = "https://kdechurch.herokuapp.com";
  static const IMG_URL = "$BASE_URL/api/img/";
  static Future<List<AlbumInfo>> getAllAlbums(String name) async {

    var response = await http.get(Uri.parse("$BASE_URL/api/albums/category/$name"));


    List<AlbumInfo> list = <AlbumInfo>[];
    if (response.statusCode == 200) {
      try {

         var albums = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
         for(var a in albums){
           list.add(AlbumInfo.fromJson(a));
         }
      } catch (e) {
        print(e.toString());
      }
    }
    return list;
  }
  static Future<AlbumInfo> getAlbumInfo(String album) async {
    var response = await http.get(Uri.parse("$BASE_URL/api/albums/$album"));
    return AlbumInfo.fromJson(jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
  }
  static Future<RadioKingTrack> getCurrentTrack() async {
    var response = await http.get(Uri.parse("https://api.radioking.io/widget/radio/kdec/track/current"));
    return RadioKingTrack.fromJson(jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
  }
  static Stream<RadioKingTrack> getCurrentTrackStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 2000));
      RadioKingTrack someProduct =  await getCurrentTrack();
      yield someProduct;
    }
  }
  static Future<List<MediaItem>> getAllSongs(String album) async {

    var response = await http.get(Uri.parse("$BASE_URL/api/songs/$album"));
    AudioPlayer audioPlayer = new AudioPlayer();
    QueueSystem.clearQueue();
    //String decoded = Utf8Decoder().convert(response.bodyBytes);

    for(var a in jsonDecode(response.body)) {
     GetUrlResult download = await Amplify.Storage.getUrl(key: "$album/${Utf8Decoder().convert(a['songName'].toString().codeUnits)}");
   //  final albumInfo = await getAlbumInfo(album);
      try {
       String temp =  Utf8Decoder().convert(a['songName'].toString().codeUnits);
     //  await audioPlayer.setUrl((Uri.parse(download.url).toString()));
        QueueSystem.add(new MediaItem(id: download.url,
            album: album,
            displayTitle: temp.substring(0,temp.toString().lastIndexOf(".")),
            title: temp.substring(0,temp.toString().lastIndexOf(".")),
            duration:  Duration()));
      }catch(e){print(e.toString());}
    }
    return QueueSystem.getQueue;
  }
  static Future<List<SessionInfo>> getAllChannels() async {
    var response = await http.get(Uri.parse("$BASE_URL/api/channels"));
    var list =   (jsonDecode(Utf8Decoder().convert(response.bodyBytes)) as List);
    List<SessionInfo> sessionList = <SessionInfo>[];
    list.forEach((e) => sessionList.add(SessionInfo.fromJson(e)));
    return sessionList;
  }
  static Future<List<SongInfo>> getSearch(String query) async {
    var response = await http.get(Uri.parse("$BASE_URL/api/songs?search=$query"));
    print(Utf8Decoder().convert(response.bodyBytes));
    var list =   (jsonDecode(Utf8Decoder().convert(response.bodyBytes)) as List);
    List<SongInfo> songList = <SongInfo>[];
    list.forEach((e) => songList.add(SongInfo.fromJson(e)));
    print(songList[0].albumName);
    return songList;
  }
  static Future<List<NotificationInfo>> getAllNotifications(String idToken) async {
    print("$BASE_URL/api/notification/$idToken");
    var response = await http.get(Uri.parse("$BASE_URL/api/notification/$idToken"));
    var list =   (jsonDecode(Utf8Decoder().convert(response.bodyBytes)) as List);
    List<NotificationInfo> notifications = <NotificationInfo>[];
    list.forEach((e) => notifications.add(NotificationInfo.fromJson(e)));
    return notifications;
  }
  static Future<List<String>> getCategories() async {
    print("$BASE_URL/api/category");
    var response = await http.get(Uri.parse("$BASE_URL/api/category"));
    String decoded = Utf8Decoder().convert(response.bodyBytes);
    List<String> categories = <String>[];
    for(var a in jsonDecode(response.body)) {
      var download = Utf8Decoder().convert(a['categoryTitle']
          .toString()
          .codeUnits);
      categories.add(download);
      print(download);
    }
    print(categories);
    return categories;
  }

  static Future<UserModel> getUserInfo(String idToken) async {
    print("MEEEEEEEEEEE: ");
    var response = await http.get(Uri.parse("$BASE_URL/api/users/$idToken"));
    print(response.body);
    var result = UserModel.fromJson(jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
    print(result);
    return result;
  }

  static Future<String> createUser(String token,String user) async {
    print(token);
    print(user);
    var response = await http.post(Uri.parse("$BASE_URL/api/users/create/$token"),  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },body: user);
    print(response.body);
    return response.body;
  }
  static Future<void> viewSong(String name) async {
     await http.post(Uri.parse("$BASE_URL/api/songs/$name"));
  }
  static Future<String> createMessage(String token,String message) async {
    print(message);
    print('$BASE_URL/api/messages/create/$token');
    var response = await http.post(Uri.parse("$BASE_URL/api/messages/create/$token"),  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },body: message);
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
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    var response = await http.post(Uri.parse("$BASE_URL/api/users/subscription/$topic/$token"));

  }
  static Future<void> deleteSub(String token,String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    var response = await http.delete(Uri.parse("$BASE_URL/api/users/subscription/$topic/$token"));
  }
}
