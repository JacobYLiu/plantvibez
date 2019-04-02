import 'package:flutter/material.dart';
import 'package:plant_vibez/Camera.dart';
import 'package:camera/camera.dart';


// AddPlant Page

class AddPlantPage extends StatelessWidget {
  final CameraDescription cameras;

  AddPlantPage(this.cameras);
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
                      MaterialPageRoute(builder: (context) => CameraScreen(camera: cameras)),
                    );
                    },
                    child: Text('Take Photo')
                ),
                RaisedButton(
                    onPressed: (){ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen(camera: cameras)),
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