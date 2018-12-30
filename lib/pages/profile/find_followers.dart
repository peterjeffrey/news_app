import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/objects/UserFollower.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';
import 'package:news_app/pages/profile/find_followers_search.dart';
import 'package:news_app/pages/profile/find_followers_widget.dart';

class AddFollowers extends StatelessWidget {

  AddFollowers({this.userID});
  final String userID;
//  final String userId = '5lCAtUmFEybRqWE0czBYqq6St1s2';
  List<String> followingList = [];
  List<UserFollower> prospectiveFollowers = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {

//                var listToPass = [UserFollower("Peter", "PJ"), UserFollower("Jonathan", "JJ")];
                showSearch(context: context, delegate: FindFollowersSearch(friendsList: prospectiveFollowers));
              }
          ),
        ],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: new Text("Find Your Following"),
      ),

      body: new Container(
        child: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('relationships')
                .document(userID)
                .collection('following')
                .where("following", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return new Text("Error!");
              } else if (snapshot.data == null) {
                return new Text("Null");
              } else {
                for (var i = 0; i < snapshot.data.documents.length; i++) {
                  followingList
                      .add(snapshot.data.documents[i]['followingID'].toString());
                }
                return new FutureBuilder(
                    future: Firestore.instance
                        .collection('user')
                        .getDocuments(),
                    builder: (BuildContext context, AsyncSnapshot snapshot2) {
                      if (snapshot2.hasData) {
                        if (snapshot2.data != null) {
                          prospectiveFollowers.clear();
                          return new Column(
                            children: <Widget>[
                              new Expanded(
                                child: new ListView(
                                  children: snapshot2.data.documents.where((document)=> !followingList.contains(document["user_id"]))
                                      .map<Widget>((DocumentSnapshot document) {
                                    prospectiveFollowers.add(
                                          UserFollower(
                                            document['first_name'] + " " + document['last_name'],
                                            document['username'],
                                            document['user_id'],
                                            userID,
                                          )
                                        );
                                          return new FindFollowerWidget(
                                            name: document['first_name'] + " " + document['last_name'],
                                            username: document['username'],
                                            otherUserID: document['user_id'],
                                            userID: userID,
                                          );

                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        }
                      }else {
                        return new CircularProgressIndicator();
                      }
                    });
              }
            }),
      ),
    );
  }
}


class Following {
  bool following;
  String idOfFollowing;
  Following.fromSnapshot(DocumentSnapshot snapshot)
      : following = snapshot['following'],
        idOfFollowing = snapshot.documentID;
}
