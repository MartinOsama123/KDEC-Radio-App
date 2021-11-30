import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/Screens/playlist_screen.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/media_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../page_manager.dart';
import '../queue_system.dart';



class OfflineScreen extends StatefulWidget {
  @override
  _OfflineScreenState createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: Row(children: [
                Text("favorite",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)).tr(),
                Icon(Icons.arrow_forward_ios)
              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
            ),
          ),onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistScreen()))),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("recently",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500)).tr(),
          ),
          FutureBuilder<SharedPreferences>(
            future: _prefs,
            builder: (context, snapshot) {
              List<MediaItem> media = <MediaItem>[];
              String prefData = snapshot.data?.getString("recently") ?? "";
              List<MediaDetails> mediaDetails = prefData.isEmpty ? <MediaDetails>[] : MediaDetails.decode(prefData);

              for(int i = 0;i<mediaDetails.length;i++){
                media.add(new MediaItem(id: mediaDetails[i].id, title: mediaDetails[i].title,album: mediaDetails[i].album));
              }
              return prefData.isNotEmpty ? ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                ),
                itemCount: mediaDetails.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(media[index].title),
                  subtitle: Text(media[index].album!),
                  trailing: Icon(Icons.play_arrow),
                  onTap: () async {
                    getIt<PageManager>().addAll(media,index);
                  },
                ),
              ): Center(child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("You haven't played anything recently"),
              ));
            },
          ),
        ],
      ),
    );
  }
}
