import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/pages/PageCreator.dart';

Future<NewsdaysList> fetchNewsdaysList(url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return NewsdaysList.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class NewsdaysList {
  final List<Newsday> newsdays;

  NewsdaysList({
    this.newsdays,
  });

  factory NewsdaysList.fromJson(List<dynamic> parsedJson) {
    List<Newsday> newsdays = new List<Newsday>();
    newsdays = parsedJson.map((i) => Newsday.fromJson(i)).toList();
    return new NewsdaysList(newsdays: newsdays);
  }
}

class Newsday {
  final String id;
  final String title;
  final String url;
  final List<String> articles;
  final String created;

  Newsday({
    this.id,
    this.title,
    this.url,
    this.articles,
    this.created,
  });

  factory Newsday.fromJson(Map<String, dynamic> parsedJson) {
    var articlesFromJson = parsedJson['articles'];

    List<String> articlesList = new List<String>.from(articlesFromJson);
    return new Newsday(
      id: parsedJson['id'].toString(),
      title: parsedJson['title'].toString(),
      url: parsedJson['url'].toString(),
      articles: articlesList,
      created: parsedJson['created_at'],
    );
  }
}

class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new FutureBuilder<NewsdaysList>(
          future: fetchNewsdaysList("http://127.0.0.1:8000/api/v2/newsdays/"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final totalNewsdays = snapshot.data.newsdays.length;
              final listOfUrl = snapshot.data.newsdays[totalNewsdays-1].articles;
              return new PageCreator(urlList: listOfUrl);
            }
            else {
              return new Text("Error");
            }
          }),
    );
  }
}
