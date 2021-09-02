import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/Widgets/PlaylistWidget.dart';
import 'package:church_app/main.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:church_app/models/UserInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatelessWidget {
  final AlbumInfo albumInfo;

  const AlbumScreen({Key? key, required this.albumInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingContainer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.PrimaryColor,
            ),
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
                child: Hero(
                    tag: albumInfo.albumName,
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height / 2,
                      imageUrl: "https://kdechurch.herokuapp.com/api/img/${albumInfo.imgPath}",
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
                    ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(albumInfo.albumName),
              ),
              Text("Author Name"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 100,
                            color: Colors.white54,
                            alignment: Alignment.center,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:  SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.facebook,color: Colors.blue,),),
                                            IconButton(icon: FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),onPressed: () async { await SocialShare.shareWhatsapp(
                                                "Listen to ${albumInfo.albumName} on http://kdec.com/");},),
                                            IconButton(icon: FaIcon(FontAwesomeIcons.instagram),onPressed: () async {  await SocialShare.shareInstagramStory(
                                                "https://kdechurch.herokuapp.com/api/img/${albumInfo.imgPath}",
                                                attributionURL:
                                                "Listen to ${albumInfo.albumName} on http://kdec.com/",
                                                backgroundImagePath:
                                                "https://kdechurch.herokuapp.com/api/img/${albumInfo.imgPath}");},),
                                            IconButton(icon: FaIcon(FontAwesomeIcons.twitter,color: Colors.blueAccent,),onPressed: (){    SocialShare.shareTwitter(
                                                "Listen to this new album ",
                                                hashtags: [
                                                  "kdec",
                                                  "album",
                                                  "fun",
                                                  "hi"
                                                ],
                                                url: "https://kdec.com/");},),
                                          ],
                                        ),
                                      ),


                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: AppColor.SecondaryColor,
                    ),
                    icon: Icon(Icons.share),
                    label: const Text("Share")),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    String albumName = albumInfo.albumName;
                    String token = await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "";
                    context.read<UserModel>().subs.contains(albumInfo.albumName) ? await context.read<UserModel>().removeSub(token, albumName) : await context.read<UserModel>().addSub(token, albumName);
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: AppColor.SecondaryColor,
                  ),
                  icon: Icon(Icons.bookmark_border),
                  label: context.watch<UserModel>().subs.contains(albumInfo.albumName)? const Text("Unsubscribe") : const Text("Subscribe")),
              PlaylistWidget(albumName: albumInfo.albumName),
            ],
          ),
        ),
      ),
    );
  }
}
