import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth{
  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> currentUser() async{
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async{
    await firebaseAuth.signOut();
  }

}