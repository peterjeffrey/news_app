import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';
import 'package:news_app/pages/news_stream/UserPostGetter.dart';

class CommentCollector extends StatefulWidget {
  final String articleID;
  final String articleDate;
  final String articleTitle;
  final String userName;
  final String firstName;
  final String lastName;
  final String user_id;
  const CommentCollector(
      {Key key, this.articleID, this.articleTitle, this.userName, this.firstName, this.lastName, this.user_id, this.articleDate})
      : super(key: key);

  @override
  _CommentCollectorState createState() => new _CommentCollectorState();
}

class _PostData {
  String comment = '';
}

class _CommentCollectorState extends State<CommentCollector> {
  double val = 5.0;
  final _formKey = GlobalKey<FormState>();
  bool _commentPosted = false;
  _PostData _data = new _PostData();

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      addPost({
        'article': widget.articleID,
        'article_title': widget.articleTitle,
        'author': widget.userName,
        'comment': _data.comment,
        'firstName': widget.firstName,
        'lastName': widget.lastName,
        'user_id': widget.user_id,
        'spectrum_value': val,
        'respect_count': 0,
      });
      setState(() {
        _commentPosted = true;
      });


    }
  }

  @override
  Widget build(BuildContext context) {
    switch(_commentPosted) {
      case(true):
        return new UserPostGetter(articleHeader: widget.articleTitle, articleId: widget.articleID,);

      case(false):
        return new Container(
          child: new Center(
            child: new Container(
              padding: EdgeInsets.all(8.0),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 5.0,
                child: new Form(
                  key: this._formKey,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new Text(
                          "What's your take on the issue?",
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "Very\nLeft",
                            style: new TextStyle(color: Color.fromRGBO(80,100, 250, 1.0),),
                          ),
                          new Slider(
                            value: val,
                            onChanged: changed,
                            activeColor: Color.fromRGBO(208, 35, 75, 1.0),
                            inactiveColor: Color.fromRGBO(80,100, 250, 1.0),
                            divisions: 100,
                            max: 10.0,
                            min: 0.0,
                          ),
                          new Text(
                            "Very\nRight",
                            style: new TextStyle(color: Color.fromRGBO(208, 35, 75, 1.0),),
                          ),
                        ],
                      ),
                      new Padding(
                        padding: EdgeInsets.all(20.0),
                        child: new Card(
                          elevation: 5.0,
                          child: new TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                if (value.length > 250) {
                                  return 'Please shorten comment';
                                }
                              },
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Your thoughts?',
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              maxLength: 250,
                              onSaved: (String value) {
                                this._data.comment = value;
                              }),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: this.submit,
                        child: new Text(
                          "SUBMIT",
                          style: new TextStyle(color: Colors.white),
                        ),
                        color: Color.fromRGBO(100, 45, 200, 1.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

    }
  }

  void changed(e) {
    setState(() {
      val = e;
    });
  }
}

Future<void> addPost(postData) async {
  Firestore.instance.collection('post').add(postData).catchError((e) {
    print(e);
  });
  Firestore.instance.collection('respect_count').add(
    {
      'count': 0,
    }
  ).catchError((e) {
    print(e);
  });
}
