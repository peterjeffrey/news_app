import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/Troubleshooting/NewsLandingPage.dart';
import 'package:news_app/pages/news_stream/FireNewsGetter.dart';
import 'package:news_app/pages/news_page.dart';
import 'package:news_app/reducers/main_reducer.dart';
import 'package:news_app/store/store.dart';

class FirePageCreator extends StatelessWidget {
  FirePageCreator({
    Key key,
    this.firstName,
    this.lastName,
    this.username,
    this.userID,
    this.nameOfNewsday,
  }) : super(key: key);

  final String nameOfNewsday;
  final String firstName;
  final String lastName;
  final String username;
  final String userID;

  Widget _buildPage({String nameOfNewsday, int position}) {
    return new FireNewsGetter(
      arrayValue: position,
      nameOfDoc: nameOfNewsday,
      userID: userID,
      firstName: firstName,
      lastName: lastName,
      userName: username,
    );
  }

  Widget _buildPageView() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < 2; i++) {
      list.add(_buildPage(position: i, nameOfNewsday: nameOfNewsday));
    }
    return new StoreConnector<AppState, int>(
      converter: (store) => store.state.currentPageViewIndex,
      builder: (context, int pageViewIndex) {
        return StoreConnector<AppState, Function>(
          converter: (store) => (int input) => store.dispatch(ActionContainer(
              type: Action.TogglePageViewIndex, payload: input)),
          builder: (context, callback) {
            return PageView(
                controller: PageController(initialPage: pageViewIndex),
                onPageChanged: callback,
                children: list);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildPageView(),
    );
  }
}
