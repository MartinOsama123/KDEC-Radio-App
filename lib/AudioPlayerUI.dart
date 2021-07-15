import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPlayerUI extends StatefulWidget {
  @override
  _AudioPlayerUIState createState() => _AudioPlayerUIState();
}

class _AudioPlayerUIState extends State<AudioPlayerUI> with TickerProviderStateMixin {
  late AnimationController iconController;  // make sure u have flutter sdk > 2.12.0 (null safety)
  bool isAnimated = false;
  @override
  void initState() {

    super.initState();
    iconController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream,
            builder: (context, mediaItem) => mediaItem.hasData ? Column(
      children: [
             Expanded(
                child: Image.asset('images/logo.jpg')),
            StreamBuilder<Duration>(
                stream: AudioService.positionStream,
                builder: (context, snapshot) => Column(
                  children: [
                    Slider(
                        value: snapshot.data?.inSeconds?.toDouble() ?? 0.0,
                        min: 0,
                        max:  mediaItem.data?.duration?.inSeconds.toDouble() ?? 499 ,
                        onChanged: (double value) {
                          AudioService.seekTo(Duration(seconds: value.toInt()));
                        }),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Text(snapshot.data?.toString().substring(2, 7) ?? "0"),
                      Text(mediaItem.data?.duration?.toString().substring(2, 7) ?? "500"),
                    ],
                    )
                  ],
                )),
            Center(
              child: Row(children: [
                StreamBuilder<PlaybackState>(
                  stream: AudioService.playbackStateStream,
                  builder: (context, snapshot) => IconButton(
                      onPressed: () {snapshot.data!.playing ? AudioService.pause() : AudioService.play(); setState(() {
                        isAnimated = !isAnimated;
                        isAnimated ? iconController.forward() : iconController.reverse();
                      });},
                      icon:  AnimatedIcon(icon: AnimatedIcons.pause_play, progress:iconController) ,iconSize: 40,),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
              ]),
            ),
      ],
    ) : CircularProgressIndicator(),
          ),
        ));
  }
}
