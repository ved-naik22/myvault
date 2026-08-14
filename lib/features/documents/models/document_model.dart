import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 1)
class DocumentModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  String notes;

  @HiveField(3)
  String filePath;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isFavorite;

  @HiveField(6)
  bool isPinned;

  DocumentModel({
    required this.title,
    required this.category,
    required this.notes,
    required this.filePath,
    required this.createdAt,
    this.isFavorite = false,
    this.isPinned = false,
  });
}