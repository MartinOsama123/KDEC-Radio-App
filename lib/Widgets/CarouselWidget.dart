
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Screens/AlbumScreen.dart';
import 'package:church_app/models/AlbumInfo.dart';
import 'package:flutter/material.dart';



class CarouselWidget extends StatelessWidget {
  final String lang;

  const CarouselWidget({Key? key, required this.lang}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return  Padding(
     padding: const EdgeInsets.all(8.0),
     child:  Column(
       mainAxisSize: MainAxisSize.min,
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
           Flexible(
             fit: FlexFit.loose,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: _buildCarousel(context, 1),
             ),
           ),
         ],
       ),

   );
  }

}

Widget _buildCarousel(BuildContext context, int carouselIndex) {
  return FutureBuilder<List<AlbumInfo>>(
    future: BackendQueries.getAllAlbums(),
    builder: (context, snapshot) =>
    snapshot.connectionState == ConnectionState.done
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 200.0,
          child: PageView.builder(

            itemCount: snapshot.data?.length ?? 0,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex,
                  itemIndex, snapshot.data?[itemIndex] ?? new AlbumInfo(albumName: "", imgPath: ""));
            },
          ),
        ),
      ],
    )
        : CircularProgressIndicator(),
  );
}


Widget _buildCarouselItem(
    BuildContext context, int carouselIndex, int itemIndex, AlbumInfo albumInfo) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AlbumScreen(albumInfo: albumInfo))),
            child: Container(
           width: MediaQuery.of(context).size.width,
              child: ClipRRect(child: Hero(tag: albumInfo.albumName,child: FutureBuilder<GetUrlResult>(
                future:  Amplify.Storage.getUrl(key: "${albumInfo.albumName}/${albumInfo.imgPath}"),
                builder:(context, snapshot) =>  CachedNetworkImage(
             fit: BoxFit.cover,
                  imageUrl: snapshot.data?.url ?? "",
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                ),
              ),),borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(albumInfo.albumName),
        ),
      ],
    ),
  );
}