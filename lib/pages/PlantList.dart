import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Plant>> fetchPlants(http.Client client) async {
  final response =
  await client.get('https://api.myjson.com/bins/6651o');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePlants, response.body);
}

// A function that converts a response body into a List<Photo>
List<Plant> parsePlants(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Plant>((json) => Plant.fromJson(json)).toList();
}

class Plant {
  final String name;
  final String species;

  Plant({this.name, this.species});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      species: json['species'],
    );
  }
}


class JsonPlantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Plant List';

    return MaterialApp(
      title: appTitle,
      home: MyPlantList(title: appTitle),
    );
  }
}


class MyPlantList extends StatelessWidget {
  final String title;

  MyPlantList({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<List<Plant>>(
        future: fetchPlants(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Plant> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
            title: Text(photos[index].name),
            subtitle: Text(photos[index].species),
          ),
        );
      },
    );
  }
}