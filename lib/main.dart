import 'package:flutter/material.dart';
import 'root_page.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter login demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: new RootPage(new Auth()),
    );
  }
}

//project by PlantVibez team