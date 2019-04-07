import 'package:flutter/material.dart';
import 'package:plant_vibez/pages/AddPlant.dart';
import 'package:plant_vibez/pages/Settings.dart';
import 'package:plant_vibez/pages/Information.dart';
import 'package:plant_vibez/Object/Plant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_vibez/auth.dart';
import 'package:plant_vibez/pages/Help.dart';
import 'package:plant_vibez/pages/PlantList.dart';


//generate default Plant Object
List<DefaultPlant> generate(){
  final links = [
    "images/houseplants.jpg",
    "images/mushroom.jpg",
    "images/succulent.jpg",
    "images/flowers.jpg"
  ];

  final text = ["houseplants", "mushroom", "succulent", "flowers"];
  final itemCount = 4;
  final List<DefaultPlant> plants = new List();

  for (int i = 0; i < itemCount; i++) {
    plants.add(new DefaultPlant(links[i], text[i]));
  }

  return plants;
}

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  HomePage(this.auth,this.onSignedOut);

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

class _HomePageState extends State<HomePage>{

  FirebaseUser user;
  String email;
  String uid;

  void getUser(){
    widget.auth.currentUser().then((FirebaseUser user){
      setState(() {
        this.user = user;
        this.email = user.email;
        this.uid = user.uid;
      });
    });
  }

  void _signedOut() async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }catch(e){
      print(e);
    }
  }

  List<DefaultPlant> plants = generate();

  @override
  Widget build(BuildContext context) {
    generate();
    getUser();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Your plants"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
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
      ),
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
              leading: new Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Help()),
                );
              },
            ),
            ListTile(
              leading: new Icon(Icons.list),
              title: Text('Plant List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JsonPlantList()),
                );
              },
            ),
            ListTile(
              leading: new Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
            ListTile(
                leading: new Icon(Icons.add_box),
                title: Text('AddPlantPage'),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlantPage()),
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
        ),
      ),
    );
  }

}