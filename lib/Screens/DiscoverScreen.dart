import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Widgets/CarouselWidget.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: BackendQueries.getCategories(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done && snapshot.hasData ?
            ListView.builder(itemCount: snapshot.data!.length,itemBuilder: (context, index) => CarouselWidget(category: snapshot.data![index])) : Center(child: CircularProgressIndicator()));
  }
}
