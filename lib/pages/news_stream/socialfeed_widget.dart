import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/respect/RespectWidget.dart';

class SocialFeedWidget extends StatelessWidget {

  final String article_header;
  final String userName;
  final double spectrumValue;
  final String comment;
  final String fullName;
  final String user_id;
  final String postID;
  final String posterID;
  final bool filter;

  SocialFeedWidget({this.article_header, this.userName, this.spectrumValue, this.comment, this.fullName, this.user_id, this.postID, this.posterID, this.filter});

  Future totalLikes(postID) async {
    var respectsQuery = Firestore.instance
        .collection('respects')
        .where('postID', isEqualTo: postID);
    var querySnapshot = await respectsQuery.getDocuments();
    var totalEquals = querySnapshot.documents.length;
    return totalEquals;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildHeader() + buildPosts(),
        ),
      );
  }

  List<Widget> buildHeader() {
    if (filter == false) {
      return [
        new Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          alignment: Alignment.topLeft,
          child: new Text(
            article_header,
            style: new TextStyle(color: Colors.purple, fontSize: 18.0),
            textAlign: TextAlign.left,
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> buildPosts() {
    return [

      new Row(
        children: <Widget>[
          new Container(
              child: new Expanded(child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("$fullName",
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    "@$userName",
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),)
          ),

          new Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: new Row(
              children: <Widget>[
                new Slider(
                  value: spectrumValue,
                  onChanged: print,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.red,
                  divisions: 100,
                  max: 10.0,
                  min: 0.0,
                ),
              ],
            ),
          ),
        ],
      ),
      new Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        alignment: Alignment.topLeft,
        child: new Text(
          comment,
          style: new TextStyle(
            color: Color.fromRGBO(74, 74, 74, 1.0),
          ),
        ),
      ),
      new Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          alignment: Alignment.bottomRight,
          child: new RespectWidget(postID: '$postID', respecterID: '$posterID',)
      ),
      new Padding(
        child: new Divider(
          color: Color.fromRGBO(74, 74, 74, 1.0),
        ),
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      ),
    ];
  }
}
