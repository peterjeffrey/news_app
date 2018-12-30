import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';
import 'package:news_app/pages/profile/track_followers.dart';
import 'package:news_app/pages/profile/track_following.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/FireNewsView.dart';

class ConfirmReport extends StatelessWidget {

  final String username;
  final String content;
  final String postID;
  final String reportingUserID;


  ConfirmReport({Key key, this.username, this.content, this.reportingUserID, this.postID});


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
            padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
            child: new Column(
              children: <Widget>[
                new Text("Are you sure you wish to report this content by @$username?", style:new TextStyle(fontSize: 20.0) ,),
                new Padding(padding: EdgeInsets.all(15.0),
                  child: new Text(content),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RaisedButton(
                      color: purpleColor(),
                        onPressed: () {
                          Firestore.instance
                              .collection('content_flags')
                              .document(postID + "_" + reportingUserID)
                              .setData({
                            'postID': postID,
                            'reporter': reportingUserID,
                            'time': new DateTime.now(),
                          });
                          Navigator.pop(
                              context
                          );
                        },
                      child: new Text("Yes", style: new TextStyle(color: Colors.white),),
                    ),
                    new RaisedButton(onPressed: () =>  Navigator.pop(
                        context
                    ),
                    child: new Text("No"),)
                  ],
                ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
