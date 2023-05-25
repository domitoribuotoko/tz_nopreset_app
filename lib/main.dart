import 'package:flutter/material.dart';
import 'package:tz_nopreset_app/pages/main_controller_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: const Color.fromARGB(255, 10, 13, 15),
        highlightColor: Colors.transparent,
      ),
      home: const MainController(),
    );
  }
}
