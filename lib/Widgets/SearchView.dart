import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Screens/AlbumScreen.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:church_app/models/SongInfo.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  final SongInfo songInfo;

  const SearchView({Key? key, required this.songInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return ListTile(title: Text(songInfo.songName),subtitle: Text(songInfo.albumName),trailing: Icon(Icons.arrow_forward_ios),onTap: () async {
     AlbumInfo albumInfo = await BackendQueries.getAlbumInfo(songInfo.albumName);
     Navigator.push(
         context, MaterialPageRoute(builder: (context) => AlbumScreen(albumInfo: albumInfo)));
   },);
  }

}