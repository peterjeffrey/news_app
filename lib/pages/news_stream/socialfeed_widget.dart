import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/FireNewsPage.dart';
import 'package:news_app/pages/news_stream/unranked_stream.dart';
import 'package:news_app/pages/profile/GetOtherProfilePage.dart';
import 'package:news_app/pages/respect/RespectWidget.dart';
import 'package:news_app/pages/respect/report_flag.dart';

class SocialFeedWidget extends StatelessWidget {
  final String articleID;
  final String article_header;
  final String userName;
  final double spectrumValue;
  final String comment;
  final String fullName;
  final String user_id;
  final String postID;
  final String posterID;
  final bool filter;

  SocialFeedWidget(
      {this.articleID,
      this.article_header,
      this.userName,
      this.spectrumValue,
      this.comment,
      this.fullName,
      this.user_id,
      this.postID,
      this.posterID,
      this.filter});

  Future totalLikes(postID) async {
    var respectsQuery = Firestore.instance
        .collection('respects')
        .where('postID', isEqualTo: postID);
    var querySnapshot = await respectsQuery.getDocuments();
    var totalEquals = querySnapshot.documents.length;
    return totalEquals;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: new FlatButton(
        onPressed: () async {
          Article thisArticle = await getArticle(articleID);
          if (thisArticle != null) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context) => new Scaffold(
                        appBar: AppBar(
                          elevation: 0.0,
                        ),
                        body: new UnrankedPage(
                          right_content: thisArticle.right_content,
                          left_content: thisArticle.left_content,
                          content: thisArticle.content,
                          rank: thisArticle.rank,
                          header: thisArticle.header,
                          article_date: thisArticle.article_date,
                        ),
                      ),
                  fullscreenDialog: true),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: buildHeader(),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 0.0),
                  child: new FlatButton(
//                  child: new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "$fullName",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                        ),
                        new Text(
                          "@$userName",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13.0),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new GetOtherProfilePage(posterID: user_id,),
                          fullscreenDialog: true),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Slider(
                        value: spectrumValue,
                        onChanged: print,
                        activeColor: Color.fromRGBO(208, 35, 75, 1.0),
                        inactiveColor: Color.fromRGBO(80, 100, 250, 1.0),
                        divisions: 100,
                        max: 10.0,
                        min: 0.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              alignment: Alignment.topLeft,
              child: new Text(
                comment,
                style: new TextStyle(
                  color: Color.fromRGBO(74, 74, 74, 1.0),
                  fontSize: 13.0,
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    alignment: Alignment.bottomRight,
                    child: new RespectWidget(
                        postID: '$postID', respecterID: '$posterID')),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  alignment: Alignment.bottomRight,
                  child: new ReportWidget(
                      content: comment,
                      reportedUser: userName,
                      postID: '$postID',
                      reportingUserID: '$posterID'),
                ),
              ],
            ),
            new Padding(
              child: new Divider(
                color: Color.fromRGBO(74, 74, 74, 1.0),
              ),
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildHeader() {
    if (filter == false) {
      return [
        new Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          alignment: Alignment.topLeft,
          child: new Text(
            article_header,
            style: new TextStyle(
                color: Color.fromRGBO(100, 45, 200, 1.0), fontSize: 18.0),
            textAlign: TextAlign.left,
          ),
        ),
      ];
    } else {
      return [];
    }
  }

//  List<Widget> buildPosts() {
//    return [
//      new Row(
//        children: <Widget>[
//          new Container(
//            margin: EdgeInsets.only(left: 0.0),
//            child: new FlatButton(
////                  child: new Expanded(
//              child: new Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  new Text(
//                    "$fullName",
//                    textAlign: TextAlign.left,
//                    style: new TextStyle(
//                        fontWeight: FontWeight.bold, fontSize: 13.0),
//                  ),
//                  new Text(
//                    "@$userName",
//                    textAlign: TextAlign.left,
//                    style: new TextStyle(
//                        fontStyle: FontStyle.italic, fontSize: 13.0),
//                  ),
//                ],
//              ),
////                  ),
//              onPressed: () => print('launch!'),
//            ),
//
//          ),
//          new Container(
//            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
//            child: new Row(
//              children: <Widget>[
//                new Slider(
//                  value: spectrumValue,
//                  onChanged: print,
//                  activeColor: Color.fromRGBO(208, 35, 75, 1.0),
//                  inactiveColor: Color.fromRGBO(80, 100, 250, 1.0),
//                  divisions: 100,
//                  max: 10.0,
//                  min: 0.0,
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//      new Container(
//        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//        alignment: Alignment.topLeft,
//        child: new Text(
//          comment,
//          style: new TextStyle(
//            color: Color.fromRGBO(74, 74, 74, 1.0),
//            fontSize: 13.0,
//          ),
//        ),
//      ),
//      new Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          new Container(
//              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//              alignment: Alignment.bottomRight,
//              child: new RespectWidget(
//                  postID: '$postID', respecterID: '$posterID')),
//          new Container(
//            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//            alignment: Alignment.bottomRight,
//            child: new ReportWidget(
//                content: comment,
//                reportedUser: userName,
//                postID: '$postID',
//                reportingUserID: '$posterID'),
//          ),
//        ],
//      ),
//      new Padding(
//        child: new Divider(
//          color: Color.fromRGBO(74, 74, 74, 1.0),
//        ),
//        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//      ),
//    ];
//  }
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
  String header;
  int rank;
  String content;
  String left_content;
  String right_content;
  String article_id;
  String article_date;

  Article.fromSnapshot(DocumentSnapshot snapshot)
      : header = snapshot["header"],
        rank = snapshot["rank"],
        content = snapshot["content"],
        left_content = snapshot["left_content"],
        right_content = snapshot["right_content"],
        article_date = snapshot["date"],
        article_id = snapshot["article_id"];
}
