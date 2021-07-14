import 'package:church_app/Widgets/CarouselWidget.dart';
import 'package:flutter/material.dart';


class DiscoverScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(children: [
      CarouselWidget(lang: "EN"),
      CarouselWidget(lang: "AR"),
      CarouselWidget(lang: "FR"),
    ]),
  );
  }

}