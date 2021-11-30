import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/backend_queries.dart';
import 'package:church_app/Screens/live_stream.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/radioking_track.dart';
import 'package:church_app/models/session_info.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../page_manager.dart';
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration(seconds: 1), () {
                      setState(() {});
                    });
                  },
                  child: Column(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCarousel(context, 1),
                      ),
                    ),
                  ])),
            ),
          );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    final _pageManager = getIt<PageManager>();
    return  StreamBuilder<RadioKingTrack>(
      stream: BackendQueries.getCurrentTrackStream(),
      builder: (context, snapshot) => snapshot.hasData ?
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () =>     _pageManager.addAll([new MediaItem(id: "https://www.radioking.com/play/kdec",displayDescription: snapshot.data!.cover, title: "Live")],0),
                  child: CachedNetworkImage(imageUrl: snapshot.data!.cover ?? "",
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                     Image.asset("images/podcast.jpg"),
                    fit: BoxFit.cover,),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(snapshot.data!.title ?? ""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(snapshot.data!.artist ?? ""),
            )
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex,
      int itemIndex, SessionInfo sessionInfo) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {

            },
            child: Container(
              child: ClipRRect(
                  child: FutureBuilder<GetUrlResult>(
                    future:  Amplify.Storage.getUrl(key: "${sessionInfo.channelName}/${sessionInfo.imgPath}"),
                    builder: (context, snapshot) =>  CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: snapshot.data?.url ?? "",
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Hosted by: ${sessionInfo.hostName}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Description: ${sessionInfo.description}"),
        ),
      ],
    );
  }
}
