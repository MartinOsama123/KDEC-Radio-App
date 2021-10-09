import 'package:audio_service/audio_service.dart';
import 'package:church_app/Screens/AudioPlayerUI.dart';
import 'package:church_app/Screens/LiveStream.dart';
import 'package:church_app/Screens/MessegeScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:easy_localization/easy_localization.dart';
import '../AppColor.dart';

class FloatingContainer extends StatefulWidget {
  const FloatingContainer({
    Key? key,
  }) : super(key: key);

  @override
  _FloatingContainerState createState() => _FloatingContainerState();
}

class _FloatingContainerState extends State<FloatingContainer> {
  @override
  Widget build(BuildContext context) {

    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
          children: [
            StreamBuilder<MediaItem?>(
                stream: AudioService.currentMediaItemStream,
                builder: (context, mediaSnap) => mediaSnap.hasData
                    ? Positioned(
                  bottom: 4,
                      left: 5,
                      child: GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AudioPlayerUI(
                                songName: mediaSnap.data?.title ?? "",
                                albumName: mediaSnap.data?.album ?? ""))),

                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.8 ,
                              decoration: BoxDecoration(
                                  color: AppColor.SecondaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(mediaSnap.data?.title ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16)),
                                          Text(mediaSnap.data?.album ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10)),
                                        ],
                                      ),
                                      Spacer(),
                                      PlayButton(radius: 15, iconSize: 15),
                                      IconButton(
                                          onPressed: () {}, icon: Icon(Icons.stop))
                                    ]),
                              ),
                        ),


                ),
                    )
                    :  SizedBox(width: MediaQuery.of(context).size.width * 0.8)),
            Positioned(
              right: 5,
              bottom:0,
             child: SpeedDial(
                    child: Icon(Icons.add),
                    closedForegroundColor: Colors.black,
                    openForegroundColor: AppColor.SecondaryColor,
                    closedBackgroundColor: AppColor.SecondaryColor,
                    openBackgroundColor: Colors.black,
                    speedDialChildren: <SpeedDialChild>[
                      SpeedDialChild(
                        child: FaIcon(FontAwesomeIcons.donate),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        label: 'donate'.tr(),
                        onPressed: () {

                        },
                        closeSpeedDialOnPressed: false,
                      ),
                      SpeedDialChild(
                        child: FaIcon(FontAwesomeIcons.comment),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow,
                        label: 'prayer'.tr(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessegeScreen()));
                        },
                      ),
                      //  Your other SpeeDialChildren go here.
                    ],
                  ),
           ),

          ],
        ),
    );
  }
}
