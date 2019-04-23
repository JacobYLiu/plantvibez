import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_vibez/root_page.dart';
import 'package:plant_vibez/auth.dart';
import 'package:flutter/cupertino.dart';


class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}



class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  LoginPage(this.auth, this.onSignedIn);

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _notification = '';

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid. Email : $_email, password: $_password');
      return true;
    } else {
      print('Form is invalid');
      return false;
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    resetNotification();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    resetNotification();
    setState(() {
      _formType = FormType.login;
    });
  }

  void validateAndSubmit() async {
    resetNotification();
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          String userId = user.uid;
          print('Signed in: $userId');
          if (!user.isEmailVerified) {
            setNotification("Email has not been verified");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RootPage(widget.auth)),
            );
          }
        } else {
          FirebaseUser user = await widget.auth
              .createUserWithEmailAndPassword(_email, _password)
              .then((FirebaseUser user) {
            user.sendEmailVerification();
          });
          print('Registered user : ${user.uid}');
          setNotification('Registerred successfully!!');
        }
        widget.onSignedIn();
      } catch (e) {
        if (e.runtimeType.toString() == 'PlatformException') {
          setNotification(e.toString());
        }
        print('Error: ' + e.toString());
      }
    }
  }

  Widget _showBody() {
    return new Form(
        key: formKey,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildInputs() + buildSubmitButton(),
        ));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            SafeArea(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 35.0),
              children: <Widget>[
                SizedBox(height: 50.0,),
                SizedBox(
                  height: 200.0,
                  child: Image.asset(
                    "images/login_image.png",
                    fit: BoxFit.contain,
                  ),
                ),
                _showBody(),
              ],
            )),
          ],
        ));
  }

  List<Widget> buildInputs() {
    return [
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            hintText: 'abc@gmail.com',
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Icon(Icons.email),
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 12.0),
      TextFormField(
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Icon(Icons.security),
            ),
            hintText: 'At least 6 characters'),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
      SizedBox(
        height: 12.0,
      ),
    ];
  }

  List<Widget> buildSubmitButton() {
    if (_formType == FormType.login) {
      return [
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: validateAndSubmit,
            child: Text("Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff95c4fe),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: moveToRegister,
            child: Text("Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 20.0,),
        new Text(
          _notification,
          style: TextStyle(color: Colors.red),
        ),
      ];
    } else {
      return [
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: validateAndSubmit,
            child: Text("Create an account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff95c4fe),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: moveToLogin,
            child: Text("Have an account? Login!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 20.0,),
        new Text(_notification, style: TextStyle(color: Colors.red)),
      ];
    }
  }

  void setNotification(String _notification) {
    setState(() {
      this._notification = _notification;
    });
  }

  void resetNotification() {
    setState(() {
      this._notification = '';
    });
  }
}
