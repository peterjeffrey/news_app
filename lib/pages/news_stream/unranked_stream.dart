import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/pages/news_stream/CommentCollector.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';
import 'package:news_app/pages/news_stream/UserPostGetter.dart';
import 'package:news_app/pages/news_stream/left_page.dart';
import 'package:news_app/pages/news_stream/right_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnrankedPage extends StatelessWidget {
  final int rank;
  final String header;
  final String content;
  final String left_content;
  final String right_content;
  final String article_id;
  final String article_date;

  UnrankedPage(
      {this.rank,
        this.header,
        this.content,
        this.left_content,
        this.right_content,
        this.article_id,
        this.article_date,
      });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                        child: new Container(
                          child: new Center(
                            child: new Text(
                              article_date,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 8.0,
                              ),
                            ),
                          ),
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(144, 19, 254, 1.0),
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
                    child: new Container(
                      child: new Center(
                        child: new Text(
                          "Just the Facts",
                          style: new TextStyle(
                            color: Color.fromRGBO(144, 19, 254, 1.0),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      width: 300.0,
                      height: 45.0,
                      decoration: new BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(144, 19, 254, 1.0)),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(
                      content,
                      style: new TextStyle(
                        wordSpacing: 0.0,
                        letterSpacing: 0.1,
                        fontSize: 13.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new OutlineButton(
                          borderSide: new BorderSide(
                              color: Color.fromRGBO(74, 144, 226, 1.0)),
                          color: Color.fromRGBO(74, 144, 226, 1.0),
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
                                        Color.fromRGBO(74, 144, 226, 1.0)),
                                    textAlign: TextAlign.center,
                                  ),
                                  new Icon(
                                    Icons.launch,
                                    color: Color.fromRGBO(74, 144, 226, 1.0),
                                  )
                                ],
                              ),
                            ),
                            width: 80.0,
                            height: 80.0,
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new OutlineButton(
                          borderSide: new BorderSide(
                              color: Color.fromRGBO(208, 2, 27, 1.0)),
                          color: Color.fromRGBO(208, 2, 27, 1.0),
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
                                        color: Color.fromRGBO(208, 2, 27, 1.0)),
                                  ),
                                  new Icon(
                                    Icons.launch,
                                    color: Color.fromRGBO(208, 2, 27, 1.0),
                                  )
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
