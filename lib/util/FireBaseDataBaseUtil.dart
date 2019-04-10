import 'package:firebase_database/firebase_database.dart';
import 'package:plant_vibez/Object/Plant.dart';
// SettingPage

class FirebaseDatabaseUtil {

  final String uid;
  final databaseReference = FirebaseDatabase.instance.reference();

  FirebaseDatabaseUtil(this.uid);

  void insertRecord(Plant plant){
    databaseReference.child('users').child(uid).child('plant').child(plant.name).set({
      'name' : plant.name,
      'species': plant.species,
    });
  }

  void getRecord(){}

  void updateRecord(){}

  void deleteRecord(){}

}