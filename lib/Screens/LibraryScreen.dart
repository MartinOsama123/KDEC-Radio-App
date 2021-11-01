import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Screens/LiveStream.dart';
import 'package:church_app/models/SessionInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return FutureBuilder<List<SessionInfo>>(
      future: BackendQueries.getAllChannels(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? snapshot.data?.length != 0
                  ? Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          controller: PageController(viewportFraction: 0.95),
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return _buildCarouselItem(
                                context,
                                carouselIndex,
                                itemIndex,
                                snapshot.data?[itemIndex] ??
                                    new SessionInfo(channelName: "", token: "", description: "", hostName: "", lang: "", imgPath: ""));
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        "noPodcast",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ).tr(),
                    )
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex,
      int itemIndex, SessionInfo sessionInfo) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LiveStream(sessionInfo: sessionInfo)));
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
