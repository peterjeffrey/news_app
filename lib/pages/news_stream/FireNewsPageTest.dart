

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/CommentCollector.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';
import 'package:news_app/pages/news_stream/UserPostGetter.dart';
import 'package:news_app/pages/news_stream/left_page.dart';
import 'package:news_app/pages/news_stream/right_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireNewsPageTest extends StatelessWidget {
  final String article_id;
  final bool ranked;


  FireNewsPageTest({this.article_id, this.ranked});

  @override
  Widget build(BuildContext context) {
    double width100 = MediaQuery.of(context).size.width;
    print("FireNewsPageUpgrade building");


    return new Scaffold(
        key: new GlobalKey(debugLabel: "scaffold"),
        body: new Center(
                child: new ListView(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                      child:  CommentCollector(
          articleID: '123',
          userName: 'pj',
          articleTitle: 'Header',
          firstName: "peter",
          lastName: "jeffrey",
          user_id: "12345",

        ))
                ],
                ),
              ),
            );
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

class Article {
  String content;
  String date;
  String header;
  String leftContent;
  String rightContent;
  int rank;

  Article.fromSnapshot(DocumentSnapshot snapshot)
      : content = snapshot['content'],
        date = snapshot['date'],
        header = snapshot['header'],
        leftContent = snapshot['left_content'],
        rightContent = snapshot['right_content'],
        rank = snapshot['rank'];
}