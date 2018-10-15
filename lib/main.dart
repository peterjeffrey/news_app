import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/pages/LoginPage.dart';
import 'package:news_app/pages/root_page.dart';
import 'package:news_app/pages/tab_bar.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new PublickApp());

class PublickApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PublickState();
  }
}

class PublickState extends State<PublickApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(250, 250, 250, 1.0),
        hintColor: Color.fromRGBO(144, 19, 254, 1.0),
        cursorColor: Color.fromRGBO(144, 19, 254, 1.0),
      ),
      home: new RootPage(auth: new Auth()),
//      new Scaffold(
//        bottomNavigationBar: new NavBar(),
//      ),
    );
  }
}
