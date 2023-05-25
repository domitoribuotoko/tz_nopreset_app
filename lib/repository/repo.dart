import 'package:dio/dio.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';

class Repository {
  Future<InitialNews> initGet() async {
    InitialNews initNews = InitialNews();
    Dio dio = Dio();
    Response r;

    r = await dio.get('https://sarnovosti.ru/api/list.php');
    for (var element in r.data) {
      initNews.all.add(News.fromJson(element));
    }

    dio.options.queryParameters['catId'] = 'top';
    r = await dio.get('https://sarnovosti.ru/api/list.php');
    for (var element in r.data) {
      initNews.top.add(News.fromJson(element));
    }

    dio.options.queryParameters['catId'] = 'article';
    r = await dio.get('https://sarnovosti.ru/api/list.php');
    for (var element in r.data) {
      initNews.articles.add(News.fromJson(element));
    }

    return initNews;
  }

  Future<InitialNews> refresh(InitialNews currentQuery, String key, String refreshType) async {
    Dio dio = Dio();
    Response r;
    String from = '0';
    String catId = '';
    late List<News> news;
    if (key == 'лента') {
      news = currentQuery.all;
    }
    if (key == 'важное') {
      news = currentQuery.top;
      catId = 'top';
    }
    if (key == 'статьи') {
      news = currentQuery.articles;
      catId = 'article';
    }
    if (refreshType == 'add') {
      from = news.last.date!;
    } else {
      news = [];
    }

    dio.options.queryParameters['catId'] = catId;
    dio.options.queryParameters['from'] = from;

    r = await dio.get('https://sarnovosti.ru/api/list.php');
    for (var element in r.data) {
      news.add(News.fromJson(element));
    }
    if (key == 'лента') {
      currentQuery.all = news;
    }
    if (key == 'важное') {
      currentQuery.top = news;
    }
    if (key == 'статьи') {
      currentQuery.articles = news;
    }

    return currentQuery;
  }

  Future<Data> getNewsDetailes(String id) async {
    Data newsDetailes = Data();
    Dio dio = Dio();
    Response r;
    dio.options.queryParameters['id'] = id;
    r = await dio.get('https://sarnovosti.ru/api/news.php');
    newsDetailes = Data.fromJson(r.data['data']);
    return newsDetailes;
  }
}
