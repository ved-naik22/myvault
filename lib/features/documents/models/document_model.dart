import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 1)
class DocumentModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  String filePath;

  @HiveField(3)
  DateTime dateAdded;

  @HiveField(4)
  String notes;

  DocumentModel({
    required this.title,
    required this.category,
    required this.filePath,
    required this.dateAdded,
    required this.notes,
  });
}