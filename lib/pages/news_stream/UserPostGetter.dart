import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/articlefeed_widget.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';

class UserPostGetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(
      body: new Container(
        child: new FutureBuilder(
            future: Firestore.instance
                .collection('post')
                .where('article', isEqualTo: 'DOCID')
                .where('author', isEqualTo: 'karlrove')
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
                            return new ArticleFeedWidget(
                              article_header: document['article_title'],
                              userName: document['author'],
                              spectrumValue:
                                  document['spectrum_value'].toDouble(),
                              comment: document['comment'],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return new CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
