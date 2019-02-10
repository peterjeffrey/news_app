import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/CommentCollector.dart';
import 'package:news_app/pages/news_stream/CommentCollectorPopUp.dart';
import 'package:news_app/pages/news_stream/NonPartPage.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';
import 'package:news_app/pages/news_stream/UserPostGetter.dart';
import 'package:news_app/pages/news_stream/left_page.dart';
import 'package:news_app/pages/news_stream/right_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsLandingPage extends StatelessWidget {
  final String article_id;
  final String userID;
  final bool ranked;
  final String firstName;
  final String lastName;
  final String userName;
  final String header;
  final String content;
  final int rank;
  final String rightContent;
  final String leftContent;
  final String date;
  final String callToAction;
  final String contentURL;
  final String rightCallToAction;
  final String rightURL;
  final String leftCallToAction;
  final String leftURL;
  final String nPartL1;
  final String nPartL2;
  final String nPartL3;
  final String nPartC1;
  final String nPartC2;
  final String nPartC3;
  final bool partisan;

  NewsLandingPage({
    this.callToAction,
    this.contentURL,
    this.rightCallToAction,
    this.rightURL,
    this.leftCallToAction,
    this.leftURL,
    this.article_id,
    this.userID,
    this.firstName,
    this.lastName,
    this.userName,
    this.ranked,
    this.header,
    this.content,
    this.rank,
    this.rightContent,
    this.leftContent,
    this.date,
    this.nPartC1,
    this.nPartC2,
    this.nPartC3,
    this.nPartL1,
    this.nPartL2,
    this.nPartL3,
    this.partisan,
  });

  Future<int> checkUser(String articleID, String userID) async {
    var user = await Firestore.instance
        .collection('post')
        .where('article', isEqualTo: articleID)
        .where('user_id', isEqualTo: userID)
        .getDocuments();
    return user.documents.length;
  }

  @override
  Widget build(BuildContext context) {
    double width100 = MediaQuery.of(context).size.width;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 0.0),
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
                      child: new Padding(
                        padding: EdgeInsets.all(12.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              header,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 28.0,
                              ),
                            ),
                            new Text(
                              date,
                              style: new TextStyle(
                                  color: Color.fromRGBO(74, 74, 74, 1.0),
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(
                  child: new Container(
                    width: width100,
                    height: 50.0,
                    color: purpleColor(),
                    child: new Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            child: new Icon(Icons.arrow_back, color: Colors.white,),
                            padding: EdgeInsets.only(right: 50.0),
                          ),

                          new Text(
                            "Just the Facts",
                            style: new TextStyle(
                              color: whiteColor(),
                              fontSize: 16.0,
                            ),

                          ),
                          new Padding(
                            child: new Icon(Icons.arrow_forward, color: Colors.white,),
                            padding: EdgeInsets.only(left: 50.0),
                          ),
                        ],
                      )
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                ),
                new Padding(
                  padding: EdgeInsets.all(24.0),
                  child: new Text(
                    content.toString().replaceAll("\\n", "\n\n"),
                    style: new TextStyle(
                      color: Colors.black,
                      wordSpacing: 0.0,
                      letterSpacing: 0.1,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: new InkWell(
                    onTap: _launchURL,
                    child: Text(
                      callToAction,
                      style: new TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        wordSpacing: 0.0,
                        letterSpacing: 0.1,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: partisanTiles(context),
                ),
              ],
            ),
          ),
          new FutureBuilder<int>(
              future: checkUser(article_id, userID),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  if (snapshot2.data == 1) {
                    return new PostGetter(
                      articleId: article_id,
                      posterID: userID,
                      currentUserID: userName,
                    );
                  } else {
                    return new GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new CommentCollectorPopUp(
                                    articleID: article_id,
                                    articleTitle: header,
                                    articleDate: date,
                                    userName: userName,
                                    firstName: firstName,
                                    lastName: lastName,
                                    user_id: userID,
                                    partisan: partisan,

                                  ),
                              fullscreenDialog: true));
                        },
                        child: new Container(
                          child: new Column(children: [
                            new Container(
                              child: new Center(
                                child: new Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: new Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    elevation: 5.0,
                                    child: new Form(
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: new Text(
                                              "What's your take on the issue?",
                                              style:
                                                  new TextStyle(fontSize: 18.0),
                                            ),
                                          ),
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: showSpectrum(context),
//                                              new Text(
//                                                "Very\nLeft",
//                                                style: new TextStyle(
//                                                    color: blueColor(),
//                                                    fontWeight:
//                                                        FontWeight.bold),
//                                              ),
//                                              new Slider(
//                                                value: 5.0,
//                                                onChanged: print,
//                                                activeColor: purpleColor(),
//                                                inactiveColor: purpleColor(),
//                                                divisions: 100,
//                                                max: 10.0,
//                                                min: 0.0,
//                                              ),
//                                              new Text(
//                                                "Very\nRight",
//                                                style: new TextStyle(
//                                                  color: redColor(),
//                                                ),
//                                              ),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: new Card(
                                              elevation: 5.0,
                                              child: new TextFormField(
                                                enabled: false,
                                                decoration: new InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10.0),
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Click to write your thoughts',
                                                ),
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 1,
                                                maxLength: 250,
                                              ),
                                            ),
                                          ),
                                          new RaisedButton(
                                            onPressed: () => print("Submit"),
                                            child: new Text(
                                              "SUBMIT",
                                              style: new TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: purpleColor(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ));
                  }
                } else if (snapshot2.hasError) {
                  return new Text("${snapshot2.error}");
                }
                return new Container();
              })
        ],
      ),
    );
  }

  _launchURL() async {
    final url = contentURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> showSpectrum(context){
    if (partisan != false) {
      return
          [
            new Text(
              "Very\nLeft",
              style: new TextStyle(
                  color: blueColor(),
                  fontWeight:
                  FontWeight.bold),
            ),
            new Slider(
              value: 5.0,
              onChanged: print,
              activeColor: purpleColor(),
              inactiveColor: purpleColor(),
              divisions: 100,
              max: 10.0,
              min: 0.0,
            ),
            new Text(
              "Very\nRight",
              style: new TextStyle(
                color: redColor(),
              ),
            ),
          ];
    }
    else {
      return [
        new Container(
          child: new Text("Non-Partisan Article"),
        )
      ];
    }
  }

  List<Widget> partisanTiles(context) {
    if (leftContent != null) {
      return [
        new Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 25.0, 8.0),
          child: new RaisedButton(
            elevation: 8,
            color: blueColor(),
            onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new LeftPage(
                      leftURL: leftURL,
                      leftCallToAction: leftCallToAction,
                      rank: rank,
                      title: header,
                      left_content: leftContent,
                    ),
                fullscreenDialog: true)),
            child: new Container(
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Left Opinion",
                      style: new TextStyle(color: whiteColor()),
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
          padding: EdgeInsets.fromLTRB(25.0, 8.0, 8.0, 8.0),
          child: new RaisedButton(
            elevation: 8,
            color: redColor(),
            onPressed: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new RightPage(
                            rightURL: rightURL,
                            rightCallToAction: rightCallToAction,
                            rank: rank,
                            title: header,
                            right_content: rightContent,
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
                      style: new TextStyle(color: whiteColor()),
                    ),
                  ],
                ),
              ),
              width: 80.0,
              height: 80.0,
            ),
          ),
        )
      ];
    } else {
      return [
        new Padding(
            padding: EdgeInsets.fromLTRB(25.0, 8.0, 8.0, 8.0),
            child: new RaisedButton(
              child: new Container(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Non-Partisan Commentary",
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: whiteColor()),
                      ),
                    ],
                  ),
                ),
                width: 160.0,
                height: 80.0,
              ),
              elevation: 8,
              color: purpleColor(),
              onPressed: () => Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new NonPartPage(
                              rank: rank,
                              title: header,
                              nPartC1: nPartC1,
                              nPartC2: nPartC2,
                              nPartC3: nPartC3,
                              nPartL1: nPartL1,
                              nPartL2: nPartL2,
                              nPartL3: nPartL3,
                            ),
                        fullscreenDialog: true),
                  ),
            ))
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
