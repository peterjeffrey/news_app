import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeftPage extends StatelessWidget {

  final int rank;
  final String title;
  final String left_content;

  LeftPage({Key key, this.rank, this.title, this.left_content});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(elevation: 0.0,),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      child: new Center(
                        child: new Text(
                          (this.rank).toString(),
                          style: new TextStyle(
                            color: Color.fromRGBO(74, 144, 226, 1.0),
                            fontSize: 40.0,
                          ),
                        ),
                      ),
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromRGBO(74, 144, 226, 1.0)),
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
                new Padding(
                  child: new Container(
                    child: new Center(
                      child: new Text(
                        "Left Opinion",
                        style: new TextStyle(
                          color: Color.fromRGBO(74, 144, 226, 1.0),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    width: 300.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(74, 144, 226, 1.0)),
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
