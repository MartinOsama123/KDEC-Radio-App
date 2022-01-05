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
late final AlbumInfo albumInfo;
 late final Future<GetUrlResult> _future = Amplify.Storage.getUrl(key: "${albumInfo.albumName}/${albumInfo.imgPath}");
@override
  Widget build(BuildContext context) {
     albumInfo = ModalRoute.of(context)?.settings.arguments as AlbumInfo;
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
        body: ScrollBody(albumInfo: albumInfo, future: _future),
      );
  }
}

class ScrollBody extends StatefulWidget {
  const ScrollBody({
    Key? key,
    required this.albumInfo,
    required Future<GetUrlResult> future,
  }) : _future = future, super(key: key);

  final AlbumInfo albumInfo;
  final Future<GetUrlResult> _future;

  @override
  State<ScrollBody> createState() => _ScrollBodyState();
}

class _ScrollBodyState extends State<ScrollBody> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _scaffoldKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(

          children: [
            Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:5),
                  child: Hero(
                      tag: widget.albumInfo.albumName,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FutureBuilder<GetUrlResult>(
                          future:  widget._future,
                          builder:(context, snapshot) => snapshot.connectionState == ConnectionState.done ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            cacheKey: widget.albumInfo.albumName,
                            imageUrl: snapshot.data?.url ?? "",
                            //    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset("images/placeholder.png"),
                          ) : Center(child: CircularProgressIndicator()),
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
                      link: Uri.parse('https://kdecradio.page.link/album?albumName=${widget.albumInfo.albumName}&imgPath=${widget.albumInfo.imgPath}'),
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
                    Share.share("Check out ${widget.albumInfo.albumName} on $shortUrl");
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
             PlaylistWidget(albumName: widget.albumInfo.albumName),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
