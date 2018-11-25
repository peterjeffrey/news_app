import 'package:news_app/store/store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
enum Action {
  ToggleTabIndex,
  TogglePageViewIndex
}


class ActionContainer{
  Action type;
  dynamic payload;
  ActionContainer({@required this.type, @required this.payload});
}

AppState handleUpdate(AppState input, dynamic action ){
  if (action is ActionContainer){
    var container = action as ActionContainer;
    if (container.type == Action.ToggleTabIndex) {
      debugPrint("inside here");
      input.currentTabIndex = container.payload as int;
    }
    if (container.type == Action.TogglePageViewIndex){
      input.currentPageViewIndex = container.payload as int;
    }
  }else{
    debugPrint("ignore");
  }
  return input;
}