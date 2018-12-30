import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/left_page.dart';
import 'package:news_app/pages/news_stream/right_page.dart';

Future<Article> fetchArticle(url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Article.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Article {
  final int id;
  final int newsday;
  final int rank;
  final String title;
  final String article_content;
  final String left_content;
  final String right_content;

  Article(
      {this.id,
      this.newsday,
      this.rank,
      this.title,
      this.article_content,
      this.left_content,
      this.right_content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      newsday: json['newsday'],
      rank: json['rank'],
      title: json['title'],
      article_content: json['article_content'],
      right_content: json['right_content'],
      left_content: json['left_content'],
    );
  }
}

//void main() => runApp(MyApp());

class NewsPage extends StatelessWidget {
  final String url;

  NewsPage({this.url});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: FutureBuilder<Article>(
          future: fetchArticle(this.url),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Container(
                              child: new Center(
                                child: new Text(
                                  (snapshot.data.rank).toString(),
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
                            new Flexible(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Padding(
                                      child: new Text(
                                        snapshot.data.title,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 28.0,
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 0.0, 0.0, 10.0)),
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
                                  color: purpleColor(),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            width: 300.0,
                            height: 45.0,
                            decoration: new BoxDecoration(
                              border: Border.all(
                                  color: purpleColor()),
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
                            snapshot.data.article_content,
                            style: new TextStyle(
                              wordSpacing: 0.0,
                              letterSpacing: 0.1,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.all(8.0),
                              child: new OutlineButton(
                                borderSide: new BorderSide(
                                    color: blueColor()),
                                color: blueColor(),
                                onPressed: () => Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new LeftPage(
                                              rank: snapshot.data.rank,
                                              title: snapshot.data.title,
                                              left_content:
                                                  snapshot.data.left_content,
                                            ),
                                        fullscreenDialog: true)),
                                child: new Container(
                                  child: new Center(
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text(
                                          "Left Opinion",
                                          style: new TextStyle(
                                              color: blueColor()),
                                          textAlign: TextAlign.center,
                                        ),
                                        new Icon(
                                          Icons.launch,
                                          color: blueColor(),
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
                                    color: redColor()),
                                color: redColor(),
                                onPressed: () => Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new RightPage(
                                              rank: snapshot.data.rank,
                                              title: snapshot.data.title,
                                              right_content:
                                                  snapshot.data.right_content,
                                            ),
                                        fullscreenDialog: true)),
                                child: new Container(
                                  child: new Center(
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text(
                                          "Right Opinion",
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                              color: redColor()),
                                        ),
                                        new Icon(
                                          Icons.launch,
                                          color: redColor(),
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
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
