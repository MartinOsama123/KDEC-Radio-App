import 'package:church_app/models/media_details.dart';
import 'package:church_app/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Playlist extends ChangeNotifier{

  late List<MediaDetails> list;
  late SharedPreferences prefs;

  Playlist(){
    getPrefs();
  }
  Future<List<MediaDetails>> getPrefs() async {
    prefs = getIt<SharedPreferences>();
    prefs.containsKey("likes") ? list = MediaDetails.decode(prefs.getString("likes")!) : list = <MediaDetails>[];

    return list;
  }
  void add(MediaDetails mediaDetails){
    if(list.indexWhere((element) => element.title == mediaDetails.title) == -1) {
      list.add(mediaDetails);

    }
    else   list.removeWhere((element) => element.title == mediaDetails.title);
    prefs.setString("likes", MediaDetails.encode(list));
    notifyListeners();
  }
  bool love(String title){
   return list.indexWhere((element) => element.title == title) != -1;
  }

}