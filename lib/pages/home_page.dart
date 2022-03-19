import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import 'package:highlight/languages/markdown.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:simple_markdown_editor_ii/config/markdown_stylesheet.dart';
import 'package:simple_markdown_editor_ii/widgets/left_window_title_bar_box.dart';
import 'package:simple_markdown_editor_ii/widgets/right_window_title_bar_box.dart';

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    if (file == null) {
      saveAs();
    } else {
      await file!.writeAsString(source);
    }
  }

  Future<void> saveAs() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save As',
      fileName: file == null ? '' : basename(file!.path),
      type: FileType.custom,
      allowedExtensions: ['md'],
    );

    if (outputFile == null) {
      // User cancelled the picker
    }

    setState(() {
      file = File(outputFile! + '.md');
    });

    await file!.writeAsString(source);
  }

  void newFile() {
    setState(() {
      source = '# Lorem ipsum...';
      file = null;
    });
  }

  Future<void> exportToPDF() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export To PDF',
      fileName: file == null ? '' : basename(file!.path),
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (outputFile == null) {
      // User cancelled the picker
    }

    setState(() {
      file = File(outputFile!);
    });
  }

  Future<void> exportToHTML() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export To HTML',
      fileName: file == null ? '' : basename(file!.path),
      type: FileType.custom,
      allowedExtensions: ['html'],
    );

    if (outputFile == null) {
      // User cancelled the picker
    }

    setState(() {
      file = File(outputFile! + '.html');
    });

    await file!.writeAsString(md.markdownToHtml(source));
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
                  LeftWindowTitleBarBox(
                    file: file,
                    openFile: openFile,
                    saveFile: saveFile,
                    saveAs: saveAs,
                    newFile: newFile,
                    exportToPDF: exportToPDF,
                    exportToHTML: exportToHTML,
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
                  RightWindowTitleBarBox(file: file),
                  Expanded(
                    child: Markdown(
                      data: source,
                      styleSheet: markdownStylesheet(context),
                      onTapLink: (text, href, title) async =>
                          await launch(href!),
                      selectable: true,
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
