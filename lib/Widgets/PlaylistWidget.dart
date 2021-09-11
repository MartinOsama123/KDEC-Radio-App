import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/AudioPlayerTask.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/FirebaseQueries.dart';
import 'package:church_app/QueueSystem.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:flutter/material.dart';
import 'package:church_app/Screens/AudioPlayerUI.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _entryPoint() => AudioServiceBackground.run(() => AudioPlayerTask());

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
                      Divider(
                        thickness: 1,
                      ),
                       InkWell(
                                onTap: () async {
                                  if (AudioService.running) await AudioService.stop();
                                   AudioService.start(backgroundTaskEntrypoint: _entryPoint, params: {'list': jsonEncode(QueueSystem.getQueue),'current':jsonEncode(index)});
                                   await BackendQueries.viewSong(snapshot.data![index].title);
                                   String url = "${BackendQueries.BASE_URL}/church/mp3/${snapshot.data![index].title}";
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  print(jsonEncode(snapshot.data));
                                  await prefs.setString(url, jsonEncode(snapshot.data![index]));
                                /*  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (newcontext) =>
                                     Provider<AlbumInfo>.value(
                                          value: Provider.of<AlbumInfo>(context),
                                          child: AudioPlayerUI(songName: snapshot.data?[index].title ?? ""),
                                        )
                                    ),
                                  );*/
                                },
                                child: ListTile(
                                  leading: Icon(Icons.arrow_right_outlined),
                                  title: Text(snapshot.data?[index].title ?? ""),
                                  subtitle: const Text("Song Author"),
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
