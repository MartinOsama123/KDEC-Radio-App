import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/models/media_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Playlist extends ChangeNotifier{

  late List<MediaDetails> list;
  late SharedPreferences prefs;

  
  Future<List<MediaDetails>> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs.containsKey("likes") ? list = MediaDetails.decode(prefs.getString("likes")!) : list = <MediaDetails>[];
    print(list);
    return list;
  }

  void notify(MediaDetails mediaDetails){
    print(list.indexWhere((element) => element.title == mediaDetails.title));
    if(list.indexWhere((element) => element.title == mediaDetails.title) == -1) {
      list.add(mediaDetails);
    }
    else   list.removeWhere((element) => element.title == mediaDetails.title);

    print(list);
    print(prefs.getString("likes"));
    prefs.setString("likes", MediaDetails.encode(list));
    notifyListeners();
  }
}