import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

MarkdownStyleSheet markdownStylesheet(BuildContext context) {
  return MarkdownStyleSheet.fromTheme(
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
      color: Color(0xffD7BA7D),
      backgroundColor: Color(0xff1E1E1E),
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
  );
}
