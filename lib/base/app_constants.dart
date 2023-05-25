import 'package:flutter/widgets.dart';

class AppColors {
  Color mainColor = const Color(0xFF0f1c25);
  Color pinkColor = const Color(0xff8f0252);
}

final appColors = AppColors();

class AppMetrix {
  final screenwidth = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width;
  final screenheight = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height;
}

final metrix = AppMetrix();
