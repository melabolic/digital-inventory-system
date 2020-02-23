import 'package:flutter/material.dart';
import 'screens/display_items.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DisplayItems(),
    );
  }
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'test app',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: DisplayItems(),
//     );
//   }
// }
