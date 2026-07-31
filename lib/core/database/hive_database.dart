import 'package:hive_flutter/hive_flutter.dart';

import '../../features/profile/models/profile_model.dart';
import '../../features/documents/models/document_model.dart';

class HiveDatabase {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProfileModelAdapter());
    Hive.registerAdapter(DocumentModelAdapter());
  }
}