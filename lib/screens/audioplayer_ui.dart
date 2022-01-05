
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app_color.dart';
import 'dart:math' as math;
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/audio_service/audio_handler.dart';
import 'package:church_app/audio_service/page_manager.dart';
import 'package:church_app/models/media_details.dart';
import 'package:church_app/models/playlist.dart';
import 'package:church_app/widgets/love_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';


class AudioPlayerUI extends StatelessWidget {

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
              elevation: 0),
          body: SafeArea(
            child: mediaItem.hasData
                  ? Column(children: [
                    Expanded(
                            child: Hero(
                          tag: mediaItem.data?.album ?? "",
                          child:  FutureBuilder<GetUrlResult>(
                              future: Amplify.Storage.getUrl(key: mediaItem.data?.displayTitle ?? ""),
                              builder:(context, snapshot) => snapshot.connectionState == ConnectionState.done ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                cacheKey: mediaItem.data?.album,
                                imageUrl: snapshot.data?.url ?? "",
                                //    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.asset("images/placeholder.png"),
                              ) : Center(child: CircularProgressIndicator()),
                            ),
                        )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Row(

                    children: [
                      Column(
                        children: [
                          Text(

                              mediaItem.data?.title ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600)),
                          Text(
                              mediaItem.data?.album ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey,fontSize: 12)),
                        ],
                      ),

                      Spacer(),
                      FutureBuilder<List<MediaDetails>>(
                        future: context.read<Playlist>().getPrefs(),
                        builder: (context, mediaDetails) => LoveButton(mediaItems: mediaItem.data!),
                      ),


                        IconButton(
                          onPressed: ()  async {
                            final DynamicLinkParameters parameters = DynamicLinkParameters(
                              uriPrefix: 'https://kdecradio.page.link',
                              link: Uri.parse('https://kdecradio.page.link/song?albumName=${mediaItem.data?.album}&songName=${mediaItem.data!.title}'),
                              androidParameters: const AndroidParameters(
                                packageName: "com.genesiscreations.church_app",
                                minimumVersion: 0,
                              ),
                              iosParameters: const IOSParameters(
                                bundleId: "com.genesiscreations.kdecradio",
                                minimumVersion: '0',
                              ),
                            );
                            final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
                            final Uri shortUrl = shortDynamicLink.shortUrl;
                            Share.share("Check out ${mediaItem.data?.album} \n $shortUrl");
                          },
                          icon: Icon(Icons.share),
                        ),
                    ],
                  ),
                ),
              ),
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
