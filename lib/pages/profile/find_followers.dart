import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';


class AddFollowers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: new Text("Find Your Following"),
      ),
      body: new Text('Peter'),

    );
  }
}

