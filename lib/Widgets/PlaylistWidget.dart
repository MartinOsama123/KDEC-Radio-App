
import 'package:audio_service/audio_service.dart';
import 'package:church_app/AudioPlayerTask.dart';
import 'package:church_app/FirebaseQueries.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:church_app/AudioPlayerUI.dart';

void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class PlaylistWidget extends StatefulWidget {
  final String albumName;
  const PlaylistWidget({
    Key? key, required this.albumName,
  }) : super(key: key);

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  @override
  void initState()  {
   connectAudio();
    super.initState();
  }
  @override
  void dispose() {
   AudioService.disconnect();
    super.dispose();
  }
  void connectAudio() async{
    await AudioService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Playlist",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
        FutureBuilder<List<Reference>>(
          future: FirebaseQueries.getAlbumPlaylist(widget.albumName),
          builder: (context, snapshot) =>  snapshot.connectionState == ConnectionState.done
              ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => Column(
              children: [
                Divider(thickness: 1,),
                FutureBuilder<Map<String,String>>(
                  future: FirebaseQueries.getMp3Link(snapshot.data?[index].fullPath ?? ""),
                  builder: (context, linkData) => linkData.connectionState == ConnectionState.done
                      ? InkWell(
                    onTap: ()  {
                       AudioService.start(backgroundTaskEntrypoint: _entrypoint,params: {'url':linkData.data?.keys.first ?? ""});
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => AudioPlayerUI()));
                    },
                        child: ListTile(
                    leading: Icon(Icons.arrow_right_outlined),
                    title:  Text(snapshot.data?[index].name ?? ""),
                    subtitle: const Text("Song Author"),
                    trailing:  Text(linkData.data?.entries?.first.value ?? ""),
                  ),
                      ): CircularProgressIndicator(),
                ),
              ],
            ),
          ): CircularProgressIndicator(),
        ),
      ],
    );
  }
}