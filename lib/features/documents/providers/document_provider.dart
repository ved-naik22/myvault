import 'package:flutter/material.dart';

import '../models/document_model.dart';
import '../services/document_service.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentService _service = DocumentService();

  List<DocumentModel> _documents = [];
  List<DocumentModel> _filteredDocuments = [];

  List<DocumentModel> get documents => _filteredDocuments;

  Future<void> loadDocuments() async {
    _documents = await _service.getDocuments();
    _filteredDocuments = List.from(_documents);
    notifyListeners();
  }

  Future<void> addDocument(DocumentModel document) async {
    await _service.addDocument(document);
    await loadDocuments();
  }

  Future<void> updateDocument(
    int index,
    DocumentModel document,
  ) async {
    await _service.updateDocument(index, document);
    await loadDocuments();
  }

  Future<void> deleteDocument(int index) async {
    await _service.deleteDocument(index);
    await loadDocuments();
  }

  void searchDocuments(String query) {
    if (query.trim().isEmpty) {
      _filteredDocuments = List.from(_documents);
    } else {
      _filteredDocuments = _documents.where((doc) {
        return doc.title
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            doc.category
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}