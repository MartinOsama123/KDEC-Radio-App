import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPlayerUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<MediaItem?>(
          stream: AudioService.currentMediaItemStream,
          builder: (context, mediaItem) => mediaItem.hasData ? Column(
      children: [
           Expanded(
              child: Container(decoration: BoxDecoration(color: Colors.grey))),
          StreamBuilder<Duration>(
              stream: AudioService.positionStream,
              builder: (context, snapshot) => Slider(
                  value: snapshot.data?.inSeconds?.toDouble() ?? 0.0,
                  min: 0,
                  max:  mediaItem.data?.duration?.inSeconds.toDouble() ?? 0.0,
                  onChanged: (double value) {
                    print(mediaItem.data?.duration?.inSeconds.toString() ?? "aaaa");
                    AudioService.seekTo(Duration(seconds: value.toInt()));
                  })),
          Row(children: [
            IconButton(
                onPressed: () => AudioService.play(),
                icon: Icon(Icons.play_arrow)),
            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
          ]),
      ],
    ) : CircularProgressIndicator(),
        ));
  }
}
