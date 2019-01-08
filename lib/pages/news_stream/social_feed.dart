import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/socialfeed_widget.dart';

class SocialFeed extends StatelessWidget {
  final String userID;
  final String userFirstName;
  final String userLastName;
  final String username;

  SocialFeed({this.userID, this.username, this.userFirstName, this.userLastName});

  List<String> followingList = [];


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('relationships')
                .document(userID)
                .collection('following')
                .where("following", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return new Text("Error!");
              } else if (snapshot.data == null) {
                return new Text("Null");
              } else {
                for (var i = 0; i < snapshot.data.documents.length; i++) {
                  followingList
                      .add(snapshot.data.documents[i]['followingID'].toString());
                }
//                return new Text(followersList[0].toString());
                return new FutureBuilder(
                    future: Firestore.instance
                        .collection('post')
                        .getDocuments(),
                    builder: (BuildContext context, AsyncSnapshot snapshot2) {
                      if (snapshot2.hasData) {
                        if (snapshot2.data != null) {
                          return new Column(
                            children: <Widget>[
                              new Expanded(
                                child: new ListView(
                                  children: snapshot2.data.documents.where((document)=> followingList.contains(document["user_id"]))
                                      .map<Widget>((DocumentSnapshot document) {
                                    return new SocialFeedWidget(
                                      filter: false,
                                      articleID: document['article'],
                                      article_header: document['article_title'],
                                      userName: document['author'],
                                      spectrumValue: document['spectrum_value'].toDouble(),
                                      comment: document['comment'],
                                      fullName: document['firstName'] + " " + document['lastName'],
                                      user_id: document['user_id'],
                                      posterFirstName: userFirstName,
                                      posterLastName: userLastName,
                                      posterUserName: username,
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
                    });
              }
            }),

),
    );

  }
}




