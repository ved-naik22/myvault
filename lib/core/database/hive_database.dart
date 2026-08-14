import 'package:hive_flutter/hive_flutter.dart';

import '../../features/documents/models/document_model.dart';
import '../../features/profile/models/profile_model.dart';

class HiveDatabase {
  static const String profileBoxName = 'profile';
  static const String documentsBoxName = 'documents';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProfileModelAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DocumentModelAdapter());
    }

    if (!Hive.isBoxOpen(profileBoxName)) {
      await Hive.openBox<ProfileModel>(profileBoxName);
    }

    if (!Hive.isBoxOpen(documentsBoxName)) {
      await Hive.openBox<DocumentModel>(documentsBoxName);
    }
  }
}