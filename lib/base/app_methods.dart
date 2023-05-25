import 'package:intl/intl.dart';

class AppMethods {
  String adaptiveShowTime(String date) {
    date = insertSpaces(date);

    DateTime current = DateTime.now();
    DateTime newsDate = DateFormat('dd MM yy HH mm ss').parse(date);
    Duration difference = current.difference(newsDate);
    if (difference > const Duration(days: 1)) {
      return DateFormat('dd MMM, HH:mm').format(newsDate);
    } else {
      return current.day == newsDate.day
          ? DateFormat('HH:mm').format(newsDate)
          : DateFormat('dd MMM, HH:mm').format(newsDate);
    }
  }

  String showTime(String date) {
    date = insertSpaces(date);
    DateTime newsDate = DateFormat('dd MM yy HH mm ss').parse(date);
    return DateFormat('dd MMM, HH:mm').format(newsDate);
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
