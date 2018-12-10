import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrackFollowingWidget extends StatefulWidget {

  TrackFollowingWidget({this.name, this.username, this.userID, this.otherUserID});
  final String name;
  final String username;
  final String userID;
  final String otherUserID;

  @override
  TrackFollowingWidgetState createState() => TrackFollowingWidgetState();

}

class TrackFollowingWidgetState extends State<TrackFollowingWidget> {
  TrackFollowingWidgetState();
  bool _unfollowMe;

  @override
  void initState() {
    _unfollowMe = false;
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
    if (_unfollowMe == false) {
      return new RaisedButton(
          child: new Text(
            "Unfollow",
            style: new TextStyle(
              color: Color.fromRGBO(100, 45, 200, 1.0),
            ),
          ),
          color: Colors.white,
          onPressed: () {
            toggleFollower();
            Firestore.instance
                .collection('relationships')
                .document(widget.userID).collection('following').document(widget.otherUserID)
                .setData({
              'following': false,
              'followingID': widget.otherUserID,
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.otherUserID).collection('followers').document(widget.userID)
                .setData({
              'follower': false,
              'followerID': widget.userID,
            });
          }
      );
    }
    else {
      return new RaisedButton(
          child: new Text(
            "Follow",
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          color: Color.fromRGBO(100, 45, 200, 1.0),
          onPressed: () {
            toggleFollower();
            Firestore.instance
                .collection('relationships')
                .document(widget.userID).collection('following').document(widget.otherUserID)
                .setData({
              'following': true,
              'followingID': widget.otherUserID,
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.otherUserID).collection('followers').document(widget.userID)
                .setData({
              'follower': true,
              'followerID': widget.userID,
            });
          }
      );
    }

  }

  void toggleFollower() {
    if (_unfollowMe == false){
      setState(() {
        _unfollowMe = true;
      });
    }
    else {
      setState(() {
        _unfollowMe = false;
      });
    }

  }
}
