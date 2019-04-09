import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_vibez/root_page.dart';
import 'package:plant_vibez/auth.dart';

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
        }
        widget.onSignedIn();
      } catch (e) {
        setNotification(
            "Email or password has not been registerred or wrongly typed");
        print('Error: $e');
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
//                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[SizedBox(height: 20.0,),
                    Image.asset('images/background.jpg', height: MediaQuery.of(context).size.height/1.8,), _showBody(),],
                  ),
                ],
              )
            ),
          ],
        ));
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 12.0),
      TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButton() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text(
            'Login',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
            onPressed: moveToRegister,
            child: new Text(
              'Create Account',
              style: new TextStyle(fontSize: 20.0),
            )),
        new Text(
          _notification,
          style: TextStyle(color: Colors.red),
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text(
            'Create an account',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
            onPressed: moveToLogin,
            child: new Text(
              'Have an account? Login',
              style: new TextStyle(fontSize: 20.0),
            )),
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
