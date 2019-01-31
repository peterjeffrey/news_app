import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/ColorFile.dart';
import 'package:url_launcher/url_launcher.dart';

class NonPartPage extends StatelessWidget {

  final int rank;
  final String title;
  final String nPartL1;
  final String nPartL2;
  final String nPartL3;
  final String nPartC1;
  final String nPartC2;
  final String nPartC3;

  NonPartPage({
    Key key,
    this.rank,
    this.title,
    this.nPartC1,
    this.nPartC2,
    this.nPartC3,
    this.nPartL1,
    this.nPartL2,
    this.nPartL3,
  });


  @override
  Widget build(BuildContext context) {
    double width100  = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(elevation: 0.0,),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: new Center(
                          child: new Text(
                            (this.rank).toString(),
                            style: new TextStyle(
                              color: purpleColor(),
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
                              color: purpleColor()),
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
                                EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0)),
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
                    color: purpleColor(),
                    child: new Center(
                      child: new Text(
                        "Non-Partisan Commentary",
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
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                  child: new InkWell(
                    onTap: _launchURL1,
                    child: Text(nPartC1,  style: new TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      wordSpacing: 0.0,
                      letterSpacing: 0.1,
                      fontSize: 16.0,
                    ),
                      textAlign: TextAlign.justify,),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                  child: new InkWell(
                    onTap: _launchURL2,
                    child: Text(nPartC2,  style: new TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      wordSpacing: 0.0,
                      letterSpacing: 0.1,
                      fontSize: 16.0,
                    ),
                      textAlign: TextAlign.justify,),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                  child: new InkWell(
                    onTap: _launchURL3,
                    child: Text(nPartC3,  style: new TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      wordSpacing: 0.0,
                      letterSpacing: 0.1,
                      fontSize: 16.0,
                    ),
                      textAlign: TextAlign.justify,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL1() async {
    final url = nPartL1;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchURL2() async {
    final url = nPartL2;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchURL3() async {
    final url = nPartL3;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


