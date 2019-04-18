import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:plant_vibez/Object/Plant.dart';

class PlantDescription extends StatefulWidget {
  final Plant plant;
  final String uid;

  PlantDescription(this.plant, this.uid);

  @override
  State<StatefulWidget> createState() => new _PlantDescriptionState();
}

class _PlantDescriptionState extends State<PlantDescription> {
  DatabaseReference plantsReference;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _waterTimeSchedule;
  TextEditingController _lightTimeSchedule;

  @override
  void initState() {
    super.initState();
    plantsReference = FirebaseDatabase.instance.reference();
    _titleController = new TextEditingController(text: widget.plant.name);
    _descriptionController =
        new TextEditingController(text: widget.plant.species);
    _waterTimeSchedule =
        new TextEditingController(text: widget.plant.waterTime.toString());
    _lightTimeSchedule =
        new TextEditingController(text: widget.plant.lightTime.toString());
    _waterTimeSchedule.addListener(waterTimeOnChange);
    _lightTimeSchedule.addListener(lightTimeOnChange);
  }

  void waterTimeOnChange(){
    setState(() {});
  }

  void lightTimeOnChange(){
    setState(() {});
  }


  String _validateTime(String time) {
    if (!time.contains(new RegExp(r"\d\d\:\d\d:\d\d"))) {
      return 'Not in format! Has to be hh:mm:ss';
    } else {
      var times = time.split(':');
      int hour = int.parse(times[0]);
      int min = int.parse(times[1]);
      int sec = int.parse(times[2]);
      if (hour < 0 || hour > 24) {
        return 'Hour must be from 0 to 24';
      } else if (min < 0 || min > 60) {
        return 'Minute must be from 0 to 60';
      } else if (sec < 0 || sec > 60) {
        return 'Second must be from 0 to 60';
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.plant.name} Description'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
                controller: _waterTimeSchedule,
                decoration: InputDecoration(
                  labelText: 'Water Schedule',
                  hintText: 'Schedule for daily notification',
                  helperText: 'Format:(hh:mm:ss)',
                  errorText: (_waterTimeSchedule.text == '')
                      ? null
                      :  _validateTime(_waterTimeSchedule.text),
                )),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _lightTimeSchedule,
              decoration: InputDecoration(
                labelText: 'Light Schedule',
                hintText: 'Schedule for daily notification',
                helperText: 'Format:(hh:mm:ss)',
                errorText: (_lightTimeSchedule.text == '')
                    ? null
                    : _validateTime(_lightTimeSchedule.text),
              ),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.plant.id != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.plant.id != null) {
                  plantsReference
                      .child('plants')
                      .child(widget.uid)
                      .child(widget.plant.id)
                      .set({
                    'name': _titleController.text,
                    'species': _descriptionController.text,
                    'waterTime': _waterTimeSchedule.text,
                    'lightTime': _lightTimeSchedule.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  plantsReference.child('plants').child(widget.uid).push().set({
                    'name': _titleController.text,
                    'species': _descriptionController.text,
                    'waterTime': _waterTimeSchedule.text,
                    'lightTime': _lightTimeSchedule.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
