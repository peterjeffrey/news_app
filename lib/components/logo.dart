import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/dogood_logo.png');
    var image = new Image(image: assetsImage, width: 115.0, height:115.0);
    return new Container(child:image);
  }
}