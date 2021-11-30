import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/backend_queries.dart';
import 'package:church_app/Screens/album_screen.dart';
import 'package:church_app/models/album_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CarouselWidget extends StatelessWidget {
  final String category;

  const CarouselWidget({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return  Padding(
     padding: const EdgeInsets.all(8.0),
     child:  Column(

         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Align(
                 alignment: Alignment.centerLeft,
                 child:  Text(
                   category,
                   style: TextStyle(
                       fontSize: 20, fontWeight: FontWeight.bold),
                 )),
           ),

          Padding(
               padding: const EdgeInsets.all(8.0),
               child: _buildCarousel(context, 1,category),
             ),

         ],
       ),

   );
  }

}

Widget _buildCarousel(BuildContext context, int carouselIndex,String category) {
  return FutureBuilder<List<AlbumInfo>>(
    future: BackendQueries.getAllAlbums(category),
    builder: (context, snapshot) =>
    snapshot.connectionState == ConnectionState.done
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 300,
          height: 300,
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
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Provider<AlbumInfo>.value(value:albumInfo,child: AlbumScreen(albumInfo: albumInfo)))),

              child: ClipRRect(child: Hero(tag: albumInfo.albumName,child: FutureBuilder<GetUrlResult>(
                future:  Amplify.Storage.getUrl(key: "${albumInfo.albumName}/${albumInfo.imgPath}"),
                builder:(context, snapshot) =>  CachedNetworkImage(
             fit: BoxFit.cover,
                  imageUrl: snapshot.data?.url ?? "",
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                ),
              ),),borderRadius: BorderRadius.circular(10)),

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