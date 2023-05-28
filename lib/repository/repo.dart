import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';

class Repository {
  Dio dio = Dio();
  final String _noInternetConnection = 'No Internet Connection';

  dynamic _catchError(String method, dynamic error) {
    if (error is DioError) {
      try {
        return DataErrorHelper(
          error: error.response.toString().trim(),
        );
      } catch (newError) {
        return DataErrorHelper(
          error: error.response.toString().trim(),
        );
      }
    } else {
      return DataErrorHelper(
        error: error.toString().trim(),
      );
    }
  }

  Future<bool> _checkUserHasInternet() async {
    bool result = false;
    await Connectivity().checkConnectivity().then((value) {
      if (value.name != 'none') {
        result = true;
      }
    });
    return result;
  }

  Future<dynamic> initGet() async {
    String method = 'initGet';
    Response r;
    bool userHasInternet = await _checkUserHasInternet();

    if (!userHasInternet) {
      return DataErrorHelper(
        error: _noInternetConnection,
        noConnection: true,
      );
    }

    try {
      InitialNews initNews = InitialNews();
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
    } catch (error) {
      return _catchError(method, error);
    }
  }

  Future<dynamic> refresh(InitialNews currentQuery, String key, String refreshType) async {
    String method = 'refresh';
    Response r;
    bool userHasInternet = await _checkUserHasInternet();
    if (!userHasInternet) {
      return DataErrorHelper(
        error: _noInternetConnection,
        noConnection: true,
      );
    }

    try {
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
      
    } catch (error) {
      return _catchError(method, error);
    }
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
