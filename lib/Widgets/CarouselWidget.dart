import 'package:church_app/AlbumScreen.dart';
import 'package:church_app/FirebaseQueries.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CarouselWidget extends StatelessWidget {
  final String lang;

  const CarouselWidget({Key? key, required this.lang}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return  Padding(
     padding: const EdgeInsets.all(8.0),
     child: SingleChildScrollView(
       child: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Align(
                 alignment: Alignment.centerLeft,
                 child:  Text(
                   lang,
                   style: TextStyle(
                       fontSize: 20, fontWeight: FontWeight.bold),
                 )),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: _buildCarousel(context, 1),
           ),
         ],
       ),
     ),
   );
  }

}

Widget _buildCarousel(BuildContext context, int carouselIndex) {
  return FutureBuilder<List<Reference>>(
    future: FirebaseQueries.getAllAlbums(),
    builder: (context, snapshot) =>
    snapshot.connectionState == ConnectionState.done
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 200.0,
          child: PageView.builder(

            itemCount: snapshot.data?.length ?? 0,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex,
                  itemIndex, snapshot.data?[itemIndex].name ?? "Anonymous");
            },
          ),
        ),
      ],
    )
        : CircularProgressIndicator(),
  );
}


Widget _buildCarouselItem(
    BuildContext context, int carouselIndex, int itemIndex, String name) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AlbumScreen(albumName: name))),
            child: Container(

              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name),
        ),
      ],
    ),
  );
}