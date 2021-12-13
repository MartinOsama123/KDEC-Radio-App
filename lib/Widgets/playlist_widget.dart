import 'dart:convert';
import 'package:church_app/models/recently_played.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/backend_queries.dart';
import 'package:church_app/models/playlist.dart';
import 'package:church_app/queue_system.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/media_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../page_manager.dart';


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
  final _pageManager = getIt<PageManager>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:   Text(
                "playlist",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).tr()
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
                      Divider(thickness: 1),
                       InkWell(
                                onTap: () async {
                                  _pageManager.addAll(QueueSystem.getQueue,snapshot.data![index].title);
                                   BackendQueries.viewSong(snapshot.data![index].title);
                                //   List<MediaDetails> temp = await context.read<RecentlyPlayed>().getPrefs();
                                  context.read<RecentlyPlayed>().notify( MediaDetails(id: snapshot.data![index].id, title: snapshot.data![index].title,album: snapshot.data![index].album));
                                },
                                child: FutureBuilder<List<MediaDetails>>(
                                  future: context.watch<Playlist>().getPrefs(),
                                  builder: (context, mediaDetails) => mediaDetails.connectionState == ConnectionState.done ? ListTile(
                                    leading: LoveButton(mediaDetails: mediaDetails.data!, mediaItems: snapshot.data!,index: index),
                                    title: Text(snapshot.data?[index].title ?? ""),
                                    trailing: Text(snapshot.data?[index].duration.toString().substring(2, 7) ?? ""),
                                  ) : Container(),
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

class LoveButton extends StatelessWidget {
  final List<MediaDetails> mediaDetails;
  final List<MediaItem> mediaItems;
  final int index;
  const LoveButton({
    Key? key, required this.mediaDetails, required this.mediaItems, required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon( mediaDetails.indexWhere((element) => element.title == mediaItems[index].title) != -1 ? Icons.favorite : Icons.favorite_border,
      color: mediaDetails.indexWhere((element) => element.title == mediaItems[index].title) != -1 ? Colors.pink : Colors.grey),onPressed: ()   {
      context.read<Playlist>().notify( MediaDetails(id: mediaItems[index].id, title: mediaItems[index].title,album: mediaItems[index].album));
      });
  }
}
