import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:highlight/languages/markdown.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

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
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CodeController? _codeController;
  var source = "# simple-markdown-editor\nA Markdown Editor created powered by Java that uses GitHub Markdown flavouring." +
      " The most important aspects of this application are the abilities to open a Markdown file, allow the user to edit the file, and finally save the file.\n" +
      "\n## Built With\n"
          "- [commonmark-java](https://github.com/commonmark/commonmark-java)\n" +
      "- [JavaFX](https://openjfx.io/)\n" +
      "- [Prism.js](https://prismjs.com/)\n" +
      "- [JSoup](https://jsoup.org/)\n" +
      "- [RichTextFX](https://github.com/FXMisc/RichTextFX)\n" +
      "- [Flying Saucer](https://github.com/flyingsaucerproject/flyingsaucer)\n" +
      "- [iText 2.1.7](https://github.com/hwinkler/itext2)\n\n" +
      "## Installation\nClone the repository. With JavaFX installed, inside `.vscode`, change the paths to the JavaFX jar files to your own paths in the *settings.json*. " +
      "In the *launch.json* on the `vmArgs`, change the module path to your own. Run the application with `App.java`.\n\n" +
      "## License\nDistributed under the MIT License. See `LICENSE` for more information.";

  @override
  void initState() {
    super.initState();
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: markdown,
      theme: vs2015Theme,
      onChange: (text) {
        setState(() {
          source = text;
        });
      },
      patternMap: {
        r"\B# .+\b|\B## .+\b|\B### .+\b|\B#### .+\b|\B##### .+\b|\B###### .+\b":
            TextStyle(
          fontWeight: FontWeight.bold,
          color: vs2015Theme.values.toList()[2].backgroundColor,
        ),
      },
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: vs2015Theme.values.toList().first.backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  WindowTitleBarBox(
                    child: SizedBox(
                      child: MoveWindow(),
                    ),
                  ),
                  Expanded(
                    child: CodeField(
                      controller: _codeController!,
                      textStyle: const TextStyle(
                        fontFamily: 'Consolas',
                      ),
                      expands: true,
                      lineNumberStyle: const LineNumberStyle(
                        width: 58,
                        margin: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              indent: 10.0,
              endIndent: 10.0,
              color: Color(0xff4E4545),
            ),
            Expanded(
              child: Column(
                children: [
                  WindowTitleBarBox(
                    child: MoveWindow(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MinimizeWindowButton(
                            animate: true,
                            colors: WindowButtonColors(
                              iconNormal: const Color(0xffC8CBBE),
                            ),
                          ),
                          MaximizeWindowButton(
                            animate: true,
                            colors: WindowButtonColors(
                              iconNormal: const Color(0xffC8CBBE),
                            ),
                          ),
                          CloseWindowButton(
                            animate: true,
                            colors: WindowButtonColors(
                              iconNormal: const Color(0xffC8CBBE),
                              mouseOver: const Color.fromARGB(255, 199, 0, 0),
                              iconMouseOver: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Markdown(
                      data: source,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(
                        h1: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                        h2: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        h3: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.72,
                        ),
                        h4: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        h5: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.28,
                        ),
                        h6: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.72,
                        ),
                        p: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        code: const TextStyle(
                          color: Colors.white,
                          backgroundColor: Color(0xff595A53),
                          fontFamily: 'Consolas',
                          fontSize: 16,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: const Color(0xff595A53),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        listBullet: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
