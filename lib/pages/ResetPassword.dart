import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/components/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ResetPassword extends StatefulWidget {
  ResetPassword({this.auth});
  final BaseAuth auth;


  @override
  State<StatefulWidget> createState() => new _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  bool _emailValidator = false;
  TextEditingController _emailController = new TextEditingController();

  Future checkEmail() async {
    var email = await Firestore.instance
        .collection('emails')
        .document(_emailController.text)
        .get();
    print(widget.auth);
    return !email.exists;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reset Password"),
        elevation: 0.0,
      ),
      body: new Padding(
        padding: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Text(
                "To reset your email, please provide an email for the account."),
            new Form(
              key: _formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new TextFormField(
                    controller: _emailController,
                    decoration: new InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                    _emailValidator ? "Email does not exist - please create a new account" : null,
                    onSaved: (value) => _email = value,
                  ),
                  new RaisedButton(
                    color: Color.fromRGBO(100, 45, 200, 1.0),
                    child: new Text(
                      'Reset Password',
                      style: new TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                    onPressed: () async {
                      var response = await checkEmail();
                      setState(() {
                        this._emailValidator = response;
                      });
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        try {
                          await widget.auth
                              .sendPasswordResetEmail("$_email");
                          } catch (e) {
                          print(e);
                        }
                      }

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
