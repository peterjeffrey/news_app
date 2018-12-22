import 'package:flutter/material.dart';
import 'package:news_app/objects/UserFollower.dart';
import 'package:news_app/pages/profile/find_followers_widget.dart';

class FindFollowersSearch extends SearchDelegate<UserFollower> {

  FindFollowersSearch({this.friendsList});
  final List<UserFollower> friendsList;
//  final friendsList = [UserFollower("Peter", "PJ"), UserFollower("Jonathan", "JJ")];
//  final suggestedFriendsList = [UserFollower("Peter", "PJ"),];
  final suggestedFriendsList = [];


  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on left of appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? suggestedFriendsList
        : friendsList.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    // return futurebuilder of
    return ListView.builder(
      itemBuilder: (context, index) => FindFollowerWidget(
        name: suggestionList[index].name,
        username: suggestionList[index].username,
        userID: suggestionList[index].userID,
        otherUserID: suggestionList[index].otherUserID,
      ),
//      itemBuilder: (context, index) => ListTile(
//            leading: Icon(Icons.location_city),
//            title: Text(suggestionList[index]),
//          ),
      itemCount: suggestionList.length,
    );
  }
}


