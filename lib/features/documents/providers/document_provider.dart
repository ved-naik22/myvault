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

  Future<void> addDocument(
    DocumentModel document,
  ) async {
    await _service.addDocument(document);
    await loadDocuments();
  }

  Future<void> updateDocument(
    int index,
    DocumentModel document,
  ) async {
    await _service.updateDocument(
      index,
      document,
    );

    await loadDocuments();
  }

  Future<void> deleteDocument(
    int index,
  ) async {
    await _service.deleteDocument(index);
    await loadDocuments();
  }

  Future<void> toggleFavorite(
    int index,
  ) async {
    if (index < 0 ||
        index >= _documents.length) {
      return;
    }

    final document = _documents[index];

    final updatedDocument = DocumentModel(
      title: document.title,
      category: document.category,
      notes: document.notes,
      filePath: document.filePath,
      createdAt: document.createdAt,
      isFavorite: !document.isFavorite,
      isPinned: document.isPinned,
    );

    await _service.updateDocument(
      index,
      updatedDocument,
    );

    await loadDocuments();
  }

  Future<void> togglePinned(
    int index,
  ) async {
    if (index < 0 ||
        index >= _documents.length) {
      return;
    }

    final document = _documents[index];

    final updatedDocument = DocumentModel(
      title: document.title,
      category: document.category,
      notes: document.notes,
      filePath: document.filePath,
      createdAt: document.createdAt,
      isFavorite: document.isFavorite,
      isPinned: !document.isPinned,
    );

    await _service.updateDocument(
      index,
      updatedDocument,
    );

    await loadDocuments();
  }
}