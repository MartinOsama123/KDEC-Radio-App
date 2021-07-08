import 'package:flutter/material.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({
    Key? key,
  }) : super(key: key);

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
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,
          itemBuilder: (context, index) => Column(
            children: [
              Divider(thickness: 1,),
              ListTile(
                leading: Icon(Icons.arrow_right_outlined),
                title: const Text("Song Name"),
                subtitle: const Text("Song Author"),
                trailing: const Text("20:00"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}