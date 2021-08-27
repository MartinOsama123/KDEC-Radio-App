import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.arrow_back)),
        title: TextField( controller: _searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Search here',
          ),),
      ),
    );
  }

}