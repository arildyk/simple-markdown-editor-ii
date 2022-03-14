import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:highlight/languages/markdown.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:path/path.dart';

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
  File? file;
  String source = '# Lorem ipsum...';

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

  Future<void> openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md'],
    );

    if (result != null) {
      file = File(result.files.single.path!);
      final contents = await file!.readAsString();
      setState(() {
        _codeController!.text = contents;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> saveFile() async {
    await file!.writeAsString(source);
  }

  Future<void> saveAs() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Select an output file:',
      fileName: basename(file!.path),
    );
    if (outputFile == null) {
      // User cancelled the picker
    }
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
                    child: MoveWindow(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                          top: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              value: null,
                              hint: const Text(
                                'File',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              underline: const SizedBox(),
                              onChanged: (value) {
                                switch (value) {
                                  case 'Open':
                                    openFile();
                                    break;
                                  case 'Save':
                                    saveFile();
                                    break;
                                  case 'Save As':
                                    saveAs();
                                    break;
                                }
                              },
                              dropdownColor: vs2015Theme.values
                                  .toList()
                                  .first
                                  .backgroundColor,
                              focusColor: vs2015Theme.values
                                  .toList()
                                  .first
                                  .backgroundColor,
                              items: [
                                'Open',
                                'Save',
                                'Save As',
                                'Export',
                                'New File',
                              ].map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(2.0),
                                child: Text(
                                  file!.parent.path,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
            MoveWindow(
              child: const VerticalDivider(
                indent: 10.0,
                endIndent: 10.0,
                color: Color(0xff4E4545),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  WindowTitleBarBox(
                    child: MoveWindow(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.all(2.0),
                              child: Text(
                                basename(file!.path),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Row(
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
                                  mouseOver:
                                      const Color.fromARGB(255, 199, 0, 0),
                                  iconMouseOver: Colors.white,
                                ),
                              ),
                            ],
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
                        tableBorder: TableBorder.all(
                          color: Colors.white,
                        ),
                        tableHead: const TextStyle(
                          color: Colors.white,
                        ),
                        tableBody: const TextStyle(
                          color: Colors.white,
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
