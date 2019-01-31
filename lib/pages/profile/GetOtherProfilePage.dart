import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';
import 'package:news_app/pages/profile/OtherUserFollowers.dart';
import 'package:news_app/pages/profile/OtherUserFollowing.dart';
import 'package:news_app/pages/profile/track_followers.dart';
import 'package:news_app/pages/profile/track_following.dart';

class GetOtherProfilePage extends StatelessWidget {
  final String myUserID;
  final String posterID;

  GetOtherProfilePage({this.posterID, this.myUserID});

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: new FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String userNumber = snapshot.data.uid;
            return new FutureBuilder(
              future: getUser(this.posterID),
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (snapshot?.data == null)
                  return new Center(
                    child: new Text("Loading..."),
                  );
                String username = snapshot.data.username.toString();
                String firstName = snapshot.data.firstName.toString();
                String firstInitial =
                    new String.fromCharCode(firstName.runes.first);
                String lastName = snapshot.data.lastName.toString();
                String userID = snapshot.data.user_id.toString();
                String lastInitial =
                    new String.fromCharCode(lastName.runes.first);
                return new ListView(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Container(
                                width: 100.0,
                                height: 100.0,
                                child: new Center(
                                  child: new Text(
                                    "$firstInitial" + "$lastInitial",
                                    style: new TextStyle(
                                      fontSize: 40.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: purpleColor(),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new OtherUserFollowers(
                                                      userName: username,
                                                      userID: userID,
                                                    ),
                                                fullscreenDialog: true),
                                          );
                                        },
                                        child: new Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: new Column(
                                            children: <Widget>[
                                              new StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection(
                                                          'relationships')
                                                      .document(userID)
                                                      .collection('followers')
                                                      .where("follower",
                                                          isEqualTo: true)
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    if (snapshot.hasError) {
                                                      return new Text("Error!");
                                                    } else if (snapshot.data ==
                                                        null) {
                                                      return new Text("Null");
                                                    } else {
                                                      return Text(
                                                        snapshot.data.documents
                                                            .length
                                                            .toString(),
                                                        style: new TextStyle(
                                                            fontSize: 20.0),
                                                      );
                                                    }
                                                  }),
                                              new Text('Followers'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new OtherUserFollowing(
                                                      userID: userID,
                                                      userName: username,
                                                    ),
                                                fullscreenDialog: true),
                                          );
                                        },
                                        child: new Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: new Column(
                                            children: <Widget>[
                                              new StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection(
                                                          'relationships')
                                                      .document(userID)
                                                      .collection('following')
                                                      .where("following",
                                                          isEqualTo: true)
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    if (snapshot.hasError) {
                                                      return new Text("Error!");
                                                    } else if (snapshot.data ==
                                                        null) {
                                                      return new Text("Null");
                                                    } else {
                                                      return Text(
                                                        snapshot.data.documents
                                                            .length
                                                            .toString(),
                                                        style: new TextStyle(
                                                            fontSize: 20.0),
                                                      );
                                                    }
                                                  }),
                                              new Text('Following'),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        "$firstName" + " " + "$lastName",
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        "@$username",
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromRGBO(
                                              155, 155, 155, 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('relationships')
                                          .document(myUserID)
                                          .collection('following')
                                          .where("followingID",
                                              isEqualTo: posterID)
                                          .where("following", isEqualTo: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (myUserID == posterID) {
                                          return new Text("Your Profile");
                                        } else if (snapshot.hasData) {
                                          if (snapshot.data != null) {
                                            if (snapshot.data.documents.length >
                                                0) {
                                              return new Column(
                                                children: <Widget>[
                                                  new Text(
                                                    "Following",
                                                    style: new TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                  new RaisedButton(
                                                    onPressed: () {
                                                      Firestore.instance
                                                          .collection('relationships')
                                                          .document(myUserID).collection('following').document(posterID)
                                                          .setData({
                                                        'following': false,
                                                        'followingID': posterID,
                                                      });
                                                      Firestore.instance
                                                          .collection('relationships')
                                                          .document(posterID).collection('followers').document(myUserID)
                                                          .setData({
                                                        'follower': false,
                                                        'followerID': myUserID,
                                                      });
                                                    },
                                                    child: new Text("Unfollow", style: TextStyle(color: purpleColor()),),
                                                    color: whiteColor(),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return new RaisedButton(
                                                color: purpleColor(),
                                                  child: new Text("Follow", style: TextStyle(color: whiteColor()),),
                                                  onPressed: () {
                                                    Firestore.instance
                                                        .collection(
                                                            'relationships')
                                                        .document(myUserID)
                                                        .collection('following')
                                                        .document(posterID)
                                                        .setData({
                                                      'following': true,
                                                      'followingID': posterID,
                                                    });
                                                    Firestore.instance
                                                        .collection(
                                                            'relationships')
                                                        .document(posterID)
                                                        .collection('followers')
                                                        .document(myUserID)
                                                        .setData({
                                                      'follower': true,
                                                      'followerID': myUserID,
                                                    });
                                                  });
                                            }
                                          }
                                        } else {
                                          return new RaisedButton(
                                              child: new Text("Follow"),
                                              onPressed: () {
                                                Firestore.instance
                                                    .collection('relationships')
                                                    .document(myUserID)
                                                    .collection('following')
                                                    .document(posterID)
                                                    .setData({
                                                  'following': true,
                                                  'followingID': posterID,
                                                });
                                                Firestore.instance
                                                    .collection('relationships')
                                                    .document(posterID)
                                                    .collection('followers')
                                                    .document(myUserID)
                                                    .setData({
                                                  'follower': true,
                                                  'followerID': myUserID,
                                                });
                                              });
                                        }
                                      }),
                                ],
                              ),
                            ],
                          ),
                          new Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: new Container(
                              height: 400.0,
                              width: 500.0,
                              child: new Container(
                                child: new FutureBuilder(
                                    future: Firestore.instance
                                        .collection('post')
                                        .where('author', isEqualTo: username)
                                        .getDocuments(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data != null) {
                                          return new Column(
                                            children: <Widget>[
                                              new Expanded(
                                                child: new ListView(
                                                  children: snapshot
                                                      .data.documents
                                                      .map<Widget>(
                                                          (DocumentSnapshot
                                                              document) {
                                                    return new SocialFeedWidget(
                                                      articleID:
                                                          document['article'],
                                                      article_header: document[
                                                          'article_title'],
                                                      userName:
                                                          document['author'],
                                                      spectrumValue: document[
                                                              'spectrum_value']
                                                          .toDouble(),
                                                      comment:
                                                          document['comment'],
                                                      fullName: document[
                                                              'firstName'] +
                                                          " " +
                                                          document['lastName'],
                                                      filter: false,
                                                      postID:
                                                          document.documentID,
                                                      posterID: userID,
                                                      datePosted: document['date_posted'],
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      } else {
                                        return new Text("");
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return new Text('Loading...');
          }
        },
      ),
    );
  }
}

Future<User> getUser(idNumber) {
  return Firestore.instance
      .collection('user')
      .document('$idNumber')
      .get()
      .then((snapshot) {
    try {
      return User.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  });
}

class User {
  String email;
  String user_id;
  String username;
  String firstName;
  String lastName;
  User.fromSnapshot(DocumentSnapshot snapshot)
      : email = snapshot['email'],
        firstName = snapshot['first_name'],
        lastName = snapshot['last_name'],
        user_id = snapshot['user_id'],
        username = snapshot['username'];
}
