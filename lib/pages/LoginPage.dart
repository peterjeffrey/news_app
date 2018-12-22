import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/components/logo.dart';
import 'package:news_app/pages/ResetPassword.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _username;
  String _firstName;
  String _lastName;
  FormType _formType = FormType.login;
  bool _usernameValidator = false;
  TextEditingController _usernameController = new TextEditingController();

  Future checkUser() async {
    var user = await Firestore.instance
        .collection('usernames')
        .document(_usernameController.text)
        .get();
    return user.exists;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                  child: new Image(
                    image: new AssetImage('assets/dogood_logo.png'),
                    width: 350.0,
                    height: 200.0,
                  ),
                ),
                new Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                          onPressed: moveToLogin,
                          color: getColorLogin(_formType),
                          child: new Text(
                            "Login",
                            style: new TextStyle(color: Colors.white),
                          )),
                      new RaisedButton(
                          color: getColorRegister(_formType),
                          onPressed: moveToRegister,
                          child: new Text(
                            "Register",
                            style: new TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Form(
                    key: _formKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildUsernameField() +
                          buildInputs() +
                          buildSubmitButtons() +
                          buildPasswordReset(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPasswordReset() {
    return [
      new Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: new InkWell(
          onTap: () => Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                new ResetPassword(auth: widget.auth,),
                ),
          ),
          child: new Text(
            "Reset Password? Click here.",
            style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),

    ];
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? "Email can't be empty." : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? "Password can't be empty." : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildUsernameField() {
    if (_formType == FormType.register) {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'First Name'),
          validator: (value) =>
              value.isEmpty ? "Please submit your first name." : null,
          onSaved: (value) => _firstName = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Last Name'),
          validator: (value) =>
              value.isEmpty ? "Please submit your last name." : null,
          onSaved: (value) => _lastName = value,
        ),
        new TextFormField(
          controller: _usernameController,
          decoration: new InputDecoration(labelText: 'Username'),
          validator: (value) =>
              _usernameValidator ? "Username already taken" : null,
          onSaved: (value) => _username = value,
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
            child: new Text(
              'Login',
              style: new TextStyle(fontSize: 15.0),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                try {
                  String userId = await widget.auth
                      .signInWithEmailAndPassword(_email, _password);
                  print('Signed in: ${userId}');
                  widget.onSignedIn();
                } catch (e) {
                  print(e);
                }
              }
            }),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text(
            'Create Account',
            style: new TextStyle(fontSize: 15.0),
          ),
          onPressed: () async {
            var response = await checkUser();
            setState(() {
              this._usernameValidator = response;
            });
            String name = _usernameController.text;
            print('This is the $name');

            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              try {
                String userId = await widget.auth
                    .createUserWithEmailAndPassword(_email, _password);
                print('Registered on Firebase: ${userId}');
                String stringDocumentName = userId;
                Firestore.instance
                    .collection('user')
                    .document(stringDocumentName)
                    .setData({
                  'user_id': '$userId',
                  'username': '$_username',
                  'email': '$_email',
                  'first_name': '$_firstName',
                  'last_name': '$_lastName',
                  'time': new DateTime.now(),
                });
                Firestore.instance
                    .collection('usernames')
                    .document('$_username')
                    .setData({
                  'user_id': '$userId',
                });
                Firestore.instance
                    .collection('emails')
                    .document('$_email')
                    .setData({
                  'user_id': '$userId',
                });
                Firestore.instance
                    .collection('relationships')
                    .document('$userId').collection('followers').document('$userId')
                    .setData({
                  'followerID': '$userId',
                  'follower': true,
                });
                Firestore.instance
                    .collection('relationships')
                    .document('$userId').collection('following').document('$userId')
                    .setData({
                  'followingID': '$userId',
                  'following': true,
                });
                widget.onSignedIn();
              } catch (e) {
                print(e);
              }
            }
          },
        ),
      ];
    }
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  Color getColorLogin(FormType formtype) {
    if (formtype == FormType.login) {
      return Color.fromRGBO(144, 19, 254, 1.0);
    } else {
      return Colors.grey;
    }
  }

  Color getColorRegister(FormType formtype) {
    if (formtype == FormType.register) {
      return Color.fromRGBO(144, 19, 254, 1.0);
    } else {
      return Colors.grey;
    }
  }
}
