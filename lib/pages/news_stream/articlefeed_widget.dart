import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/respect/RespectWidget.dart';

class ArticleFeedWidget extends StatelessWidget {
  final String article_header;
  final String userName;
  final double spectrumValue;
  final String comment;

  ArticleFeedWidget(
      {this.article_header, this.userName, this.spectrumValue, this.comment});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "@$userName",
            style: new TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.left,
          ),
          new Container(
            child: new Slider(
              value: spectrumValue,
              onChanged: print,
              activeColor: blueColor(),
              inactiveColor: redColor(),
              divisions: 100,
              max: 10.0,
              min: 0.0,
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            alignment: Alignment.topLeft,
            child: new Text(
              comment,
              style: new TextStyle(
                color: Color.fromRGBO(74, 74, 74, 1.0),
              ),
            ),
          ),
//          new RespectWidget(respecterID: 'userID', postID: 'userpostId',),
          new Padding(
            child: new Divider(
              color: Color.fromRGBO(74, 74, 74, 1.0),
            ),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          ),


        ],
      ),
    );
  }
}
