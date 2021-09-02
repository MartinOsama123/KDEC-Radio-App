import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Screens/LiveStream.dart';
import 'package:church_app/models/SessionInfoModel.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingContainer(),*/
       /* body:*/ /*NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title:*/ /*Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:   fontWeight: FontWeight.bold),
                  ),
                ),*/
               /* backgroundColor: Colors.white,
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
              )*/
           /* )
          },*/
          body: /*TabBarView(
              children: [*/
              Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1), () {
                    setState(() {});
                  });
                },
                child: Column(children: [

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildCarousel(context, 1),
                    ),
                  ),
                ])),
          ),
        );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return FutureBuilder<List<SessionInfo>>(
      future: BackendQueries.getAllChannels(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? snapshot.data?.length != 0
                  ? Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          controller: PageController(viewportFraction: 0.95),
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return _buildCarouselItem(
                                context,
                                carouselIndex,
                                itemIndex,
                                snapshot.data?[itemIndex] ??
                                    new SessionInfo(
                                        channelName: "",
                                        token: "",
                                        description: "",
                                        hostName: "",
                                        lang: "",
                                        imgPath: ""));
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        "No available live podcasts right now..\nCheck again later",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex,
      int itemIndex, SessionInfo sessionInfo) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LiveStream(
                          channelName: sessionInfo.channelName,
                          token: sessionInfo.token)));
              print(
                  "https://zingerfinger.000webhostapp.com/imgs/${sessionInfo.imgPath}");
            },
            child: Container(
              child: ClipRRect(
                  child: Image.network(
                      "https://kdechurch.herokuapp.com/api/img/${sessionInfo.imgPath}"),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Hosted by: ${sessionInfo.hostName}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Description: ${sessionInfo.description}"),
        ),
      ],
    );
  }
}
