import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/Widgets/floating_container.dart';
import 'package:church_app/app_color.dart';
import 'package:church_app/models/media_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../page_manager.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreen createState() => _PlaylistScreen();
}

class _PlaylistScreen extends State<PlaylistScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back,color: AppColor.PrimaryColor),onPressed: ()=> Navigator.pop(context)),
          title: Text("playlist",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )).tr(),
          elevation: 0,
          backgroundColor: Colors.transparent),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingContainer(),
      body: FutureBuilder<SharedPreferences>(
            future: _prefs,
            builder: (context, snapshot) {
              List<MediaItem> media = <MediaItem>[];
              List<MediaDetails> mediaDetails = MediaDetails.decode(snapshot.data?.getString("likes") ?? "");
              for(int i = 0;i<mediaDetails.length;i++){
                media.add(new MediaItem(id: mediaDetails[i].id, title: mediaDetails[i].title,album: mediaDetails[i].album));
              }
              return ListView.separated(
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
              );
            },
          ),
    );
  }
}
