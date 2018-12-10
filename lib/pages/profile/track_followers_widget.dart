import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrackFollowerWidget extends StatefulWidget {

  TrackFollowerWidget({this.name, this.username, this.userID, this.otherUserID});
  final String name;
  final String username;
  final String userID;
  final String otherUserID;

  @override
  TrackFollowerWidgetState createState() => TrackFollowerWidgetState();

}

class TrackFollowerWidgetState extends State<TrackFollowerWidget> {
  TrackFollowerWidgetState();
  bool _blockMe;

  @override
  void initState() {
    _blockMe = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 40.0, 5.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    widget.name,
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  new Text(
                    "@" + widget.username,
                    style: new TextStyle(
                      color: Colors.grey,
                    ),
                  )],
              ),
              new Column(
                children: <Widget>[
                  buildFollowButtons(),
                ],
              )
            ],
          ),
          new Divider(height: 40.0,color: Colors.grey,),
        ],
      ),
    );
  }

  Widget buildFollowButtons() {
    if (_blockMe == false) {
      return new RaisedButton(
          child: new Text(
            "Block",
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          color: Color.fromRGBO(208, 2, 27, 1.0),
          onPressed: () {
            toggleFollower();
            Firestore.instance
                .collection('relationships')
                .document(widget.userID).collection('followers').document(widget.otherUserID)
                .setData({
              'follower': false,
              'followerID': widget.otherUserID,
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.otherUserID).collection('following').document(widget.userID)
                .setData({
              'following': false,
              'followingID': widget.userID,
            });
          }
      );
    }
    else {
      return new RaisedButton(
          child: new Text(
            "Unblock",
            style: new TextStyle(
              color: Color.fromRGBO(208, 2, 27, 1.0),
            ),
          ),
          color: Colors.white,
          onPressed: () {
            toggleFollower();
            Firestore.instance
                .collection('relationships')
                .document(widget.userID).collection('followers').document(widget.otherUserID)
                .setData({
              'follower': true,
              'followerID': widget.otherUserID,
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.otherUserID).collection('following').document(widget.userID)
                .setData({
              'following': true,
              'followingID': widget.userID,
            });
          }
      );
    }

  }

  void toggleFollower() {
    if (_blockMe == false){
      setState(() {
        _blockMe = true;
      });
    }
    else {
      setState(() {
        _blockMe = false;
      });
    }

  }
}
