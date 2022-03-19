import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

class LeftWindowTitleBarBox extends StatelessWidget {
  final File? file;
  final Function openFile;
  final Function saveFile;
  final Function saveAs;
  final Function newFile;
  final Function exportToPDF;
  final Function exportToHTML;

  const LeftWindowTitleBarBox({
    Key? key,
    required this.file,
    required this.openFile,
    required this.saveFile,
    required this.saveAs,
    required this.newFile,
    required this.exportToPDF,
    required this.exportToHTML,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: MoveWindow(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
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
                    case 'New File':
                      newFile();
                      break;
                    case 'Export To PDF':
                      exportToPDF();
                      break;
                    case 'Export To HTML':
                      exportToHTML();
                      break;
                  }
                },
                dropdownColor:
                    vs2015Theme.values.toList().first.backgroundColor,
                focusColor: vs2015Theme.values.toList().first.backgroundColor,
                items: [
                  'Open',
                  'Save',
                  'Save As',
                  'New File',
                  'Export To PDF',
                  'Export To HTML',
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
                  margin: const EdgeInsets.only(
                    top: 2.0,
                    bottom: 2.0,
                    left: 2.0,
                  ),
                  child: Text(
                    file == null ? '' : file!.parent.path,
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
    );
  }
}
