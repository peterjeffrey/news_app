import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/TimeConverter.dart';
import 'package:news_app/pages/profile/GetOtherProfilePage.dart';

class NotificationsWidget extends StatelessWidget {



  final String message;
  final String thisUserID;
  final String otherUserID;
  final bool seen;
  final String type;
  final String otherUsername;
  final String post;
  final DateTime createdAt;
  final String notificationID;

  NotificationsWidget({this.createdAt, this.message, this.otherUserID, this.seen, this.thisUserID, this.type, this.otherUsername, this.post, this.notificationID});

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    double c_height = MediaQuery.of(context).size.height * 0.12;
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);


    if (type == "like") {
      if (seen == false) {
        Firestore.instance
            .collection('notifications')
            .document('notifications')
            .collection(thisUserID)
            .document(notificationID)
            .updateData({
          'date': createdAt,
          'other_userID': otherUserID,
          'other_username': otherUsername,
          'post': post,
          'message': message,
          'type': 'like',
          'seen': true,
        });
        return new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: new FlatButton(
            color: Color.fromRGBO(110, 45, 180, .1),
            onPressed: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new GetOtherProfilePage(
                    posterID: otherUserID,
                    myUserID: thisUserID,
                  ),
                  fullscreenDialog: true),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(otherUsername, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                            new Text(" liked your post.", style: new TextStyle(fontSize:
                            16.0),),
                          ]),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Text(post, overflow: TextOverflow.ellipsis, style: new TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            getDate(difference),
                          ],
                        ),
                      ),



                    ],
                  ),
                  height: c_height,
                ),

                new Padding(
                  child: new Divider(
                    color: Color.fromRGBO(74, 74, 74, 1.0),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                ),
              ],
            ),
          ),
        );


      }
      else {
        return new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: new FlatButton(
            onPressed: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new GetOtherProfilePage(
                    posterID: otherUserID,
                    myUserID: thisUserID,
                  ),
                  fullscreenDialog: true),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(otherUsername, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                            new Text(" liked your post.", style: new TextStyle(fontSize:
                            16.0),),
                          ]),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Text(post, overflow: TextOverflow.ellipsis, style: new TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            getDate(difference),
                          ],
                        ),
                      ),



                    ],
                  ),
                  height: c_height,
                ),

                new Padding(
                  child: new Divider(
                    color: Color.fromRGBO(74, 74, 74, 1.0),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                ),
              ],
            ),
          ),
        );
      }

    }

    else if (type == "follow") {
      if (seen == false) {
        Firestore.instance
            .collection('notifications')
            .document('notifications')
            .collection(thisUserID)
            .document(notificationID)
            .updateData({
            'date': createdAt,
            'other_userID': otherUserID,
            'other_username': otherUsername,
            'type': 'follow',
            'seen': true,});

        return new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: new FlatButton(
            color: Color.fromRGBO(110, 45, 180, .1),
            onPressed: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new GetOtherProfilePage(
                    posterID: otherUserID,
                    myUserID: thisUserID,
                  ),
                  fullscreenDialog: true),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(otherUsername, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                            new Text(" followed you.", style: new TextStyle(fontSize:
                            16.0),),
                          ]),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            getDate(difference),
                          ],
                        ),
                      ),



                    ],
                  ),
                  height: c_height,
                ),

                new Padding(
                  child: new Divider(
                    color: Color.fromRGBO(74, 74, 74, 1.0),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                ),
              ],
            ),
          ),
        );
      }
      else {
        return new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: new FlatButton(
            onPressed: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new GetOtherProfilePage(
                    posterID: otherUserID,
                    myUserID: thisUserID,
                  ),
                  fullscreenDialog: true),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(otherUsername, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                            new Text(" followed you.", style: new TextStyle(fontSize:
                            16.0),),
                          ]),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            getDate(difference),
                          ],
                        ),
                      ),



                    ],
                  ),
                  height: c_height,
                ),

                new Padding(
                  child: new Divider(
                    color: Color.fromRGBO(74, 74, 74, 1.0),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                ),
              ],
            ),
          ),
        );
      }

    }

    else {
      return CircularProgressIndicator();
    }



  }

}
