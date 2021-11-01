import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/QueueSystem.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/MediaDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PageManager.dart';


class PlaylistWidget extends StatefulWidget {
  final String albumName;
  const PlaylistWidget({
    Key? key,
    required this.albumName,
  }) : super(key: key);

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  final _pageManager = getIt<PageManager>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Playlist",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        FutureBuilder<List<MediaItem>>(
          future: BackendQueries.getAllSongs(widget.albumName),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.done
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Divider(thickness: 1),
                       InkWell(
                                onTap: () async {
                                  _pageManager.addAll(QueueSystem.getQueue,index);
                                   BackendQueries.viewSong(snapshot.data![index].title);
                                   String url = "public/${snapshot.data![index].album}/${snapshot.data![index].title}";
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                   prefs.setString(url, jsonEncode(new MediaDetails(id: snapshot.data![index].id, title: snapshot.data![index].title,album: snapshot.data![index].album)));
                                },
                                child: ListTile(
                                  leading: Icon(Icons.arrow_right_outlined),
                                  title: Text(snapshot.data?[index].title ?? ""),
                                  trailing: Text(snapshot.data?[index].duration.toString().substring(2, 7) ?? ""),
                                ),
                              )
                    ],
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ],
    );
  }
}
