
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/Screens/playlist_screen.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/audio_service/page_manager.dart';
import 'package:church_app/models/media_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class OfflineScreen extends StatefulWidget {
  @override
  _OfflineScreenState createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  late SharedPreferences _prefs = getIt<SharedPreferences>();
  List<MediaItem> media = <MediaItem>[];
  late String prefData;
  late List<MediaDetails> mediaDetails;

  @override
  void initState() {
    prefData = _prefs.getString("recently") ?? "";
    mediaDetails = prefData.isEmpty ? <MediaDetails>[] : MediaDetails.decode(prefData);
    fill();
    super.initState();
  }
  Future<void> fill() async {
    for(int i = 0;i<mediaDetails.length;i++){
      GetUrlResult download = await Amplify.Storage.getUrl(key: "${mediaDetails[i].album}/${mediaDetails[i].title}.mp3");
      media.add(new MediaItem(id: download.url, title: mediaDetails[i].title,album: mediaDetails[i].album));
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                child: Row(children: [
                  Text("favorite",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)).tr(),
                  Icon(Icons.arrow_forward_ios)
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
              ),
            ),onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistScreen()))),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("recently",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500)).tr(),
            ),
            prefData.isNotEmpty ? ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(
                    thickness: 1,
                  ),
                  itemCount: media.length,
                  itemBuilder: (context, index) => index != media.length -1 ? ListTile(
                    title: Text(media[index].title),
                    subtitle: Text(media[index].album!),
                    trailing: Icon(Icons.play_arrow),
                    onTap: () async {
                      getIt<PageManager>().addAll(media,media[index].title);
                    },
                  ): SizedBox(height: 100),
                ): Center(child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("You haven't played anything recently"),
                ))
          ],
        ),
      ),
    );
  }
}
