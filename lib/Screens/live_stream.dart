import 'dart:async';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/session_info.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../page_manager.dart';
import '../queue_system.dart';


class LiveStream extends StatefulWidget {
  final String title;
  final String url;

  const LiveStream({Key? key, required this.title, required this.url}) : super(key: key);
  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
 final _pageManager = getIt<PageManager>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
     _pageManager.addAll([new MediaItem(id: "https://www.radioking.com/play/kdec", title: "Live")],0);

  }


  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () async {
              _pageManager.stop();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            ClipRRect(child: Hero(tag: widget.title,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.url,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Image.asset("images/podcast.jpg"),
                ),
            ),),borderRadius: BorderRadius.circular(10)),
        //    _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
