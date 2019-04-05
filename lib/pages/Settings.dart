import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// SettingPage

class SettingPage extends StatelessWidget {

  void createRecord(){
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('1').push().set({
      'title': 'Mastering EJB',
      'description': 'Programming Guide for J2EE'
    });
    databaseReference.push().child('2').set({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
  }


  void viewRecord(){}

  void updateRecord(){}

  void deleteRecord(){}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Setting Page"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Create Record'),
            onPressed: () {
              createRecord();
            },
          ),
          RaisedButton(
            child: Text('Create Record'),
            onPressed: () {
              viewRecord();
            },
          ),
          RaisedButton(
            child: Text('Create Record'),
            onPressed: () {
              updateRecord();
            },
          ),
          RaisedButton(
            child: Text('Create Record'),
            onPressed: () {
              deleteRecord();
            },
          ),
        ],
      ),
    );
  }
}