import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/notifications/notifications_widget.dart';

class NotificationsHome extends StatelessWidget {
  final String thisUserID;

  NotificationsHome({this.thisUserID});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: new Container(
            child: new FutureBuilder(
          future: Firestore.instance
              .collection('notifications')
              .document('notifications')
              .collection(thisUserID)
              .orderBy('date', descending: true)
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
                          return new NotificationsWidget(
                            thisUserID: thisUserID,
                            otherUserID: document['other_userID'],
                            message: document['message'],
                            seen: document['seen'],
                            type: document['type'],
                            otherUsername: document['other_username'],
                            post: document['post'],
                            createdAt: document['date'],
                            notificationID: document.documentID,
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              }
            } else
              return new CircularProgressIndicator();
          },
        )));
  }
}
