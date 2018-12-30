import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:news_app/pages/news_stream/FireNewsView.dart';

class LeftPage extends StatelessWidget {

  final int rank;
  final String title;
  final String left_content;

  LeftPage({Key key, this.rank, this.title, this.left_content});

  @override
  Widget build(BuildContext context) {
    double width100  = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(
              context
            );
          },
        ),
      ),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: new Center(
                          child: new Text(
                            (this.rank).toString(),
                            style: new TextStyle(
                              color: blueColor(),
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: whiteColor(),
                          border: Border.all(
                              color: blueColor()),
                        ),
                      ),
                      new Flexible(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                child: new Text(
                                  this.title,
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
                ),
                new Padding(
                  child: new Container(
                    width: width100,
                    height: 50.0,
                    color: blueColor(),
                    child: new Center(
                      child: new Text(
                        "Left Opinion",
                        style: new TextStyle(
                          color: Colors.white,
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
                    this.left_content,
                    style: new TextStyle(
                      wordSpacing: 0.0,
                      letterSpacing: 0.1,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
