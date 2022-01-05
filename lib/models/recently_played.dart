import 'package:church_app/models/media_details.dart';
import 'package:church_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyPlayed{

  late List<MediaDetails> list;
  late SharedPreferences prefs;
  RecentlyPlayed(){
    getPrefs();
  }

  Future<List<MediaDetails>> getPrefs() async {
    prefs = getIt<SharedPreferences>();
    prefs.containsKey("recently") ? list = MediaDetails.decode(prefs.getString("recently")!) : list = <MediaDetails>[];
    return list;
  }

  void notify(MediaDetails mediaDetails){
    if(list.indexWhere((element) => element.title == mediaDetails.title) == -1) {
      list.add(mediaDetails);
    }
    else   list.removeWhere((element) => element.title == mediaDetails.title);
    prefs.setString("recently", MediaDetails.encode(list));
  }
}