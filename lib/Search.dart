import 'package:church_app/BackendQueries.dart';
import 'package:church_app/Widgets/SearchView.dart';
import 'package:church_app/models/SongInfo.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = "", icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SongInfo>>(
        future: BackendQueries.getSearch(query),
        builder: (context, snapshot) =>
           snapshot.hasData
                ? ListView.separated(
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) =>
                        SearchView(songInfo: snapshot.data![index]),
                    itemCount: snapshot.data!.length)
                :  CircularProgressIndicator() );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
