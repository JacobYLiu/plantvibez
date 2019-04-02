import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:plant_vibez/pages/LoginPage.dart';
import 'package:plant_vibez/pages/HomePage.dart';

class RootPage extends StatefulWidget{

  final BaseAuth auth;

  RootPage(this.auth);

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage>{

  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        _authStatus = (userId == null) ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(widget.auth, _signedIn);
      case AuthStatus.signedIn:
        return new HomePage(widget.auth, _signedOut);
    }
  }
}