import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/courant_logo.png');
    var image = new Image(image: assetsImage, width: 180.0, height:180.0);
    return new Container(child:image);
  }
}