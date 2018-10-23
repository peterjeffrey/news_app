import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';

class CommentCollector extends StatefulWidget {
  @override
  _CommentCollectorState createState() => new _CommentCollectorState();
}

class _CommentCollectorState extends State<CommentCollector> {
  double val = 5.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Card(
              elevation: 15.0,
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
                        style: new TextStyle(color: Colors.blue),
                      ),
                      new Slider(
                        value: val,
                        onChanged: changed,
                        activeColor: Colors.red,
                        inactiveColor: Colors.blue,
                        divisions: 100,
                        max: 10.0,
                        min: 0.0,
                      ),
                      new Text(
                        "Very\nRight",
                        style: new TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  new Form(
                    child: new Padding(
                      padding: EdgeInsets.all(20.0),
                      child: new Card(
                        elevation: 20.0,
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Your thoughts?',
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          maxLength: 250,
                        ),
                      ),
                    ),
                  ),
                  new RaisedButton(
                    onPressed: () => print(val),
                    child: new Text(
                      "SUBMIT",
                      style: new TextStyle(color: Colors.white),
                    ),
                    color: Color.fromRGBO(144, 19, 254, 1.0),
                  )
                ],
              )),
        ),
      ),
    );
  }
  void changed(e) {
    setState(() {
      val = e;
    });
  }
}
