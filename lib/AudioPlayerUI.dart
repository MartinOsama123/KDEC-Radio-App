import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class AudioPlayerUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Row(children: [
        IconButton(onPressed: ()=> AudioService.play(), icon: Icon(Icons.play_arrow)),
        IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow)),
        IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow)),
        IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow)),
        IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow)),
      ]));
  }

}