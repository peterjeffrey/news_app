import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/CommentCollector.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';

class UserPostGetter extends StatelessWidget {
  final String articleId;
  final String articleHeader;

  UserPostGetter({this.articleId, this.articleHeader});

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Container(

        child: new FutureBuilder<FirebaseUser>(
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
                  String lastName = snapshot.data.lastName.toString();
                  String user_id = snapshot.data.user_id.toString();
                  return StreamBuilder(
                    stream: doesNameAlreadyExist(articleId, username, firstName, lastName, user_id),
                    builder: (context, AsyncSnapshot<bool> result) {
                      if (!result.hasData)
                        return Container(); // future still needs to be finished (loading)
                      if (result
                          .data) // result.data is the returned bool from doesNameAlreadyExists
                        return PostGetter(
                          articleId: articleId,
                          posterID: user_id,
                        );
                      else
                        return CommentCollector(
                          articleID: articleId,
                          userName: username,
                          articleTitle: articleHeader,
                          firstName: firstName,
                          lastName: lastName,
                          user_id: user_id,

                        );
                    },
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

Stream<bool> doesNameAlreadyExist(String article, String name, String firstName, String lastName, String user_id) async* {
  final QuerySnapshot result = await Firestore.instance
      .collection('post')
      .where('article', isEqualTo: article)
      .where('user_id', isEqualTo: user_id)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  yield documents.length == 1;
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