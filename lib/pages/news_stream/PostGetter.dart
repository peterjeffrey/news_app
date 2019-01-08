import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';

class PostGetter extends StatelessWidget {
  final String articleId;
  final String posterID;

  PostGetter({this.articleId, this.posterID});

  @override
  Widget build(BuildContext context) {
// TODO: implement build
   return new FutureBuilder(
            future: Firestore.instance
                .collection('post')
                .where('article', isEqualTo: articleId)
                .getDocuments(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return
                  new Column(
                    children: <Widget>[
                      new ListView(

                        shrinkWrap: true,
                        children: snapshot.data.documents
                            .map<Widget>((DocumentSnapshot document) {
                          return new SocialFeedWidget(
                            filter: true,
                            article_header: document['article_title'],
                            userName: document['author'],
                            spectrumValue:
                            document['spectrum_value'].toDouble(),
                            fullName: document['firstName'] + " " + document['lastName'],
                            comment: document['comment'],
                            user_id: document['user_id'],
                            postID: document.documentID,
                            posterID: posterID,
                          );
                        }).toList(),

                      ),
                    ],

                  );

                }
              } else {
                return new CircularProgressIndicator();
              }
            });


  }
}


