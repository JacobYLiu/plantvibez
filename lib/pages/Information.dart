import 'package:flutter/material.dart';
import 'package:plant_vibez/Object/Plant.dart';

// Info Page

class Information extends StatelessWidget {

  final Plant plant;

  Information({Key key, @required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(plant.name),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Image.asset(plant.imageLink),
      ),
    );
  }
}