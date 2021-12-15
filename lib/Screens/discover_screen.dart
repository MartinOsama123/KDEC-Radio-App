import 'package:church_app/backend_queries.dart';
import 'package:church_app/Widgets/carousel_widget.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final  Future<List<String>> _future = BackendQueries.getCategories();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future:_future,
        builder: (context, snapshot) =>  snapshot.hasData ?
        SingleChildScrollView(
          child: Column(children: List.generate(snapshot.data?.length ?? 0, (int index)  => Padding(
                  padding: const EdgeInsets.all(8.0),
                child:  Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:  Text(
                            snapshot.data![index],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  BuildCarousel( carouselIndex:1,category: snapshot.data![index]),
                    ),
                    (index == snapshot.data!.length-1) ? SizedBox(height: 50) : Container()
                  ],
                ),
              ),
                 )),
        ): Center(child: CircularProgressIndicator()));
  }
}
