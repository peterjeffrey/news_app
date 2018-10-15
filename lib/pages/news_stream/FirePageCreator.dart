import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/FireNewsGetter.dart';
import 'package:news_app/pages/news_page.dart';

class FirePageCreator extends StatelessWidget {
  FirePageCreator({
    Key key,
    this.nameOfNewsday,
  }) : super(key: key);
  final String nameOfNewsday;

  Widget _buildPage({String nameOfNewsday, int position}) {
    return new FireNewsGetter(arrayValue: position, nameOfDoc: nameOfNewsday,);
  }

  Widget _buildPageView() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < 2; i++) {
      list.add(_buildPage(position: i, nameOfNewsday: nameOfNewsday));
    }
    return PageView(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _buildPageView(),
    );
  }
}

//Future<Newsday> getNewsday(String name) {
//  print('get Newsday $name');
//  return Firestore.instance
//      .collection('newsdays')
//      .document('$name')
//      .get()
//      .then((snapshot) {
//    try {
//      return Newsday.fromSnapshot(snapshot);
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  });
//}

//class Newsday {
//  String date;
//  List<Article> articles = new List<Article>();
//
//  Newsday.fromSnapshot(DocumentSnapshot snapshot)
//      : date = snapshot['date'],
//        articles = List.from(snapshot['articles'].map<Article>((item) {
//          return Article.fromMap(item);
//        }).toList());
//
//}
//
//class Article {
//  String header;
//  int rank;
//  String content;
//  String left_content;
//  String right_content;
//
//  Article.fromMap(Map<dynamic, dynamic> data)
//      : header = data["header"],
//        rank = data["rank"],
//        content = data["content"],
//        left_content = data["left_content"],
//        right_content = data["right_content"];
//}
