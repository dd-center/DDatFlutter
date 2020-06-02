import 'package:flutter/material.dart';
import 'package:DDatFlutter/test/demo_page.dart';

class DemoApp extends StatelessWidget {
  DemoApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: DemoPage());
  }
}
