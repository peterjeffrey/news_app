import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/pages/news_stream/FirePageCreator.dart';
import 'package:news_app/pages/PageCreator.dart';


class FireNewsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('newsdays').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator(),);
          final int newsdayCount = snapshot.data.documents.length;
          final String name = newsdayCount.toString();
          print("There are $name total newsdays");
          return new FirePageCreator(nameOfNewsday: name);
        },
      ),
    );
  }
}
