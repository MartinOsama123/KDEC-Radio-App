import 'package:audio_service/audio_service.dart';
import 'package:church_app/models/media_details.dart';
import 'package:church_app/models/playlist.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoveButton extends StatefulWidget {

  final MediaItem mediaItems;

   LoveButton({
    Key? key, required this.mediaItems
  }) : super(key: key);

  @override
  State<LoveButton> createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> {

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(  context.watch<Playlist>().love( widget.mediaItems.title) ? Icons.favorite : Icons.favorite_border,
        color:  context.watch<Playlist>().love( widget.mediaItems.title) ? Colors.pink : Colors.grey),onPressed: ()   {
      context.read<Playlist>().add( MediaDetails(id: widget.mediaItems.id, title: widget.mediaItems.title,album: widget.mediaItems.album));
    });
  }
}