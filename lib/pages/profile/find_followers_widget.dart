import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';

//Widget notes: commented out the stateful elements because of issues with building the list with a negative list
//probably should convert this to stateless widget

class FindFollowerWidget extends StatefulWidget {
  FindFollowerWidget(
      {this.name,
      this.username,
      this.userID,
      this.otherUserID,
      this.sessionUsername});
  final String name;
  final String username;
  final String userID;
  final String otherUserID;
  final String sessionUsername;

  @override
  FindFollowerWidgetState createState() => FindFollowerWidgetState();
}

class FindFollowerWidgetState extends State<FindFollowerWidget> {
  FindFollowerWidgetState();
  bool _followMe;

  @override
  void initState() {
    _followMe = false;
  }

  @override
  Widget build(BuildContext context) {
    print("other userID is" + widget.otherUserID);
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
                  )
                ],
              ),
              new Column(
                children: <Widget>[
                  buildFollowButtons(),
                ],
              )
            ],
          ),
          new Divider(
            height: 40.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget buildFollowButtons() {
    if (_followMe == false) {
      return new RaisedButton(
          child: new Text(
            "Follow",
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          color: purpleColor(),
          onPressed: () {
            toggleFollower();
//            Firestore.instance
//                .collection('notifications')
//                .document('notifications')
//                .collection(widget.otherUserID)
//                .document('test')
//                .setData({
//              'date': DateTime.now(),
//              'other_userID': widget.userID,
//              'other_username': "@" + widget.sessionUsername,
//              'seen': false,
//              'type': 'follow',
//            });
            Firestore.instance
                .collection('notifications')
                .document('notifications')
                .collection(widget.otherUserID)
                .document(DateTime.now().toString() + widget.otherUserID)
                .setData({
              'date': new DateTime.now(),
              'other_userID': widget.userID,
              'other_username': '@' + widget.sessionUsername,
              'seen': false,
              'type': 'follow',
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.userID)
                .collection('following')
                .document(widget.otherUserID)
                .setData({
              'following': true,
              'followingID': widget.otherUserID,
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.otherUserID)
                .collection('followers')
                .document(widget.userID)
                .setData({
              'follower': true,
              'followerID': widget.userID,
            });

          });
    } else {
      return new RaisedButton(
          child: new Text(
            "Follow",
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          color: purpleColor(),
          onPressed: () {
            toggleFollower();
            Firestore.instance
                .collection('relationships')
                .document(widget.userID)
                .collection('following')
                .document(widget.otherUserID)
                .setData({
              'following': false,
              'followingID': widget.otherUserID,
            });
            Firestore.instance
                .collection('relationships')
                .document(widget.otherUserID)
                .collection('followers')
                .document(widget.userID)
                .setData({
              'follower': false,
              'followerID': widget.userID,
            });
          });
    }
  }

  void toggleFollower() {
    if (_followMe == false) {
      setState(() {
        _followMe = true;
      });
    } else {
      setState(() {
        _followMe = false;
      });
    }
  }
}
