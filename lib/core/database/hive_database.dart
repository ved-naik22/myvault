import 'package:hive_flutter/hive_flutter.dart';

import '../../features/profile/models/profile_model.dart';
import '../../features/documents/models/document_model.dart';

class HiveDatabase {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ProfileModelAdapter());
    Hive.registerAdapter(DocumentModelAdapter());

    // Open Hive Boxes
    await Hive.openBox<ProfileModel>('profile');
    await Hive.openBox<DocumentModel>('documents');
  }
}