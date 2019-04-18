import 'package:firebase_database/firebase_database.dart';

class Plant{
  String id;
  String imageLink;
  String name;
  String species;
  String waterTime;
  String lightTime;

  Plant(String id, String name, String species, String waterTime, String lightTime){
    this.id = id;
    this.name = name;
    this.species = species;
    this.waterTime = waterTime;
    this.lightTime = lightTime;
  }

  String get getWaterTime => waterTime;
  String get getLightTime => lightTime;
  set setWaterTime(String time) => waterTime = time;
  set setLightTime(String time) => lightTime = time;

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      json['id'],
      json['name'],
      json['species'],
      json['waterTime'],
      json['lightTime'],
    );
  }

  Plant.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.species = obj['species'];
    this.waterTime = obj['waterTime'];
    this.lightTime = obj['lightTime'];
  }

  Plant.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.value['name'];
    species = snapshot.value['species'];
    waterTime = snapshot.value['waterTime'];
    lightTime = snapshot.value['lightTime'];
  }


}