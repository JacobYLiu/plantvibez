import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantListHelp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlantListHelpState();
}

class _PlantListHelpState extends State<PlantListHelp> {
  void _getNames() async {
    final response = await dio.get('https://api.myjson.com/bins/6651o');
    List tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(response.data[i]);
    }

    setState(() {
      plants = tempList;
      _filterPlants = plants;
    });
  }

  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List plants = new List(); // names we get from API
  List _filterPlants = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Plants');

  @override
  Widget build(BuildContext context) {
    _getNames();
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.lightGreen,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){ Navigator.pop(context);},
            ),
            title: _appBarTitle,
            actions: <Widget>[
              IconButton(
                  icon: _searchIcon,
                  onPressed: () {
                    _searchPressed();
                  })
            ]),
        body: _buildList(),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        _filterPlants = plants;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < _filterPlants.length; i++) {
        if (_filterPlants[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(_filterPlants[i]);
        }
      }
      _filterPlants = tempList;
    }
    return ListView.builder(
      itemCount: plants == null ? 0 : _filterPlants.length,
      itemBuilder: (BuildContext context, int index) {
        String title = _filterPlants[index]['name'];
        //Replace all white spaces with + character for searching
        String urlTitle =  title.replaceAll(new RegExp(' '), '+');
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListTile(
            title: Text(title),
            onTap: () async {
              final url = "https://www.google.com/search?q=${urlTitle}";
              print(url);
              if (await canLaunch(url)) {
                launch(url);
              }
            },
          ),
        );
      },
    );
  }

  _PlantListHelpState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filterPlants = plants;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
}

//import 'dart:async';
//import 'dart:convert';
//
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:url_launcher/url_launcher.dart';
//
//
//Future<List<Plant>> fetchPlants(http.Client client) async {
//  final response =
//  await client.get('https://api.myjson.com/bins/6651o');
//
//  return compute(parsePlants, response.body);
//}
//
//// A function that converts a response body into a List<Photo>
//List<Plant> parsePlants(String responseBody) {
//  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//
//  return parsed.map<Plant>((json) => Plant.fromJson(json)).toList();
//}
//
//class Plant {
//  final String name;
//  final String species;
//
//  Plant({this.name, this.species});
//
//  factory Plant.fromJson(Map<String, dynamic> json) {
//    return Plant(
//      name: json['name'],
//      species: json['species'],
//    );
//  }
//}
//
//class JsonPlantList extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Plant List'),
//        backgroundColor: Colors.lightGreen,
//          actions: <Widget>[
//            IconButton(
//            icon: Icon(Icons.search),
//            onPressed: (){
//
//            }
//            )
//          ]
//        ),
//      body: getFutureToList(),
//      );
//  }
//
//
//
//  Widget getFutureToList(){
//    return FutureBuilder<List<Plant>>(
//      future: fetchPlants(http.Client()),
//      builder: (context, snapshot) {
//        if (snapshot.hasError) print(snapshot.error);
//        return snapshot.hasData
//            ? PlantList(plant: snapshot.data)
//            : Center(child: CircularProgressIndicator());
//      },
//    );
//  }
//}
//
//class PlantList extends StatelessWidget {
//  final List<Plant> plant;
//
//  PlantList({Key key, this.plant}) : super(key: key);
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.all(16.0),
//      child: ListView(
//        children: plant.map(_buildItem).toList(),
//      ),
//    );
//  }
//
//
//  Widget _buildItem(Plant plant) {
//    return Padding(
//      key: Key(plant.name),
//      padding: const EdgeInsets.all(16.0),
//      child: new ExpansionTile(
//        title: new Text(plant.name, style: new TextStyle(fontSize: 16.0)),
//        children: <Widget>[
//          new Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              new Text("Species: ${plant.species}"),
//              new IconButton(
//                onPressed: () async {
//                  final url =
//                      "https://www.google.com/search?q=${plant.name}";
//                  print("https://www.google.com/search?q=${plant.name}");
//                  if (await canLaunch(url)) {
//                    launch(url);
//                  }
//                },
//                icon: new Icon(Icons.launch),
//              )
//            ],
//          )
//        ],
//      ),
//    );
//  }
//}
//
//class PlantSearch extends SearchDelegate<String>{
//
//  List<Plant> plant;
//
//  PlantSearch({Key key, this.plant});
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    // actions for search bar
//    return [
//      IconButton(icon: Icon(Icons.clear), onPressed: (){
//        query = "";
//      })
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    // leading icon in the left of the appbar
//    return
//      IconButton(
//          icon: AnimatedIcon(
//            icon: AnimatedIcons.menu_arrow,
//            progress: transitionAnimation,),
//          onPressed: (){
//            close(context,null);
//          }
//      );
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    //
//    return Text('');
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // show nearest results based on API plants
//    return ListView();
//  }
//
//}
//
