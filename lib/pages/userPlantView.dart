import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_vibez/Object/Plant.dart';
import 'package:plant_vibez/pages/PlantDescription.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PlantListView extends StatefulWidget {
  final String uid;

  const PlantListView({Key key, this.uid}) : super(key: key);

  @override
  _PlantListViewState createState() => new _PlantListViewState();
}

class _PlantListViewState extends State<PlantListView> {
  List<Plant> items = new List();
  StreamSubscription<Event> _onPlantAddedSubscription;
  StreamSubscription<Event> _onPlantChangedSubscription;
  DatabaseReference plantsReference;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  int index = 0;

  @override
  void initState() {
    super.initState();
    plantsReference =
        FirebaseDatabase.instance.reference().child('plants').child(widget.uid);
    _onPlantAddedSubscription =
        plantsReference.onChildAdded.listen(_onPlantAdded);
    _onPlantChangedSubscription =
        plantsReference.onChildChanged.listen(_onPlantUpdated);

    //setting up notification plugin
    var android = new AndroidInitializationSettings('images/background.jpg');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);
  }

  @override
  void dispose() {
    _onPlantAddedSubscription.cancel();
    _onPlantChangedSubscription.cancel();
    super.dispose();
  }

  Future selectNotification(String payload) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  pushNotification(Plant plant, int i) async {
    List<String> wTimes = new List();
    List<String> lTimes = new List();
    var temp = plant.waterTime.split(':');
    if(temp.length > 0){
      for(int i = 0; i < temp.length;i++){
        wTimes.add(temp[i]);
      }
    }
    temp = plant.lightTime.split(':');
    if(temp.length > 0){
      for(int i = 0; i < temp.length;i++){
        lTimes.add(temp[i]);
      }
    }
    Time wTime =
        (wTimes.length != 3) ? null : new Time(int.parse(wTimes[0]), int.parse(wTimes[1]), int.parse(wTimes[2]));
    Time lTime =
        (lTimes.length != 3) ? null : new Time(int.parse(lTimes[0]), int.parse(lTimes[1]), int.parse(lTimes[2]));

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        plant.id, 'PlantVibez', 'Notification for plants water and lights');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (wTime != null) {
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          i*2,
          'Daily Notification!',
          'Water your ${plant.name}!!!!',
          wTime,
          platformChannelSpecifics,payload: 'Your daily notification for watering ${plant.name} everyday at ${wTime.hour}:${wTime.minute}:${wTime.second}');
      print('add notification id : ${i*2}');
    }
    if (lTime != null) {
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          i*2 + 1,
          'Daily Notification!',
          'Light your ${plant.name}!!!!',
          lTime,
          platformChannelSpecifics,payload: 'Your daily notification for lighting ${plant.name} everyday at ${lTime.hour}:${lTime.minute}:${lTime.second}');
      print('add notification id: ${i*2 + 1}');
    }
    await flutterLocalNotificationsPlugin.show(
        1999,
        'PlantVibez Notification',
        'Your plants has been set up notification for watering and lighting',
        platformChannelSpecifics, payload: 'Your plant has been set up notification for watering and lighting');
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            'Water Time: ${items[position].waterTime.toString()}',
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'Light Time: ${items[position].lightTime.toString()}',
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
                              onPressed: () => _deletePlant(
                                  context, items[position], position)),
                        ],
                      ),
                      onTap: () => _navigateToPlant(context, items[position]),
                    ),
                    Divider(height: 5.0),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          child: Icon(Icons.add),
          onPressed: () => _createNewPlant(context),
        ),
      ),
    );
  }

  void _onPlantAdded(Event event) async {
    Plant newPlant = new Plant.fromSnapshot(event.snapshot);
    setState(() {
      pushNotification(newPlant, index);
      items.add(newPlant);
      index++;
    });
  }

  void _onPlantUpdated(Event event) async {
    var oldPlant = items.singleWhere((plant) => plant.id == event.snapshot.key);
    int i = items.indexOf(oldPlant);
    var updatedPlant = new Plant.fromSnapshot(event.snapshot);
    flutterLocalNotificationsPlugin.cancel(i * 2);
    print('delete notification id: ${i*2}');
    flutterLocalNotificationsPlugin.cancel(i * 2 + 1);
    print('delete notification id: ${i*2 + 1}');
    await pushNotification(updatedPlant, i);
    setState(() {
      items[items.indexOf(oldPlant)] = updatedPlant;
    });
  }

  void _deletePlant(BuildContext context, Plant plant, int position) async {
    await flutterLocalNotificationsPlugin.cancel(position * 2);
    print('delete notification id: ${position *2}');
    await flutterLocalNotificationsPlugin.cancel(position * 2 + 1);
    print('delete notification id: ${position * 2 + 1}');
    await plantsReference.child(plant.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
        index--;
      });
    });
  }

  void _navigateToPlant(BuildContext context, Plant plant) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlantDescription(plant, widget.uid)),
    );
  }

  void _createNewPlant(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PlantDescription(Plant(null, '', '', '', ''), widget.uid)),
    );
  }
}
