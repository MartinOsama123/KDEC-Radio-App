import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPlayerUI extends StatelessWidget {

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
            AudioSlider(duration: mediaItem.data?.duration ?? Duration()),
            Center(
              child: Row(children: [
                PlayButton(),
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
class PlayButton extends StatefulWidget{
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin  {
  late AnimationController iconController;  // make sure u have flutter sdk > 2.12.0 (null safety)

  @override
  void initState() {

    super.initState();
    iconController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        if(!snapshot.data!.playing) iconController.forward(); else iconController.reverse();
        return IconButton(
        onPressed: () {snapshot.data!.playing ? AudioService.pause() : AudioService.play();},
        icon:  AnimatedIcon(icon: AnimatedIcons.pause_play, progress:iconController) ,iconSize: 40,);}
    );
  }
}
class AudioSlider extends StatelessWidget {
  final Duration? duration;
  const AudioSlider({
    Key? key, required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: AudioService.positionStream,
        builder: (context, snapshot) => Column(
          children: [
            Slider(
                value: snapshot.data?.inSeconds?.toDouble() ?? 0.0,
                min: 0,
                max:  duration?.inSeconds.toDouble() ?? 499 ,
                onChanged: (double value) {
                  AudioService.seekTo(Duration(seconds: value.toInt()));
                }),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Text(snapshot.data?.toString().substring(2, 7) ?? "0"),
              Text(duration?.toString().substring(2, 7) ?? "500"),
            ],
            )
          ],
        ));
  }
}
