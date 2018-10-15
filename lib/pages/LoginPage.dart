import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/components/logo.dart';


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
  FormType _formType = FormType.login;
  bool _userExist = true;

  checkUserValue<bool>(String user) {
    _doesNameAlreadyExist(user).then((val){
      if(val){
        print ("UserName Already Exits");
        _userExist = val;
        print (_userExist);
      }
      else{
        print ("UserName is Available");
        _userExist = val;
      }

    });

    return _userExist;

  }


  Future<bool> _doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where('username', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }





  bool validateAndSave() {
    final form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: ${userId}');
        } else {


          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered on Firebase: ${userId}');
          String stringDocumentName = userId;
          Firestore.instance.collection('user').document(stringDocumentName).setData(
            {
              'user_id': '$userId',
              'username': '$_username',
              'email': '$_email',
            }
          );
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Image(
              image: new AssetImage('assets/dogood_logo.png'),
              width: 350.0,
              height: 400.0,
            ),
            new Center(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                      onPressed: moveToLogin,
                      color: getColorLogin(_formType),
                      child: new Text("Login", style: new TextStyle(color: Colors.white),)),
                  new RaisedButton(
                      color: getColorRegister(_formType),
                      onPressed: moveToRegister,
                      child: new Text("Register", style: new TextStyle(color: Colors.white),)),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.all(16.0),
              child: new Form(
                key: _formKey,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildUsernameField() + buildInputs() + buildSubmitButtons(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          decoration: new InputDecoration(labelText: 'Username'),
          validator: (value) => checkUserValue(value) ? "Username already taken" : null,
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
          onPressed: validateAndSubmit,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text(
            'Create Account',
            style: new TextStyle(fontSize: 15.0),
          ),
          onPressed: validateAndSubmit,
        ),

      ];
    }
  }
}
