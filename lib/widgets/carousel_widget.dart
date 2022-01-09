import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/backend/backend_queries.dart';
import 'package:church_app/models/album_info.dart';
import 'package:flutter/material.dart';



class BuildCarousel extends StatelessWidget {
  final int carouselIndex;
  final String category;


  BuildCarousel({ required this.carouselIndex, required this.category});
  late final Future<List<AlbumInfo>> _future = BackendQueries.getAllAlbums(
      category);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<AlbumInfo>>(
        future: _future,
        builder: (context, snapshot) =>

                SizedBox(
                  width: 300,
                  height: 300,
                  child: PageView.builder(

                    itemCount: snapshot.data?.length ?? 0,
                    controller: PageController(viewportFraction: 0.9),
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return BuildCarouselItem(
                          albumInfo: snapshot.data?[itemIndex] ??
                              new AlbumInfo(albumName: "", imgPath: ""),
                          carouselIndex: carouselIndex,
                          itemIndex: itemIndex);
                    },
                  ),
                ),

    );
  }
}

/*Widget _buildCarousel(BuildContext context, int carouselIndex,String category) {
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
              return BuildCarouselItem(albumInfo: snapshot.data?[itemIndex] ?? new AlbumInfo(albumName: "", imgPath: ""),carouselIndex: carouselIndex,itemIndex: itemIndex);
            },
          ),
        ),
      ],
    )
        : CircularProgressIndicator(),
  );
}*/

class BuildCarouselItem extends StatelessWidget {
  final int carouselIndex,  itemIndex;
  final AlbumInfo albumInfo;


   BuildCarouselItem( { required this.carouselIndex, required this.itemIndex, required this.albumInfo});
   late final Future<GetUrlResult> _future = Amplify.Storage.getUrl(key: "${albumInfo.albumName}/${albumInfo.imgPath}");

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, "/album",arguments:  albumInfo),
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Provider<AlbumInfo>.value(value:albumInfo,child: AlbumScreen(albumInfo: albumInfo)))),

              child: ClipRRect(child: Hero(tag: albumInfo.albumName,child: FutureBuilder<GetUrlResult>(
                future:  _future,
                builder:(context, snapshot) => snapshot.connectionState == ConnectionState.done ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  cacheKey: albumInfo.albumName,
                  imageUrl: snapshot.data?.url ?? "",
                  //    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset("images/placeholder.png"),
                ) : Center(child: CircularProgressIndicator()),
              ),),borderRadius: BorderRadius.circular(10)),

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(albumInfo.albumName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
          ),
        ],
      );
  }
}
/*
Widget _buildCarouselItem(
    BuildContext context, int carouselIndex, int itemIndex, AlbumInfo albumInfo) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, "/album",arguments:  albumInfo),
               // Navigator.push(context, MaterialPageRoute(builder: (context) => Provider<AlbumInfo>.value(value:albumInfo,child: AlbumScreen(albumInfo: albumInfo)))),

              child: ClipRRect(child: Hero(tag: albumInfo.albumName,child: FutureBuilder<GetUrlResult>(
                future:  Amplify.Storage.getUrl(key: "${albumInfo.albumName}/${albumInfo.imgPath}"),
                builder:(context, snapshot) => snapshot.connectionState == ConnectionState.done ? CachedNetworkImage(
             fit: BoxFit.cover,
                  cacheKey: albumInfo.albumName,
                  imageUrl: snapshot.data?.url ?? "",
              //    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset("images/placeholder.png"),
                ) : Center(child: CircularProgressIndicator()),
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
}*/
