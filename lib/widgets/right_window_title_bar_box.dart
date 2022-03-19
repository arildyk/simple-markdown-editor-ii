import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class RightWindowTitleBarBox extends StatelessWidget {
  final File? file;

  const RightWindowTitleBarBox({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: MoveWindow(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  file == null ? '' : basename(file!.path),
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
                    mouseOver: const Color.fromARGB(255, 199, 0, 0),
                    iconMouseOver: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
