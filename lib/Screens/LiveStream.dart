import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/models/SessionInfoModel.dart';
import 'package:flutter/material.dart';

final appId = "343e0fece606410eb65bc1b9a877b65e";


class LiveStream extends StatefulWidget {
  final SessionInfo sessionInfo;

  final ClientRole role = ClientRole.Audience;

  const LiveStream({required this.sessionInfo});

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = true;
  late RtcEngine _engine;

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    /// Join channel
    await _engine.joinChannel(widget.sessionInfo.token, widget.sessionInfo.channelName, null, 0);

  }

  Future<void> _initAgoraRtcEngine() async {

    _engine = await RtcEngine.create(appId);
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    _engine.muteLocalAudioStream(muted);
  }


  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }));
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
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


  // Information panel to display logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Stop live streaming
  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  /// Mute
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
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
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
