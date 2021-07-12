import 'package:church_app/AlbumScreen.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/Widgets/PlaylistWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                    "Library",
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                backgroundColor: Colors.white,
                pinned: true,
                floating: true,
                bottom: TabBar(
                  labelColor: AppColor.PrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColor.PrimaryColor,
                  tabs: [
                    Tab(child: const Text("Listen now")),
                    Tab(child: const Text("Discover")),
                    Tab(child: const Text("Favorite"))
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Live Radio",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCarousel(context, 1),
                      ),
                      PlaylistWidget()
                    ],
                  ),
                ),
              ),
              Container(),
              Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return FutureBuilder<List<firebase_storage.Reference>>(
      future: getAllAlbums(),
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
                              itemIndex, snapshot.data?[itemIndex].name ?? "");
                        },
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
    );
  }

  Future<List<firebase_storage.Reference>> getAllAlbums() async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref().listAll();
    print(result.prefixes.length);
    return result.prefixes.toList();
  }

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex, String name) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AlbumScreen())),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ),
    );
  }
}
