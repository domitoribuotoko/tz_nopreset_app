import 'package:dio/dio.dart';

class News {
  String? id;
  String? img;
  String? date;
  String? title;
  int? important;
  String? subtitle;

  News({
    this.id,
    this.img,
    this.date,
    this.title,
    this.important,
    this.subtitle,
  });

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    date = json['date'];
    title = json['title'];
    important = json['important'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    data['date'] = date;
    data['title'] = title;
    data['important'] = important;
    data['subtitle'] = subtitle;
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? date;
  String? text;
  String? url;
  List<Gallery>? gallery;
  String? img;

  Data({this.id, this.title, this.date, this.text, this.url, this.gallery, this.img});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    text = json['text'];
    url = json['url'];
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(Gallery.fromJson(v));
      });
    }
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['text'] = text;
    data['url'] = url;
    if (gallery != null) {
      data['gallery'] = gallery!.map((v) => v.toJson()).toList();
    }
    data['img'] = img;
    return data;
  }
}

class Gallery {
  int? sortId;
  String? smallImg;
  String? bigImg;

  Gallery({this.sortId, this.smallImg, this.bigImg});

  Gallery.fromJson(Map<String, dynamic> json) {
    sortId = json['sortId'];
    smallImg = json['smallImg'];
    bigImg = json['bigImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sortId'] = sortId;
    data['smallImg'] = smallImg;
    data['bigImg'] = bigImg;
    return data;
  }
}

class InitialNews {
  List<News> all = [];
  List<News> top = [];
  List<News> articles = [];
}

class DataErrorHelper {
  final String error;
  final bool noConnection;
  final String? responseError;
  final int responseCode;

  DataErrorHelper({
    required this.error,
    this.noConnection = false,
    this.responseError,
    this.responseCode = 0,
  });
}

class ResponseDataHelper {
  final dynamic dynamicData;
  final Response dioResponse;

  ResponseDataHelper({
    required this.dynamicData,
    required this.dioResponse,
  });
}
