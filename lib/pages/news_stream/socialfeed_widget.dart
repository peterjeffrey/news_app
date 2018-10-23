import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SocialFeedWidget extends StatelessWidget {

  final String article_header;
  final String userName;
  final double spectrumValue;
  final String comment;

  SocialFeedWidget({this.article_header, this.userName, this.spectrumValue, this.comment});

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              alignment: Alignment.topLeft,
              child: new Text(
                article_header,
                style: new TextStyle(color: Colors.purple, fontSize: 18.0),
                textAlign: TextAlign.left,
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text(
                  "@$userName",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Slider(
                        value: spectrumValue,
                        onChanged: print,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.red,
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
                ),
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
      );
  }
}
