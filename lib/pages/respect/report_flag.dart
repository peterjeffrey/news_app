import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/respect/confirm_report.dart';

class ReportWidget extends StatelessWidget {

  final String postID;
  final String content;
  final String reportedUser;
  final String reportingUserID;

  ReportWidget({Key key, this.postID, this.content, this.reportedUser, this.reportingUserID});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) => new ConfirmReport(content: content, username: reportedUser, reportingUserID: reportingUserID, postID: postID,),
                fullscreenDialog: true)
        );},
      child: new Row(
        children: <Widget>[
          new Icon(
            Icons.flag,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}


