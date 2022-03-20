import 'dart:io';

import 'package:html/parser.dart' as html_parser;

import 'package:markdown/markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MarkdownToPDFHelper {
  static Future<void> convertToPDF(String markdown, File outputFile) async {
    final htmlConverted = markdownToHtml(markdown);
    var doc = html_parser.parse(htmlConverted);

    final pdf = pw.Document();
    var widgets = <pw.Widget>[];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: widgets,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
          );
        },
      ),
    );

    for (var child in doc.querySelectorAll('*')) {
      if (child.localName == 'h1') {
        widgets.add(
          pw.Text(
            child.text,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 28,
            ),
          ),
        );
      }

      if (child.localName == 'h2') {
        widgets.add(
          pw.Text(
            child.text,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
      }

      if (child.localName == 'p') {
        widgets.add(
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(bottom: 2.0, right: 2.0, top: 2.0),
            child: pw.Text(
              child.text,
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        );
      }

      if (child.localName == 'img') {
        widgets.add(
          pw.Expanded(
            child: pw.Image(
              pw.MemoryImage(
                File(child.attributes["src"].toString()).readAsBytesSync(),
              ),
            ),
          ),
        );
      }
    }

    await outputFile.writeAsBytes(await pdf.save());
  }
}
