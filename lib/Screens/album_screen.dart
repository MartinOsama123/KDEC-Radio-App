import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app_color.dart';
import 'package:church_app/Widgets/floating_container.dart';
import 'package:church_app/Widgets/playlist_widget.dart';
import 'package:church_app/models/album_info.dart';
import 'package:church_app/models/user_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final albumInfo = ModalRoute.of(context)?.settings.arguments as AlbumInfo;
    print(albumInfo.albumName);
    print(albumInfo.imgPath);
    return  Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingContainer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(albumInfo.albumName,style: TextStyle(color: Colors.black),),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:5),
                      child: Hero(
                          tag: albumInfo.albumName,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FutureBuilder<GetUrlResult>(
                              future:  Amplify.Storage.getUrl(key: "${albumInfo.albumName}/${albumInfo.imgPath}"),
                              builder:(context, snapshot) => CachedNetworkImage(
                        fit: BoxFit.cover,
                                imageUrl:  snapshot.data?.url ?? "",
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.asset("images/placeholder.png"),
                              ),
                            ),
                          ),
                    )),
                  ),
                ),
              //   Text(albumInfo.albumName),

              //  Text("Author Name"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton.icon(
                      onPressed: ()  async {
                        final DynamicLinkParameters parameters = DynamicLinkParameters(
                          // The Dynamic Link URI domain. You can view created URIs on your Firebase console
                          uriPrefix: 'https://kdecradio.page.link',
                          // The deep Link passed to your application which you can use to affect change
                          link: Uri.parse('https://kdecradio.page.link/album?albumName=${albumInfo.albumName}&imgPath=${albumInfo.imgPath}'),
                          // Android application details needed for opening correct app on device/Play Store
                          androidParameters: const AndroidParameters(
                            packageName: "com.genesiscreations.church_app",
                            minimumVersion: 0,
                          ),
                          // iOS application details needed for opening correct app on device/App Store
                          iosParameters: const IOSParameters(
                            bundleId: "com.genesiscreations.kdecradio",
                            minimumVersion: '0',
                          ),
                        );
                        final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
                        final Uri shortUrl = shortDynamicLink.shortUrl;
                        Share.share("Check out ${albumInfo.albumName} on $shortUrl");
                      },
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: AppColor.SecondaryColor,
                      ),
                      icon: Icon(Icons.share),
                      label:  Text("share").tr()),
                ),
             /*   FutureBuilder<String>(
                  future: FirebaseAuth.instance.currentUser?.getIdToken(true),
                  builder: (context, token) => token.data != null ? ElevatedButton.icon(
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
                      label: context.watch<UserModel>().subs.contains(albumInfo.albumName)?  Text("unsubscribe").tr() :  Text("subscribe").tr()) :  Text("loginSub").tr(),
                ),*/
                 PlaylistWidget(albumName: albumInfo.albumName),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      );
  }
}
