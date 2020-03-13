import 'package:flutter/material.dart';
import 'screens/display_items.dart';

// this file runs our app
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: InventoryHeader(),
    );
  }
}

