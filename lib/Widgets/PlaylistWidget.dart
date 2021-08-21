import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/AudioPlayerTask.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/FirebaseQueries.dart';
import 'package:church_app/QueueSystem.dart';
import 'package:flutter/material.dart';
import 'package:church_app/Screens/AudioPlayerUI.dart';

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
                                   AudioService.start(backgroundTaskEntrypoint: _entryPoint, params: {'list': jsonEncode(QueueSystem.getQueue)});
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayerUI()));
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
