import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_stream/FireNewsGetter.dart';
import 'package:news_app/pages/news_page.dart';

class FirePageCreator extends StatelessWidget {
  FirePageCreator({
    Key key,
    this.nameOfNewsday,
    this.indexPosition,
  }) : super(key: key);

  final String nameOfNewsday;
  final int indexPosition;

  Widget _buildPage({String nameOfNewsday, int position}) {
    return new FireNewsGetter(arrayValue: position, nameOfDoc: nameOfNewsday,);
  }

  Widget _buildPageView() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < 2; i++) {
      list.add(_buildPage(position: i, nameOfNewsday: nameOfNewsday));
      print("Position is $i");
    }
    final controller = PageController(initialPage: indexPosition,);
    return PageView(controller: controller ,children: list);

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _buildPageView(),
    );
  }
}

