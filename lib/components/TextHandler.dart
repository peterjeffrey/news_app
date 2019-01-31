import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class TextHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: _launchURL,
          child: Text('Show Flutter homepage'),
        ),
      ),
    );
  }
}

_launchURL() async {
  const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

InkWell textURL(String message, String url) {

  return InkWell(
    onTap: _launchURL,
    child: Text('Show Flutter homepage'),
  );
}