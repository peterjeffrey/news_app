import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';
import 'package:news_app/pages/profile/find_followers.dart';
import 'package:news_app/pages/profile/track_followers.dart';
import 'package:news_app/pages/profile/track_following.dart';

class ProfilePage extends StatelessWidget {

  final String userID;
  ProfilePage({this.userID});


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.person_add),
              onPressed: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => new AddFollowers(userID: userID,),
                      fullscreenDialog: true),
                );
              }
          ),
        ],
      ),
      body: new FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String userNumber = snapshot.data.uid;
            return new FutureBuilder(
              future: getUser(userNumber),
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
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
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
                                  color: Color.fromRGBO(100, 45, 200, 1.0),
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
                                                    new TrackFollowers(
                                                        userID: userID),
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
                                                new TrackFollowing(
                                                    userID: userID),
                                                fullscreenDialog: true),
                                          );
                                        },
                                          child: new Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: new Column(
                                              children: <Widget>[
                                                new StreamBuilder(
                                                    stream: Firestore.instance
                                                        .collection('relationships')
                                                        .document(userID)
                                                        .collection('following')
                                                        .where("following",
                                                        isEqualTo: true)
                                                        .snapshots(),
                                                    builder: (BuildContext context,
                                                        AsyncSnapshot snapshot) {
                                                      if (snapshot.hasError) {
                                                        return new Text("Error!");
                                                      } else if (snapshot.data ==
                                                          null) {
                                                        return new Text("Null");
                                                      } else {
                                                        return Text(
                                                          snapshot
                                                              .data.documents.length
                                                              .toString(),
                                                          style: new TextStyle(
                                                              fontSize: 20.0),
                                                        );
                                                      }
                                                    }),
                                                new Text('Following'),
                                              ],
                                            ),
                                          ),)

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
                                                      articleID: document['article'],
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
