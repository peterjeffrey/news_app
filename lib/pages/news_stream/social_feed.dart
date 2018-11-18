import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';

class SocialFeed extends StatelessWidget {
  final String userID;

  SocialFeed({this.userID});


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new FutureBuilder(
            future: Firestore.instance
                .collection('post')
                .getDocuments(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return new Column(
                    children: <Widget>[
                      new Expanded(
                        child: new ListView(
                          children: snapshot.data.documents
                              .map<Widget>((DocumentSnapshot document) {
                            return new SocialFeedWidget(
                              filter: false,
                              article_header: document['article_title'],
                              userName: document['author'],
                              spectrumValue: document['spectrum_value'].toDouble(),
                              comment: document['comment'],
                              fullName: document['firstName'] + " " + document['lastName'],
                              user_id: document['user_id'],
                              postID: document.documentID,
                              posterID: userID,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              }else {
                return new CircularProgressIndicator();
              }
            }),),
    );

  }
}




