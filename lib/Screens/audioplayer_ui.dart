
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app_color.dart';
import 'dart:math' as math;
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/media_details.dart';
import 'package:church_app/models/playlist.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

import '../audio_handler.dart';
import '../page_manager.dart';

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
                  ? Column(children: [
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
                                ValueListenableBuilder<RepeatState>(
                                  valueListenable: getIt<PageManager>().repeatButtonNotifier,
                                  builder: (context, value, child) => IconButton(
                                      onPressed: () {getIt<PageManager>().repeat();
                                      if(value.index == 1) getIt<PageManager>().repeat();
                                      }, icon: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(context.locale == Locale("ar","AR")? math.pi : 0),child: CircleAvatar( radius:25,backgroundColor: value.index == 0 ?  Colors.white70 : AppColor.SecondaryColor,child: Icon(Icons.repeat,color:  value.index != 0 ? Colors.white : Colors.black)))),
                                ),
                                FutureBuilder<List<MediaDetails>>(
                                  future: context.watch<Playlist>().getPrefs(),
                                  builder: (context, mediaDetails) => mediaDetails.connectionState == ConnectionState.done ? IconButton(icon: Icon( mediaDetails.data!.indexWhere((element) => element.title == mediaItem.data!.title) != -1 ? Icons.favorite : Icons.favorite_border,
                                      color: mediaDetails.data!.indexWhere((element) => element.title == mediaItem.data!.title) != -1 ? Colors.pink : Colors.grey),onPressed: ()   {
                                    context.read<Playlist>().notify( MediaDetails(id: mediaItem.data!.id, title: mediaItem.data!.title,album: mediaItem.data!.album));
                                  }) : Icon(Icons.favorite_border),
                                ),
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(context.locale == Locale("ar","AR")? math.pi : 0),child: IconButton(
                                      onPressed: () =>
                                      context.locale == Locale("ar","AR") ?getIt<MyAudioHandler>().skipToNext() : getIt<MyAudioHandler>().skipToPrevious(),
                                      icon: Icon(Icons.skip_previous)),
                                ),
                                PlayButton(),
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(context.locale == Locale("ar","AR")? math.pi : 0),child: IconButton(
                                      onPressed: () =>context.locale == Locale("ar","AR") ?getIt<MyAudioHandler>().skipToPrevious(): getIt<MyAudioHandler>().skipToNext(),
                                      icon: Icon(Icons.skip_next)),
                                ),
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(context.locale == Locale("ar","AR")? math.pi : 0),child: ValueListenableBuilder<bool>(
                                  valueListenable: getIt<PageManager>().isShuffleModeEnabledNotifier,
                                  builder: (context, value, child) =>  CircleAvatar(
                                    radius:25,
                                    backgroundColor: value ? AppColor.SecondaryColor : Colors.white70 ,
                                    child: IconButton(
                                          onPressed: () {getIt<PageManager>().shuffle();}, icon: Icon(Icons.shuffle,color:value ? Colors.white : Colors.black,)),
                                  ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 100,
                                            color: Colors.white54,
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:  SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.facebook,color: Colors.blue,),),
                                                      IconButton(icon: FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),onPressed: () async { await SocialShare.shareWhatsapp(
                                                          "Listen to $songName on http://kdec.com/");},),
                                                      IconButton(icon: FaIcon(FontAwesomeIcons.instagram),onPressed: () async {  await SocialShare.shareInstagramStory(
                                                          "https://kdechurch.herokuapp.com/api/img/$songName",
                                                          attributionURL:
                                                          "Listen to $songName on http://kdec.com/",
                                                          backgroundImagePath:
                                                          "https://kdechurch.herokuapp.com/api/img/$songName");},),
                                                      IconButton(icon: FaIcon(FontAwesomeIcons.twitter,color: Colors.blueAccent,),onPressed: (){    SocialShare.shareTwitter(
                                                          "Listen to this new album ",
                                                          hashtags: [
                                                            "kdec",
                                                            "album",
                                                            "fun",
                                                            "hi"
                                                          ],
                                                          url: "https://kdec.com/");},),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.share),
                                ),
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
      iconController;

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
