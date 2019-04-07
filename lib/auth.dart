import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth{
  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    print(user.email);
    print(user.uid.toString());
    createBasicInfo(user);
    return user;
  }

  Future<FirebaseUser> currentUser() async{
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async{
    await firebaseAuth.signOut();
  }

  void createBasicInfo (FirebaseUser user){
    FirebaseUser thisUser = user;
    print('Creating basic user info...');
    databaseReference.child('users').child(thisUser.uid.toString()).set({
      'email' : thisUser.email,
      'UID' : thisUser.uid.toString(),
    });
  }

}