import 'package:firebase_database/firebase_database.dart';

class Plant{
  String id;
  String imageLink;
  String name;
  String species;
  DateTime waterTime;
  DateTime lightTime;

  Plant(String id, String name, String species, String waterTime, String lightTime){
    this.id = id;
    this.name = name;
    this.species = species;
    if(waterTime == ''){
      this.waterTime = DateTime.parse("2012-02-27 13:27:00");
    }else{
      this.waterTime = DateTime.parse(waterTime);
    }
    if(lightTime == ''){
      this.lightTime = DateTime.parse("2012-02-27 13:27:00");
    }else{
      this.lightTime = DateTime.parse(lightTime);
    }
  }

  DateTime get wTime => waterTime;
  DateTime get lTime => lightTime;
  set wTime(DateTime waterTime) => waterTime = waterTime;
  set lTime(DateTime lightTime) => lightTime = lightTime;

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
    waterTime = DateTime.parse(snapshot.value['waterTime']);
    lightTime = DateTime.parse(snapshot.value['lightTime']);

  }
}