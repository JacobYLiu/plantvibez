import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File image;

  takePicture() async {
    print('Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickPicture() async {
    print('Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Image Picker'),
          ),
          body: new Container(
            child: new Center(
              child: image == null
                  ? new Text('No Image to Show ')
                  : new Image.file(image),
            ),
          ),
          floatingActionButton: Column(
            children: <Widget>[
              FloatingActionButton(
                onPressed: takePicture,
                child: new Icon(Icons.camera_alt),
                heroTag: null,
              ),
              FloatingActionButton(
                onPressed: pickPicture,
                child: new Icon(Icons.folder_open),
                heroTag: null,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
          )
      ),
    );
  }
}
