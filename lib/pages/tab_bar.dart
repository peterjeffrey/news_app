import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth.dart';
import 'package:news_app/components/logo.dart';
import 'package:news_app/pages/news_stream/FireNewsGetter.dart';
import 'package:news_app/pages/news_stream/FireNewsView.dart';
import 'package:news_app/pages/PageCreator.dart';
import 'package:news_app/pages/NewsView.dart';
import 'package:news_app/pages/TakesView.dart';
import 'package:news_app/pages/news_page.dart';
import 'package:news_app/pages/news_stream/PostGetter.dart';
import 'package:news_app/pages/news_stream/social_feed.dart';
import 'package:news_app/pages/settings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:news_app/pages/social_page.dart';


class NavBar extends StatefulWidget {
  NavBar({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;


  @override
  NavBarState createState() => NavBarState(auth: auth, onSignedOut: onSignedOut);
}

class NavBarState extends State<NavBar> {

  NavBarState({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  int currentTab = 0;
//  NewsView news;
  FireNewsView fireNewsView;
  SocialFeed socialFeed;
//  SocialPage socialPage;
  List<Widget> views;
  Widget currentView;
  String _userEmail = "User email";




  @override
  void initState() {
//    news = NewsView();
    fireNewsView = FireNewsView();
    socialFeed = SocialFeed();
//    postGetter = PostGetter();
//    socialPage = SocialPage();
    views = [fireNewsView, socialFeed];
    currentView = fireNewsView;
    super.initState();
  }

  void signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext) {
    return new Scaffold(
      appBar: new AppBar(elevation: 0.0,),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new FutureBuilder<FirebaseUser>(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
//                      return new Text(snapshot.data.uid);
                        String userNumber = snapshot.data.uid;
                        return new FutureBuilder(
                            future: getUser(userNumber),
                          builder: (context, AsyncSnapshot<User> snapshot) {
                            if (snapshot?.data == null) return new Center(child: new Text("Loading..."),);
                            return new Text(snapshot.data.username.toString());
                          },
                        );
                    }
                    else {
                      return new Text('Loading...');
                    }
                  },
                ),
                accountEmail: new FutureBuilder<FirebaseUser>(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
//                      return new Text(snapshot.data.uid);
                      String userNumber = snapshot.data.uid;
                      return new FutureBuilder(
                        future: getUser(userNumber),
                        builder: (context, AsyncSnapshot<User> snapshot) {
                          if (snapshot?.data == null) return new Center(child: new Text("Loading..."),);
                          return new Text(snapshot.data.email.toString());
                        },
                      );
                    }
                    else {
                      return new Text('Loading...');
                    }
                  },
                ),
              currentAccountPicture: new Logo(),
            ),

            new ListTile(
              title: new Text('LOGOUT'),
              trailing: new Icon(Icons.power_settings_new),
              onTap: ()=> signOut(),
            ),
            new Divider(),
            new ListTile(
              title: new Icon(Icons.close),
              onTap: ()=> Navigator.of(context).pop(),
            ),
            new Divider(),
          ],
        ),
      ),
      body: currentView,
      bottomNavigationBar: new CupertinoTabBar(
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              currentView = views[index];
            });
          },
          activeColor: Color.fromRGBO(144, 19, 254, 1.0),
          items: const <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: const Icon(Icons.subject),
              title: const Text('News'),
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.forum),
              title: const Text('Social'),
            ),
          ]),
    );
  }
}

Future<User> getUser(idNumber) {
  return Firestore.instance
      .collection('user')
      .document('$idNumber')
      .get()
      .then((snapshot) {
    try {
      return User.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  });
}

class User {
  String email;
  String user_id;
  String username;
  User.fromSnapshot(DocumentSnapshot snapshot)
      : email = snapshot['email'],
        user_id = snapshot['user_id'],
        username = snapshot['username'];
}
