import 'package:flutter/material.dart';


Text getDate(Duration differenceValue) {
  if (differenceValue.inDays >= 1) {
    if (differenceValue.inDays == 1){
      return Text("Posted " + differenceValue.inDays.toString() + " day ago");
    }
    else {
      return Text("Posted " + differenceValue.inDays.toString() + " days ago");
    }

  }
  else if (differenceValue.inHours >= 1){
    if (differenceValue.inHours == 1) {
      return Text("Posted " + differenceValue.inHours.toString() + " hour ago");
    }
    else {
      return Text("Posted " + differenceValue.inHours.toString() + " hours ago");
    }
  }
  else if (differenceValue.inMinutes >= 1) {
    if (differenceValue.inMinutes == 1){
      return Text("Posted " + differenceValue.inMinutes.toString() + " minute ago");
    }
    else {
      return Text("Posted " + differenceValue.inMinutes.toString() + " minutes ago");
    }

  }
  else  {
    if (differenceValue.inSeconds.toString() == 1) {
      return Text("Posted " + differenceValue.inSeconds.toString() + " second ago");
    }
    else {
      return Text("Posted " + differenceValue.inSeconds.toString() + " seconds ago");
    }

  }
}