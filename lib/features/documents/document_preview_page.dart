import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentPreviewPage extends StatelessWidget {
  final String title;
  final String filePath;

  const DocumentPreviewPage({
    super.key,
    required this.title,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final path = filePath.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Builder(
        builder: (context) {
          if (path.endsWith('.pdf')) {
            return SfPdfViewer.file(
              File(filePath),
            );
          }

          if (path.endsWith('.jpg') ||
              path.endsWith('.jpeg') ||
              path.endsWith('.png')) {
            return InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.contain,
                ),
              ),
            );
          }

          return const Center(
            child: Text(
              'Unsupported file type',
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}