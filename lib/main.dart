import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/pages/LoginPage.dart';
import 'package:news_app/pages/news_stream/FireNewsView.dart';
import 'package:news_app/pages/root_page.dart';
import 'package:news_app/pages/tab_bar.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/store/store.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:news_app/reducers/main_reducer.dart';

void main() {
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final store = new Store<AppState>(handleUpdate, initialState: AppState());

  runApp(new PublickApp(
    store: store,
  ));
}

class PublickApp extends StatefulWidget {
  final Store<AppState> store;
  PublickApp({Key key, this.store}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new PublickState();
  }
}

class PublickState extends State<PublickApp> {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: widget.store,
        child: new MaterialApp(
          theme: ThemeData(
            primaryColor: Color.fromRGBO(250, 250, 250, 1.0),
            hintColor: Color.fromRGBO(100, 45, 200, 1.0),
            cursorColor: Color.fromRGBO(100, 45, 200, 1.0),
          ),
          home: new RootPage(auth: new Auth()),
          routes: <String, WidgetBuilder>{
            '/news': (BuildContext context) => new FireNewsView(),
          },
//      new Scaffold(
//        bottomNavigationBar: new NavBar(),
//      ),
        ));
  }
}
