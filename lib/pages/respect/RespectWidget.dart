import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RespectWidget extends StatefulWidget {
  RespectWidget({this.postID, this.respecterID});
  String postID;
  String respecterID;

  @override
  RespectWidgetState createState() =>
      RespectWidgetState(postID: postID, respecterID: respecterID);
}

class RespectWidgetState extends State<RespectWidget> {
  RespectWidgetState({this.postID, this.respecterID});

  String respecterID;
  String postID;
  bool _result;
  int _totalRespects;

  Future isLiked(searchThis) async {
    var user = await Firestore.instance
        .collection('respects')
        .document(searchThis)
        .get();

    return user.exists;
  }

  Future totalLikes(postID) async {
    var respectsQuery = Firestore.instance
        .collection('respects')
        .where('postID', isEqualTo: postID);
    var querySnapshot = await respectsQuery.getDocuments();
    var totalEquals = querySnapshot.documents.length;
    return totalEquals;
  }


  @override
  void initState() {
    isLiked(postID + "_" + respecterID).then((result) {

      if (this.mounted){
        setState(() {
          _result = result;
        });
      }


    });

    totalLikes(postID).then((result) {

      if (this.mounted){
        setState(() {
          _totalRespects = result;
        });
      }

    });


  }

  @override
  Widget build(BuildContext) {
    if (_result == true) {
      return new GestureDetector(
        onTap: () async {
          Firestore.instance
              .collection('respects')
              .document(postID + "_" + respecterID)
              .delete()
              .catchError((e) {
            print(e);
          });
          setState(() {
            this._totalRespects = _totalRespects - 1;
            this._result = false;
          });
        },
        child: new Row(
          children: <Widget>[

            new Icon(
              Icons.star,
              color: Color.fromRGBO(100, 45, 200, 1.0),
            ),
            new Text(_totalRespects.toString()),
          ],
        ),
      );
    } else {
      return new GestureDetector(
        onTap: () {
          Firestore.instance
              .collection('respects')
              .document(postID + "_" + respecterID)
              .setData({
            'repecterID': '$respecterID',
            'postID': '$postID',
            'time': new DateTime.now(),
          });
          setState(() {
            this._totalRespects = _totalRespects + 1;
            this._result = true;
          });
        },
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.star,
              color: Colors.grey,
            ),
            new Text(_totalRespects.toString()),
          ],
        ),
      );
    }
//    return new StreamBuilder(
//      stream: Firestore.instance
//          .collection('post')
//          .document(documentField).snapshots(),
//    builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return Text('no Data');
//    }
//    else {
//          return Text('Liked!');
//
//    }
  }
}
