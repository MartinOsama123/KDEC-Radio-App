import 'package:church_app/AppColor.dart';
import 'package:church_app/Widgets/PlaylistWidget.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatefulWidget {
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: AppColor.PrimaryColor,),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(height: 180, width: 180, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("Album Selected"),
              ),
              Text("Author Name"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: AppColor.SecondaryColor,
                    ),
                    icon: Icon(Icons.bookmark_border),
                    label: const Text("Add Favorite")),
              ),
              PlaylistWidget()
            ],
          ),
        ),
      ),
    );
  }
}
