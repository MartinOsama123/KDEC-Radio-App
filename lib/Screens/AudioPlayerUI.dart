import 'dart:ui';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AudioHandler.dart';
import '../PageManager.dart';

class AudioPlayerUI extends StatelessWidget {
  final String songName;
  final String albumName;

  const AudioPlayerUI({Key? key, required this.songName,required this.albumName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<MediaItem?>(
      stream: getIt<MyAudioHandler>().mediaItem,  builder: (context, mediaItem) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                  color: AppColor.PrimaryColor),
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                mediaItem.data?.title ?? "",
                style: TextStyle(color: Colors.black),
              )),
          body: SafeArea(
            child: mediaItem.hasData
                  ? Column(
                      children: [
                        Expanded(
                            child: Hero(
                          tag: mediaItem.data?.album ?? "",
                          child:  FutureBuilder<GetUrlResult>(
                              future: Amplify.Storage.getUrl(key: mediaItem.data?.displayTitle ?? ""),
                              builder:(context, snapshot) =>  CachedNetworkImage(
                                  height: MediaQuery.of(context).size.height / 2,
                                  imageUrl: snapshot.data?.url ?? "",
                                  placeholder: (context, url) =>
                                      Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                            ),

                        )),
                         AudioProgressBar(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.repeat)),
                               /* IconButton(
                                    onPressed: () {}, icon: Icon(Icons.favorite_border)),*/
                                IconButton(
                                    onPressed: () =>
                                        getIt<MyAudioHandler>().skipToPrevious(),
                                    icon: Icon(Icons.skip_previous)),
                                PlayButton(),
                                IconButton(
                                    onPressed: () => getIt<MyAudioHandler>().skipToNext(),
                                    icon: Icon(Icons.skip_next)),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.shuffle)),
                              ]),
                        ),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),

          )),
    );
  }
}

class PlayButton extends StatefulWidget {
  final double iconSize;
  final double radius;

  const PlayButton({Key? key, this.iconSize = 35, this.radius = 30})
      : super(key: key);
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late AnimationController
      iconController; // make sure u have flutter sdk > 2.12.0 (null safety)

  @override
  void initState() {
    super.initState();
    iconController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
        stream: getIt<MyAudioHandler>().playbackState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!snapshot.data!.playing) {
              iconController.forward();
            } else
              iconController.reverse();
            return CircleAvatar(
              backgroundColor: AppColor.SecondaryColor,
              radius: widget.radius,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    snapshot.data!.playing
                        ? getIt<MyAudioHandler>().pause()
                        : getIt<MyAudioHandler>().play();
                  },
                  icon: AnimatedIcon(
                      icon: AnimatedIcons.pause_play, progress: iconController),
                  iconSize: widget.iconSize),
            );
          } else
            return Container();
        });
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProgressBar(
            progress: value.current,
            buffered: value.buffered,
            total: value.total,
            onSeek: pageManager.seek,
          ),
        );
      },
    );
  }
}
