import 'package:flutter/material.dart';

import '../models/document_model.dart';
import '../services/document_service.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentService _service = DocumentService();

  List<DocumentModel> _documents = [];

  List<DocumentModel> get documents => _documents;

  Future<void> loadDocuments() async {
    _documents = await _service.getDocuments();
    notifyListeners();
  }

  Future<void> addDocument(DocumentModel document) async {
    await _service.addDocument(document);
    await loadDocuments();
  }

  Future<void> deleteDocument(int index) async {
    await _service.deleteDocument(index);
    await loadDocuments();
  }
}