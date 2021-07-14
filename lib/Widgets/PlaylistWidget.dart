import 'package:church_app/FirebaseQueries.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
                FutureBuilder<String>(
                  future: FirebaseQueries.getMp3Link(snapshot.data?[index].fullPath ?? ""),
                  builder: (context, linkData) => linkData.connectionState == ConnectionState.done
                      ? ListTile(
                    leading: Icon(Icons.arrow_right_outlined),
                    title:  Text(snapshot.data?[index].name ?? ""),
                    subtitle: const Text("Song Author"),
                    trailing:  Text(linkData.data ?? ""),
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