import 'package:firebase_database/firebase_database.dart';
import 'package:plant_vibez/Object/Plant.dart';
// SettingPage

class FirebaseDatabaseUtil {

  final String uid;
  final databaseReference = FirebaseDatabase.instance.reference();

  FirebaseDatabaseUtil(this.uid);

  insertRecord(Plant plant){
    databaseReference.child('plants').child(uid).child(plant.name).set({
      'name' : plant.name,
      'species': plant.species,
    });

  }

  void getRecord(String uid){
//    databaseReference.child('user').child(uid).child('plant').once().then();
  }

  void updateRecord(){}

  void deleteRecord(){}

  DatabaseReference getdbRef(){
    return databaseReference;
  }

}