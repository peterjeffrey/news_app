import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/pages/Troubleshooting/NewsLandingPage.dart';
import 'package:news_app/pages/news_stream/FireNewsPage.dart';
import 'package:news_app/pages/news_stream/FireNewsPageUpgrade.dart';

class FireNewsGetter extends StatelessWidget {
  final int arrayValue;
  final String nameOfDoc;
  final String userID;
  final String userName;
  final String firstName;
  final String lastName;

  FireNewsGetter({Key key, this.arrayValue, this.nameOfDoc, this.userID, this.userName, this.firstName, this.lastName});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      body: new StreamBuilder(
          stream: getNewsday(nameOfDoc),
          builder: (BuildContext c, AsyncSnapshot<Newsday> data) {
            if (data?.data == null)
              return new Center(
                child: new CircularProgressIndicator(),
              );
            Newsday r = data.data;
            String headerTitle = r.articles[arrayValue].content;
            print("newsday article is $headerTitle");
            return NewsLandingPage(
              article_id: r.articles[arrayValue].article_id,
              userID: userID,
              userName: userName,
              firstName: firstName,
              lastName: lastName,
            );
          }),
    );
  }
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


  Article.fromMap(Map<dynamic, dynamic> data)
      : header = data["header"],
        rank = data["rank"],
        content = data["content"],
        left_content = data["left_content"],
        right_content = data["right_content"],
        article_date = data["date"],
        article_id = data["article_id"];
}