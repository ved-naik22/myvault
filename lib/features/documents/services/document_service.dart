import 'package:hive_flutter/hive_flutter.dart';

import '../models/document_model.dart';

class DocumentService {
  static const String boxName = 'documents';

  Future<Box<DocumentModel>> openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<DocumentModel>(boxName);
    }

    return await Hive.openBox<DocumentModel>(boxName);
  }

  Future<void> addDocument(DocumentModel document) async {
    final box = await openBox();
    await box.add(document);
  }

  Future<List<DocumentModel>> getDocuments() async {
    final box = await openBox();
    return box.values.toList();
  }

  Future<void> updateDocument(
    int index,
    DocumentModel document,
  ) async {
    final box = await openBox();
    await box.putAt(index, document);
  }

  Future<void> deleteDocument(int index) async {
    final box = await openBox();
    await box.deleteAt(index);
  }
}