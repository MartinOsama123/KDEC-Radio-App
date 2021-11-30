import 'package:church_app/models/media_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyPlayed extends ChangeNotifier{

  late List<MediaDetails> list;
  late SharedPreferences prefs;


  Future<List<MediaDetails>> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs.containsKey("recently") ? list = MediaDetails.decode(prefs.getString("recently")!) : list = <MediaDetails>[];
    return list;
  }

  void notify(MediaDetails mediaDetails){
    print(list.indexWhere((element) => element.title == mediaDetails.title));
    if(list.indexWhere((element) => element.title == mediaDetails.title) == -1) {
      list.add(mediaDetails);
    }
    else   list.removeWhere((element) => element.title == mediaDetails.title);

    print(list);
    print(prefs.getString("recently"));
    prefs.setString("recently", MediaDetails.encode(list));
    notifyListeners();
  }
}