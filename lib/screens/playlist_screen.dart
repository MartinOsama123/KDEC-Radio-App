import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/Services/service_locator.dart';
import 'package:church_app/Widgets/floating_container.dart';
import 'package:church_app/app_color.dart';
import 'package:church_app/audio_service/page_manager.dart';
import 'package:church_app/models/media_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreen createState() => _PlaylistScreen();
}

class _PlaylistScreen extends State<PlaylistScreen> {
  late SharedPreferences _prefs = getIt<SharedPreferences>();
  List<MediaItem> media = <MediaItem>[];
  late String prefData;
  late List<MediaDetails> mediaDetails;

  @override
  void initState() {
    prefData = _prefs.getString("likes") ?? "";
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
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back,color: AppColor.PrimaryColor),onPressed: ()=> Navigator.pop(context)),
          title: Text("playlist",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )).tr(),
          elevation: 0,
          backgroundColor: Colors.transparent),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingContainer(),
      body:  prefData.isNotEmpty ? ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                ),
                itemCount: media.length,
                itemBuilder: (context, index) => index != mediaDetails.length -1 ?  ListTile(
                  title: Text(media[index].title),
                  subtitle: Text(media[index].album!),
                  trailing: Icon(Icons.play_arrow),
                  onTap: () async {
                    getIt<PageManager>().addAll(media,media[index].title);
                  },
                ) : SizedBox(height: 100),
              ): Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("You haven't liked anything :("),
              ),)
    );
  }
}
