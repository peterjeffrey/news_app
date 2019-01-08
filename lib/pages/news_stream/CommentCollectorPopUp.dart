import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/CommentCollector.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';
import 'package:news_app/pages/profile/track_followers.dart';
import 'package:news_app/pages/profile/track_following.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/FireNewsView.dart';

class CommentCollectorPopUp extends StatelessWidget {

  final String articleID;
  final String articleDate;
  final String articleTitle;
  final String userName;
  final String firstName;
  final String lastName;
  final String user_id;
  const CommentCollectorPopUp(
      {Key key, this.articleID, this.articleTitle, this.userName, this.firstName, this.lastName, this.user_id, this.articleDate})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(
                context
            );
          },
        ),
      ),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: new Column(
              children: <Widget>[
                new Text(articleTitle, style:new TextStyle(fontSize: 20.0) ,),
                new CommentCollector(
                  firstName: firstName,
                  userName: userName,
                  user_id: user_id,
                  lastName: lastName,
                  articleDate: articleDate,
                  articleTitle: articleTitle,
                  articleID: articleID,
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
