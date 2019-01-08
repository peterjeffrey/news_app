import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/CommentCollector.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';
import 'package:news_app/pages/news_stream/UserPostGetter.dart';
import 'package:news_app/pages/news_stream/left_page.dart';
import 'package:news_app/pages/news_stream/right_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MassiveFireNews extends StatefulWidget {
  MassiveFireNews({this.article_id, this.ranked});
  final String article_id;
  final bool ranked;

  @override
  State<StatefulWidget> createState() => new _MassiveFireNewsState();
}

class _PostData {
  String comment = '';
}

class _MassiveFireNewsState extends State<MassiveFireNews> {
  Widget _form;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _commentPosted = false;
  _PostData _data = new _PostData();
  double val = 5.0;
  String comment;
  TextEditingController commentController = new TextEditingController();

  void submit(
      String articleID,
      String articleTitle,
      String author,
      String firstName,
      String lastName,
      String userID,
      double spectrumValue) {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      addPost({
        'article': articleID,
        'article_title': articleTitle,
        'author': author,
        'comment': _data.comment,
        'firstName': firstName,
        'lastName': lastName,
        'user_id': userID,
        'spectrum_value': spectrumValue,
        'respect_count': 0,
      });
      setState(() {
        _commentPosted = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_form == null) {
      _form = _createForm(context);
    }
    return _form;
  }

  Widget _createForm(BuildContext context) {
    final _formKey = new GlobalKey<FormState>();
    final _emailController = new TextEditingController();
    double width100 = MediaQuery.of(context).size.width;
    print("FireNewsPageUpgrade building");
    print(_formKey);

    return new Scaffold(
        key: new GlobalKey(debugLabel: "scaffold"),
        body: new FutureBuilder(
            future: getArticle(widget.article_id),
            builder: (context, AsyncSnapshot<Article> snapshot) {
              if (snapshot?.data == null) {
                return new Center(
                  child: new Text("Loading..."),
                );
              }
              return new Center(
                child: new ListView(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Padding(
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                                child: new Container(
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
                              ),
                              new Flexible(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Padding(
                                        child: new Text(
                                          snapshot.data.header,
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
                            padding: EdgeInsets.all(8.0),
                            child: new Text(
                              snapshot.data.date.toString(),
                              style: new TextStyle(
                                  color: Color.fromRGBO(74, 74, 74, 1.0),
                                  fontSize: 16.0),
                            ),
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
                              snapshot.data.content
                                  .toString()
                                  .replaceAll("\\n", "\n\n"),
                              style: new TextStyle(
                                color: Colors.black,
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
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 8.0, 25.0, 8.0),
                                child: new RaisedButton(
                                  elevation: 8,
                                  color: blueColor(),
                                  onPressed: () => Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new LeftPage(
                                                rank: snapshot.data.rank,
                                                title: snapshot.data.header,
                                                left_content:
                                                    snapshot.data.leftContent,
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
                                                color: whiteColor()),
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
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 8.0, 8.0, 8.0),
                                child: new RaisedButton(
                                  elevation: 8,
                                  color: redColor(),
                                  onPressed: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new RightPage(
                                                  rank: snapshot.data.rank,
                                                  title: snapshot.data.header,
                                                  right_content: snapshot
                                                      .data.rightContent,
                                                ),
                                            fullscreenDialog: true),
                                      ),
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
                              child: new Container(
                                child: new FutureBuilder<FirebaseUser>(
                                  future: FirebaseAuth.instance.currentUser(),
                                  builder: (context,
                                      AsyncSnapshot<FirebaseUser> snapshot2) {
                                    if (snapshot2.connectionState ==
                                        ConnectionState.done) {
                                      String userNumber = snapshot2.data.uid;
                                      return new FutureBuilder(
                                        future: getUser(userNumber),
                                        builder: (context,
                                            AsyncSnapshot<User> snapshot2) {
                                          if (snapshot2?.data == null)
                                            return new Center(
                                              child: new Text("Loading..."),
                                            );
                                          String username = snapshot2
                                              .data.username
                                              .toString();
                                          String firstName = snapshot2
                                              .data.firstName
                                              .toString();
                                          String lastName = snapshot2
                                              .data.lastName
                                              .toString();
                                          String user_id =
                                              snapshot2.data.user_id.toString();
                                          return StreamBuilder(
                                            stream: doesNameAlreadyExist(
                                                widget.article_id,
                                                username,
                                                firstName,
                                                lastName,
                                                user_id),
                                            builder: (context,
                                                AsyncSnapshot<bool> result) {
                                              if (!result.hasData)
                                                return Container(); // future still needs to be finished (loading)
                                              if (result
                                                  .data) // result.data is the returned bool from doesNameAlreadyExists
                                                return PostGetter(
                                                  articleId: widget.article_id,
                                                  posterID: user_id,
                                                );
                                              else
                                                print(_formKey);
                                                //return CommentCollector here
                                                switch (_commentPosted) {
                                                  case (true):
                                                    return new UserPostGetter(
                                                      articleHeader:
                                                          snapshot.data.header,
                                                      articleId:
                                                          widget.article_id,
                                                    );

                                                  case (false):
                                                    return new Container(
                                                      child: new Center(
                                                        child: new Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: new Card(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0)),
                                                            elevation: 5.0,
                                                            child: new Form(
                                                              key:
                                                                  this._formKey,
                                                              child: new Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  new Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child:
                                                                        new Text(
                                                                      "What's your take on the issue?",
                                                                      style: new TextStyle(
                                                                          fontSize:
                                                                              18.0),
                                                                    ),
                                                                  ),
                                                                  new Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      new Text(
                                                                        "Very\nLeft",
                                                                        style:
                                                                            new TextStyle(
                                                                          color:
                                                                              blueColor(),
                                                                        ),
                                                                      ),
                                                                      new Slider(
                                                                        value:
                                                                            val,
                                                                        onChanged:
                                                                            changed,
                                                                        activeColor:
                                                                            redColor(),
                                                                        inactiveColor:
                                                                            blueColor(),
                                                                        divisions:
                                                                            100,
                                                                        max:
                                                                            10.0,
                                                                        min:
                                                                            0.0,
                                                                      ),
                                                                      new Text(
                                                                        "Very\nRight",
                                                                        style:
                                                                            new TextStyle(
                                                                          color:
                                                                              redColor(),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  new Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20.0),
                                                                    child:
                                                                        new Card(
                                                                      elevation:
                                                                          5.0,
                                                                      child: new TextFormField(
                                                                        controller: commentController,
                                                                          validator: (value) {
                                                                            if (value.isEmpty) {
                                                                              return 'Please enter some text';
                                                                            }
                                                                            if (value.length >
                                                                                250) {
                                                                              return 'Please shorten comment';
                                                                            }
                                                                          },
                                                                          decoration: new InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.all(10.0),
                                                                            border:
                                                                                InputBorder.none,
                                                                            hintText:
                                                                                'Your thoughts?',
                                                                          ),
                                                                          keyboardType: TextInputType.multiline,
                                                                          maxLines: 6,
                                                                          maxLength: 250,
                                                                          onSaved: (String value) {
                                                                            this._data.comment =
                                                                                value;
                                                                          }),
                                                                    ),
                                                                  ),
                                                                  new RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      submit(
                                                                          widget
                                                                              .article_id,
                                                                          snapshot
                                                                              .data
                                                                              .header,
                                                                          snapshot2
                                                                              .data
                                                                              .username,
                                                                          snapshot2.data.firstName,
                                                                          snapshot2.data.lastName,
                                                                          snapshot2.data.user_id,
                                                                          val);
                                                                    },
                                                                    child:
                                                                        new Text(
                                                                      "SUBMIT",
                                                                      style: new TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    color:
                                                                        purpleColor(),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                }
//                                                return CommentCollector(
//                                                  articleID: widget.article_id,
//                                                  userName: username,
//                                                  articleTitle: snapshot.data.header,
//                                                  firstName: firstName,
//                                                  lastName: lastName,
//                                                  user_id: user_id,
//
//                                                );
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      return new Text('Loading...');
                                    }
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  void changed(e) {
    setState(() {
      val = e;
    });
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

Stream<bool> doesNameAlreadyExist(String article, String name, String firstName,
    String lastName, String user_id) async* {
  final QuerySnapshot result = await Firestore.instance
      .collection('post')
      .where('article', isEqualTo: article)
      .where('user_id', isEqualTo: user_id)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  yield documents.length == 1;
}

Future<User> getUser(idNumber) {
  return Firestore.instance
      .collection('user')
      .document('$idNumber')
      .get()
      .then((snapshot) {
    try {
      return User.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  });
}

class User {
  String email;
  String user_id;
  String username;
  String firstName;
  String lastName;
  User.fromSnapshot(DocumentSnapshot snapshot)
      : email = snapshot['email'],
        firstName = snapshot['first_name'],
        lastName = snapshot['last_name'],
        user_id = snapshot['user_id'],
        username = snapshot['username'];
}

Future<void> addPost(postData) async {
  Firestore.instance.collection('post').add(postData).catchError((e) {
    print(e);
  });
  Firestore.instance.collection('respect_count').add({
    'count': 0,
  }).catchError((e) {
    print(e);
  });
}
