import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/AppColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPlayerUI extends StatelessWidget {
   final String songName;

  const AudioPlayerUI({Key? key, required this.songName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(leading: IconButton(onPressed: ()=>Navigator.pop(context),icon: Icon(Icons.arrow_back),color: AppColor.PrimaryColor),backgroundColor: Colors.white,elevation: 0,title: Text(songName,style: TextStyle(color: Colors.black),)),
        body: SafeArea(
          child: StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream,
            builder: (context, mediaItem) => mediaItem.hasData ? Column(
      children: [
             Expanded(
                child: Image.asset('images/logo.jpg')),
            AudioSlider(duration: mediaItem.data?.duration ?? Duration()),
     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         crossAxisAlignment: CrossAxisAlignment.center,
           children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.repeat)),
                  IconButton(onPressed: () => AudioService.skipToPrevious(), icon: Icon(Icons.skip_previous)),
                  PlayButton(),
                  IconButton(onPressed: () => AudioService.skipToNext(), icon: Icon(Icons.skip_next)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.shuffle)),
                ]),
     ),

      ],
    ) : CircularProgressIndicator(),
          ),
        ));
  }
}
class PlayButton extends StatefulWidget{
  final double iconSize;
  final double radius;

  const PlayButton({Key? key,  this.iconSize = 35,  this.radius = 30}) : super(key: key);
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
        if (snapshot.hasData) {
          if (!snapshot.data!.playing) {
            iconController.forward();
            print("aaaaaa");
          } else
            iconController.reverse();
          return CircleAvatar(
            backgroundColor: AppColor.SecondaryColor,
            radius: widget.radius,
            child: IconButton(
                color: Colors.white,
                onPressed: () {
                  snapshot.data!.playing ? AudioService.pause() : AudioService
                      .play();
                },
                icon: AnimatedIcon(
                    icon: AnimatedIcons.pause_play, progress: iconController),
                iconSize: widget.iconSize),
          );
        }else return Container();
      }
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
        builder: (context, snapshot) {
      double d = snapshot.data?.inSeconds.toDouble() ?? 0.0;
      double maxD = duration?.inSeconds.toDouble() ?? 499.0;
      if(d > maxD) AudioService.skipToNext();
          return Column(
          children: [
            Slider(
              activeColor: AppColor.PrimaryColor,
                value: d,
                min: 0,
                max:  maxD ,
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
        );});
  }
}
