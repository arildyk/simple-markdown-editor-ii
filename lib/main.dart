import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:flutter/material.dart';

import 'package:simple_markdown_editor_ii/pages/home_page.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initSize = Size(500, 300);
    win.minSize = initSize;
    win.alignment = Alignment.center;
    win.title = "Simple Markdown Editor II";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'EBGaramond',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
