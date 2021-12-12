import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/backend_queries.dart';
import 'package:church_app/Screens/album_screen.dart';
import 'package:church_app/models/album_info.dart';
import 'package:church_app/models/song_info.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  final SongInfo songInfo;

  const SearchView({Key? key, required this.songInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return ListTile(title: Text(songInfo.songName),subtitle: Text(songInfo.albumName),trailing: Icon(Icons.arrow_forward_ios),onTap: () async {
     AlbumInfo albumInfo = await BackendQueries.getAlbumInfo(songInfo.albumName);
     Navigator.pushNamed(context, "/album",arguments:  albumInfo);
   },);
  }

}