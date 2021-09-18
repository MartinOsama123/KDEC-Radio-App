import 'package:audio_service/audio_service.dart';
import 'package:church_app/Screens/AudioPlayerUI.dart';
import 'package:church_app/Screens/MessegeScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:easy_localization/easy_localization.dart';
import '../AppColor.dart';

class FloatingContainer extends StatelessWidget {
  const FloatingContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream,
            builder: (context, mediaSnap) => mediaSnap.hasData
                ? GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AudioPlayerUI(
                          songName: mediaSnap.data?.title ?? "",
                          albumName: mediaSnap.data?.album ?? ""))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.2,
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
                    )),
              ),
            )
                : Expanded(
                child: SizedBox(width: MediaQuery.of(context).size.width))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
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
    );
  }
}
