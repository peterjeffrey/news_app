import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/news_page.dart';

class PageCreator extends StatelessWidget {
  PageCreator({
    Key key,
    this.urlList,
    this.onLayoutToggle,
  }) : super(key: key);
  final List<String> urlList;
  final VoidCallback onLayoutToggle;

  Widget _buildPage({int index, String url}) {
    return new NewsPage(url: url);
  }

  Widget _buildPageView() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < urlList.length; i++) {
      list.add(_buildPage(index: i + 1, url: urlList[i]));
    }
    return PageView(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
    );
  }
}
