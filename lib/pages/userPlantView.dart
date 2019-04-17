import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_vibez/Object/Plant.dart';
import 'package:plant_vibez/pages/PlantDescription.dart';

class PlantListView extends StatefulWidget {
  final String uid;

  const PlantListView({Key key, this.uid}) : super(key: key);
  @override
  _PlantListViewState createState() => new _PlantListViewState();
}


class _PlantListViewState extends State<PlantListView> {
  List<Plant> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;
  DatabaseReference plantsReference;

  @override
  void initState() {
    super.initState();
    items = new List();
    plantsReference = FirebaseDatabase.instance.reference().child('plants').child(widget.uid);
    _onNoteAddedSubscription = plantsReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription = plantsReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Plants',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Plants'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0
                        ),
                        child: Text(
                          '${items[position].name}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            'Water Time: ${items[position].waterTime}',
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'Light Time: ${items[position].lightTime}',
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      leading: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.lightGreen,
                            radius: 12.0,
                            child: Text(
                              '${position + 1}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deleteNote(context, items[position], position)),
                        ],
                      ),
                      onTap: () => _navigateToNote(context, items[position]),
                    ),
                    Divider(height: 5.0),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          child: Icon(Icons.add),
          onPressed: () => _createNewNote(context),
        ),
      ),
    );
  }

  void _onNoteAdded(Event event) {
    setState(() {
      items.add(new Plant.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue = items.singleWhere((plant) => plant.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] = new Plant.fromSnapshot(event.snapshot);
    });
  }

  void _deleteNote(BuildContext context, Plant plant, int position) async {
    await plantsReference.child(plant.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, Plant plant) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDescription(plant, widget.uid)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDescription(Plant(null, '', '', '',''), widget.uid)),
    );
  }
}
