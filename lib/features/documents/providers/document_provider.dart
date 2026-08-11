import 'package:flutter/material.dart';

import '../models/document_model.dart';
import '../services/document_service.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentService _service = DocumentService();

  List<DocumentModel> _documents = [];
  List<DocumentModel> _filteredDocuments = [];

  String _searchQuery = "";
  String _selectedCategory = "All";

  List<DocumentModel> get documents => _filteredDocuments;

  String get selectedCategory => _selectedCategory;

  Future<void> loadDocuments() async {
    _documents = await _service.getDocuments();
    _applyFilters();
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
    if (index < 0 || index >= _filteredDocuments.length) {
      return;
    }

    final document = _filteredDocuments[index];

    final originalIndex = _documents.indexOf(document);

    if (originalIndex == -1) {
      return;
    }

    await _service.deleteDocument(originalIndex);
    await loadDocuments();
  }

  void searchDocuments(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = "";
    _selectedCategory = "All";
    _applyFilters();
  }

  void _applyFilters() {
    _filteredDocuments = _documents.where((document) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          document.title.toLowerCase().contains(_searchQuery) ||
          document.category.toLowerCase().contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == "All" ||
          document.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }
}