import 'package:flutter/material.dart';
import 'package:cat_tinder/src/presenter/cat_presenter.dart';
import 'package:cat_tinder/src/view/cat_view.dart';

void main() {
  runApp(const CattinderApp());
}

class CattinderApp extends StatelessWidget {
  const CattinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кототиндер',
      theme: ThemeData.dark(),
      home: CatScreen(),
    );
  }
}
