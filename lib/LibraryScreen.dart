import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft,child: const Text("Library",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),)),
            Align(alignment: Alignment.centerLeft,child: const Text("Live Radio",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),

            Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildCarousel(context,1),
        ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) =>
                  ListTile(leading: Icon(Icons.arrow_right_outlined),
                    title: const Text("Song Name"),
                    subtitle: const Text("Song Author"),
                    trailing: const Text("20:00"),),)
        ],
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        SizedBox(
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex, itemIndex);
            },
          ),
        ),Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Carousel $carouselIndex'),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}


