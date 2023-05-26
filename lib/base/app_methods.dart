import 'package:intl/intl.dart';

class AppMethods {
  String adaptiveShowTime(String date) {
    date = insertSpaces(date);

    DateTime current = DateTime.now();
    DateTime newsDate = DateFormat('dd MM yy HH mm ss').parse(date);
    Duration difference = current.difference(newsDate);
    if (difference > const Duration(days: 1)) {
      return enMonToRu(DateFormat('dd MMMM, HH:mm').format(newsDate).toLowerCase());
    } else {
      return current.day == newsDate.day
          ? DateFormat('HH:mm').format(newsDate)
          : enMonToRu(DateFormat('dd MMMM, HH:mm').format(newsDate).toLowerCase());
    }
  }

  String enMonToRu(String n) {
    Map<String, String> months = {
      'january': 'января',
      'february': 'февраля',
      'march': 'марта',
      'april': 'апреля',
      'may': 'мая',
      'june': 'июня',
      'july': 'июля',
      'august': 'августа',
      'september': 'сентября',
      'october': 'октября',
      'november': 'ноября',
      'december': 'декабря'
    };
    for (var i = 0; i < months.length; i++) {
      if (n.contains(months.keys.elementAt(i))) {
        n = n.replaceAll(months.keys.elementAt(i), months.values.elementAt(i));
        i = months.length;
      }
    }
    return n;
  }

  String showTime(String date) {
    date = insertSpaces(date);
    DateTime newsDate = DateFormat('dd MM yy HH mm ss').parse(date);
    return enMonToRu(DateFormat('dd MMMM, HH:mm').format(newsDate).toLowerCase());
  }

  String insertSpaces(String s) {
    var start = 0;
    final strings = [];
    while (start < s.length) {
      final end = start + 2;
      strings.add('${s.substring(start, end)} ');
      start = end;
    }
    String f = '';
    for (var element in strings) {
      f = f + element;
    }
    return f.trim();
  }
}

final method = AppMethods();
