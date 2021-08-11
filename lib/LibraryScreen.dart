
import 'package:church_app/AppColor.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/DiscoverScreen.dart';
import 'package:church_app/LiveStream.dart';
import 'package:church_app/main.dart';
import 'package:church_app/models/SessionInfoModel.dart';
import 'package:flutter/material.dart';


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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingContainer(),
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
          body:  TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                    child:  RefreshIndicator(
                      onRefresh: (){  return Future.delayed(
                          Duration(seconds: 1),(){
                        setState(() {
                        });});},
                      child: ListView(
                        shrinkWrap: true,
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
                          ), Padding(
                              padding: const EdgeInsets.all(8.0),
                        
                              child: _buildCarousel(context, 1),
                            ),

                      //    PlaylistWidget(albumName: "",)
                        ],
                      ),
                    ),

                ),
                DiscoverScreen(),
                Container()
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {

    return FutureBuilder<List<SessionInfo>>(
      future: BackendQueries.getAllChannels(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? snapshot.data?.length != 0 ? Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 200.0,
                        child: PageView.builder(


                          itemCount: snapshot.data?.length ?? 0,
                          controller: PageController(viewportFraction: 0.95),
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return _buildCarouselItem(context, carouselIndex,
                                itemIndex, snapshot.data?[itemIndex].channelName ?? "Anonymous",snapshot.data?[itemIndex].token ?? "");
                          },
                        ),

                      ),
                    ],
                  ),
              ) : Center(child: Text("No available live podcasts right now..\nCheck again later",style: TextStyle(color: Colors.black,fontSize: 15),),)
              : Center(child: CircularProgressIndicator()),
    );
  }


  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex, String name,String token) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => LiveStream(channelName: name,token: token))),
                  child: Container(
                    child: ClipRRect(child: Image.asset("images/podcast.jpg"),borderRadius: BorderRadius.circular(10)),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name),
        ),
      ],
    );
  }
}
