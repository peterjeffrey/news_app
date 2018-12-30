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

class FireNewsPage extends StatelessWidget {

  final int rank;
  final String header;
  final String content;
  final String left_content;
  final String right_content;
  final String article_id;
  final String article_date;

  FireNewsPage(
      {this.rank,
      this.header,
      this.content,
      this.left_content,
      this.right_content,
      this.article_id,
      this.article_date});

  @override
  Widget build(BuildContext context) {
    double width100  = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: Center(
        child: new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                        child: new Container(
                          child: new Center(
                            child: new Text(
                              (rank).toString(),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                              ),
                            ),
                          ),
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: purpleColor(),
                          ),
                        ),
                      ),
                      new Flexible(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                child: new Text(
                                  header,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 28.0,
                                  ),
                                ),
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Text(article_date,
                      style: new TextStyle(
                          color: Color.fromRGBO(74,74,74,1.0),
                        fontSize: 16.0
                      ),),
                  ),
                  new Padding(
                    child: new Container(
                      width: width100,
                      height: 50.0,
                      color: purpleColor(),
                      child: new Center(
                        child: new Text(
                          "Just the Facts",
                          style: new TextStyle(
                            color: whiteColor(),
                            fontSize: 16.0,
                          ),
                        ),
                      ),

                    ),
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(
                      content.replaceAll("\\n", "\n\n"),
                      style: new TextStyle(
                        wordSpacing: 0.0,
                        letterSpacing: 0.1,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0,25.0,8.0),
                        child: new RaisedButton(
                          elevation: 8,
                          color: blueColor(),
                          onPressed: () => Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new LeftPage(
                                        rank: rank,
                                        title: header,
                                        left_content: left_content,
                                      ),
                                  fullscreenDialog: true)),
                          child: new Container(
                            child: new Center(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    "Left Opinion",
                                    style: new TextStyle(
                                        color:
                                            whiteColor()),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            width: 80.0,
                            height: 80.0,
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 8.0,8.0,8.0),
                        child: new RaisedButton(
                          elevation: 8,
                          color: redColor(),
                          onPressed: () => Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new RightPage(
                                        rank: rank,
                                        title: header,
                                        right_content: right_content,
                                      ),
                                  fullscreenDialog: true),
                          ),
                          child: new Container(
                            child: new Center(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    "Right Opinion",
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        color: whiteColor()),
                                  ),
                                ],
                              ),
                            ),
                            width: 80.0,
                            height: 80.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                      new Container(
                        height: 400.0,
                        width: 800.0,
                        child: new UserPostGetter(articleId: article_id, articleHeader: header),
                      ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
