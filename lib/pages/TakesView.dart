import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/FireNewsPage.dart';


class TakesView extends StatefulWidget {


  @override
  _TakesViewState createState() => new _TakesViewState();
  int indexNumber = 0;

}

class _TakesViewState extends State<TakesView> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new StreamBuilder(
        stream: getNewsday(),
        builder: (BuildContext c, AsyncSnapshot<Newsday> data) {
          if (data?.data == null) return Text("Error");


          Newsday r = data.data;
          return FireNewsPage(
            rank: r.articles[widget.indexNumber].rank,
            header: r.articles[widget.indexNumber].header,
            content: r.articles[widget.indexNumber].content,
            left_content: r.articles[widget.indexNumber].left_content,
            right_content: r.articles[widget.indexNumber].right_content,
          );
        }
          ),
          );
  }
}

Stream<Newsday> getNewsday() {
  return Firestore.instance
      .collection('newsdays')
      .document('bDY0W9uddB1HP2eDWETU')
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


class Article {
  String header;
  int rank;
  String content;
  String left_content;
  String right_content;

  Article.fromMap(Map<dynamic, dynamic> data)
      : header = data["header"],
        rank = data["rank"],
        content = data["content"],
        left_content = data["left_content"],
        right_content = data["right_content"];
}

class Newsday {
  String documentID;
  String date;
  List<Article> articles = new List<Article>();

  Newsday.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        date = snapshot['date'],
        articles = List.from(snapshot['articles'].map<Article>((item) {
  return Article.fromMap(item);
  }).toList());

}


//class TakesView extends StatefulWidget {
//  @override
//  _TakesViewState createState() => new _TakesViewState();
//
//}
//
//class _TakesViewState extends State<TakesView> {
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Scaffold(
//        body: new NewsList(),
//    );
//  }
//}
//
//class NewsList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('newsdays').snapshots(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if (!snapshot.hasData) return new Text('Loading...');
//        return new ListView(
//          children: snapshot.data.documents.map((DocumentSnapshot document) {
//            return new ListTile(
//              title: new Text(document['date']),
//              subtitle: new Text(document['date']),
//            );
//          }).toList(),
//        );
//      },
//    );
//  }
//}
