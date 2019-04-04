import 'package:flutter/material.dart';
import 'package:plant_vibez/Camera.dart';


// AddPlant Page

class AddPlantPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text("Add Plant"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Center(
          child: Column(
              children: <Widget>[
                RaisedButton(
                    onPressed: (){ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraApp()),
                    );
                    },
                    child: Text('Take Photo')
                ),
              ]
          ),
        )
    );
  }
}