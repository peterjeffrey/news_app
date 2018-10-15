import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/pages/settings.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Welcome"),
        actions: <Widget>[
          new FlatButton(
              onPressed: null,
              child: new Icon(Icons.settings,),
          )
        ],
      ),
      body: new Container(
        child: new Center(
          child: new StreamBuilder(
            stream: Firestore.instance.collection('newsdays').snapshots(),
              builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Loading...");
              return new Text(snapshot.data.documents[0]['name']);
              }
              ),
        ),
      ),
    );
  }
}
