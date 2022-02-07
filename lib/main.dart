import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hava Durumu",
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
