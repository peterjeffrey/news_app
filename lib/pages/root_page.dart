import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/pages/LoginPage.dart';
import 'package:news_app/pages/home_page.dart';
import 'package:news_app/pages/tab_bar.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> listOfArticleIDs = new List<String>();
    List<Article> listOfActualArticles = new List<Article>();
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.signedIn:
        return new FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
//                      return new Text(snapshot.data.uid);
              String userNumber = snapshot.data.uid;
              return new FutureBuilder(
                future: getUser(userNumber),
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot?.data == null)
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );

                  return new StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('newsdays').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshotNewsday) {
                      if (!snapshotNewsday.hasData)
                        return new Center(
                          child: new CircularProgressIndicator(),
                        );
                      final int newsdayCount =
                          snapshotNewsday.data.documents.length;
                      final String name = newsdayCount.toString();
                      return new StreamBuilder(
                          stream: getNewsday(name),
                          builder:
                              (BuildContext c, AsyncSnapshot<Newsday> data) {
                            if (data?.data == null)
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            Newsday r = data.data;
                            return new NavBar(
                              auth: widget.auth,
                              articleList: r.articles,
                              onSignedOut: _signedOut,
                              userName: snapshot.data.username.toString(),
                              firstName: snapshot.data.firstName.toString(),
                              lastName: snapshot.data.lastName.toString(),
                              userID: snapshot.data.user_id.toString(),
                            );
                          });
                    },
                  );
                },
              );
            } else {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        );

//        return new NavBar(
//          auth: widget.auth,
//          onSignedOut: _signedOut,
//        );
    }
  }
}

Future<Article> getArticle(idNumber) {
  return Firestore.instance
      .collection('articles')
      .document('$idNumber')
      .get()
      .then((snapshot) {
    try {
      return Article.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  });
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
  String firstName;
  String lastName;
  String user_id;
  String username;
  User.fromSnapshot(DocumentSnapshot snapshot)
      : email = snapshot['email'],
        user_id = snapshot['user_id'],
        firstName = snapshot['first_name'],
        lastName = snapshot['last_name'],
        username = snapshot['username'];
}

Stream<Newsday> getNewsday(name) {
  return Firestore.instance
      .collection('newsdays')
      .document('$name')
      .get()
      .then((snapshot) {
    try {
      return Newsday.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

class Newsday {
  String date;
  List<Article> articles = new List<Article>();

  Newsday.fromSnapshot(DocumentSnapshot snapshot)
      : date = snapshot['date'],
        articles = List.from(snapshot['articles'].map<Article>((item) {
          return Article.fromMap(item);
        }).toList());
}

class Article {
  String header;
  int rank;
  String content;
  String left_content;
  String right_content;
  String article_id;
  String article_date;

  Article.fromSnapshot(DocumentSnapshot snapshotArticle)
      : article_date = snapshotArticle['date'],
        header = snapshotArticle['header'],
        content = snapshotArticle['content'],
        rank = snapshotArticle['rank'],
        left_content = snapshotArticle['left_content'],
        right_content = snapshotArticle['right_content'],
        article_id = snapshotArticle.documentID;

  Article.fromMap(Map<dynamic, dynamic> data)
      : header = data["header"],
        rank = data["rank"],
        content = data["content"],
        left_content = data["left_content"],
        right_content = data["right_content"],
        article_date = data["date"],
        article_id = data["article_id"];
}
