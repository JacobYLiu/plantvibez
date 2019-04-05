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
  Widget _uploadImage(){
    return new Container(
        child: new Column(
            children: <Widget>[
        new Image.file(image),
              new RaisedButton(
                onPressed: _upload,
                child: Text('Upload'),
                textColor: Colors.black,
                color: Colors.lightGreen,
              ),
    ],
    ),
    );
  }

  Widget _upload(){

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.lightGreen,
            title: new Text('Image Picker'),
          ),
          body: new Container(
            child: new Center(
              child: image == null
                  ? new Text('No Image to Show ')
                  : _uploadImage()
            ),
          ),
          floatingActionButton: Column(
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: takePicture,
                child: new Icon(Icons.camera_alt),
                heroTag: null,
              ),
              FloatingActionButton(
                backgroundColor: Colors.lightGreen,
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
