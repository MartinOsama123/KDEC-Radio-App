import 'package:church_app/backend_queries.dart';
import 'package:church_app/Widgets/carousel_widget.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: BackendQueries.getCategories(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done && snapshot.hasData ?
            ListView.builder(shrinkWrap:true,itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                Column(
                  children: [
                    CarouselWidget(category: snapshot.data![index]),
                    (index == snapshot.data!.length-1) ? SizedBox(height: 50) : Container()
                  ],
                ),
               ) : Center(child: CircularProgressIndicator()));
  }
}
