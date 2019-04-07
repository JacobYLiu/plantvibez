import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HelpState();

}

class _HelpState extends State<Help>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text("Search"),
          backgroundColor: Colors.lightGreen,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){

              },
            )
          ],
        ),
      body: ListView(),
    );
  }
}

class PlantSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for search bar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){})
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon in the left of the appbar
    return
      IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation,),
          onPressed: (){});
  }

  @override
  Widget buildResults(BuildContext context) {
    //
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show nearest results based on API plants
    return null;
  }

}