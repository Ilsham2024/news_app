import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_news_app/model/new_model.dart';

class NewsApi {
  // for news home screen
  List<NewsModel> dataStore = [];
  Future<void> getNews() async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=313e712139fc486796d895c700aef894");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData["status"] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          NewsModel newsModel = NewsModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );
          dataStore.add(newsModel);
        }
      });
    }
  }
}

class CategoryNews {
  // for news home screen
  List<NewsModel> dataStore = [];
  Future<void> getNews(String category) async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=68445da1471b402fb72c147af018db4f");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          NewsModel newsModel = NewsModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );
          dataStore.add(newsModel);
        }
      });
    }
  }
}
