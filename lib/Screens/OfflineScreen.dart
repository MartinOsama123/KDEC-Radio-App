import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AudioPlayerTask.dart';


void _entryPoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class OfflineScreen extends StatefulWidget {
  @override
  _OfflineScreenState createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SharedPreferences>(
        future: _prefs,
        builder: (context, snapshot) {
          List<String> list = snapshot.data?.getKeys().toList() ?? [];
          List<MediaItem?> media = <MediaItem?>[];
          for(int i = 0;i<list.length;i++){
         if(list[i] == "locale"){ list.removeAt(i); if(list.length == 0) break;}
            media.add(MediaItem.fromJson(jsonDecode(snapshot.data?.getString(list[i]) ?? "")));
          }
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(media[index]?.title ?? ""),
              subtitle: Text(media[index]?.album ?? ""),
              trailing: Icon(Icons.play_arrow),
              onTap: () async {
                if (AudioService.running) await AudioService.stop();
                AudioService.start(
                    backgroundTaskEntrypoint: _entryPoint,
                    params: {
                      'list': jsonEncode(media),
                      'current': jsonEncode(index)
                    });
              },
            ),
          );
        },
      ),
    );
  }
}
