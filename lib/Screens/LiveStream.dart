import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/models/SessionInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../PageManager.dart';
import '../QueueSystem.dart';


class LiveStream extends StatefulWidget {
  final SessionInfo sessionInfo;
  const LiveStream({required this.sessionInfo});

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
        CachedNetworkImage(
        imageUrl:
        "https://kdechurch.herokuapp.com/api/img/${widget.sessionInfo.imgPath}",
        placeholder: (context, url) =>
            CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Icon(Icons.error),
      width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,fit: BoxFit.contain,),
        //    _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
