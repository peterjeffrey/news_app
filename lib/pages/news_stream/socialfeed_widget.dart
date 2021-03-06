import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/components/TimeConverter.dart';
import 'package:news_app/pages/Troubleshooting/NewsLandingPage.dart';
import 'package:news_app/pages/Troubleshooting/SocialNewsLandingPage.dart';
import 'package:news_app/pages/news_stream/FireNewsPage.dart';
import 'package:news_app/pages/news_stream/FireNewsPageUpgrade.dart';
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
  final String posterFirstName;
  final String posterLastName;
  final String posterUserName;
  final DateTime datePosted;
  final bool partisan;

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
      this.posterFirstName,
      this.posterLastName,
        this.posterUserName,
      this.filter,
        this.datePosted,
        this.partisan,
      });

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
    DateTime now = DateTime.now();
    Duration difference = now.difference(datePosted);
    double c_width = MediaQuery.of(context).size.width * 0.8;
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
                        body: new SocialNewsLandingPage(
                          article_id: articleID,
                          userName: posterUserName,
                          userID: posterID,
                          firstName: posterFirstName,
                          lastName: posterLastName,
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
              children: buildHeader(c_width),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 0.0),
                  child: new InkWell(
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
                          style: new TextStyle(fontSize: 13.0),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new GetOtherProfilePage(
                                    posterID: user_id,
                                    myUserID: posterID,
                                  ),
                              fullscreenDialog: true),
                        ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: new Row(
                    children: buildSpectrum()
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
                  fontSize: 15.0,
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
                        postID: '$postID', respecterID: '$user_id', posterID: '$posterID', respecterUsername: '$posterUserName', comment: '$comment')),
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
              padding: EdgeInsets.only(top: 15.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  getDate(difference),
                ],
              ),
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

  List<Widget> buildHeader(width) {
    if (filter == false) {
      return [
        new Container(
          width: width,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          alignment: Alignment.topLeft,
          child: new Text(
            article_header,
            style: new TextStyle(color: purpleColor(), fontSize: 18.0),
            textAlign: TextAlign.left,
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> buildSpectrum() {
    if (partisan != false) {
      if (spectrumValue > 5.0) {
        return [
          new Slider(
            value: spectrumValue,
            onChanged: print,
            activeColor: redColor(),
            inactiveColor: redColor(),
            divisions: 100,
            max: 10.0,
            min: 0.0,
          ),
        ];
      } else if(spectrumValue < 5.0){
        return [new Slider(
          value: spectrumValue,
          onChanged: print,
          activeColor: blueColor(),
          inactiveColor: blueColor(),
          divisions: 100,
          max: 10.0,
          min: 0.0,
        ),];
      }
      else {
        return [new Slider(
          value: spectrumValue,
          onChanged: print,
          activeColor: purpleColor(),
          inactiveColor: purpleColor(),
          divisions: 100,
          max: 10.0,
          min: 0.0,
        ),];

      }
    }
    else {
      return[
        new Container(child: new Text('Non-Partisan Article'),)
      ];
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

class Article {
  String header;
  int rank;
  String content;
  String left_content;
  String right_content;
  String article_id;
  String article_date;
  String callToAction;
  String contentURL;
  String leftCallToAction;
  String leftURL;
  String rightCallToAction;
  String rightURL;

  Article.fromSnapshot(DocumentSnapshot snapshot)
      : header = snapshot["header"],
        rank = snapshot["rank"],
        content = snapshot["content"],
        left_content = snapshot["left_content"],
        right_content = snapshot["right_content"],
        article_date = snapshot["date"],
        article_id = snapshot["article_id"],
        callToAction = snapshot['callToAction'],
        contentURL = snapshot['contentURL'],
        leftCallToAction = snapshot['leftCallToAction'],
        leftURL = snapshot['leftURL'],
        rightCallToAction = snapshot['rightCallToAction'],
        rightURL = snapshot['rightURL'];
}
