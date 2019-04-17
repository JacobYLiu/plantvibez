import 'package:flutter/material.dart';
import 'package:plant_vibez/pages/takePhoto.dart';
import 'package:plant_vibez/pages/Information.dart';
import 'package:plant_vibez/Object/Plant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_vibez/auth.dart';
import 'package:plant_vibez/pages/PlantList.dart';
import 'package:plant_vibez/pages/userPlantView.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


//generate default Plant Object
List<Plant> generate() {
  final links = [
    "images/houseplants.jpg",
    "images/mushroom.jpg",
    "images/succulent.jpg",
    "images/flowers.jpg"
  ];

  final text = ["houseplants", "mushroom", "succulent", "flowers"];
  final itemCount = 4;
  final List<Plant> plants = new List();

  for (int i = 0; i < itemCount; i++) {
    Plant plant = new Plant(null, text[i], text[i], '', '');
    plant.imageLink = links[i];
    plants.add(plant);
  }

  return plants;
}

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  HomePage(this.auth, this.onSignedOut);

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

//AboutText
Widget _buildAboutText(BuildContext context) {
  return new AlertDialog(
    title: Text("About"),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Plant_Vibez_Demov v1.0 \n"),
        Text(
            "By Ben Pallan, Shane Valderama, Stephen Gutierrez, Jacob Liu, Nhan Le "),
      ],
    ),
  );
}

class _HomePageState extends State<HomePage> {

  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('background');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  String uid;
  String userEmail;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool showNotification = true;

  void getUser() {
    widget.auth.currentUser().then((FirebaseUser user) {
      setState(() {
        this.uid = user.uid;
        this.userEmail = user.email;
      });
    });
  }

  void _signedOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  List<Plant> plants = generate();

  @override
  Widget build(BuildContext context) {
    _showDefaultNotification();
    generate();
    getUser();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Your plants"),
        backgroundColor: Colors.lightGreen,
      ),
      body: _showDefaultList(plants),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new SizedBox(
              height: 90,
              child: new DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                ),
              ),
            ),
            ListTile(
              leading: new Icon(Icons.list),
              title: Text('Browse Plants'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlantListHelp(uid: this.uid,)),
                );
              },
            ),
            ListTile(
              leading: new Icon(Icons.person_pin),
              title: Text('Your Plants'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlantListView(uid: this.uid,)),
                );
              },
            ),
            ListTile(
                leading: new Icon(Icons.add_box),
                title: Text('Take Picture'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => takePhoto()),
                  );
                }
            ),
            ListTile(
              leading: new Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildAboutText(context),
                );
              },
            ),
            ListTile(
              leading: new Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: _signedOut,
            ),
          ],
        ),)
      ,

    );
  }

  Widget _showDefaultList(List<Plant> plants) {
    return Center(
      child: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, position) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(plants[position].imageLink),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Information(plant: plants[position])),
                );
              },
            ),
          );
        },
      ),
    );
  }
  
  Future _showDefaultNotification() async {
    if(showNotification){
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'id', 'plantvibez', 'For your plants',
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Greeting',
          (TimeOfDay.now().hour > TimeOfDay(hour: 12, minute: 0).hour) ?  'Good Aftertoon ' + userEmail : 'Good morning ' + userEmail,
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    }
    showNotification = false;
  }
}