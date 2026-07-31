import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/database/hive_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveDatabase.initialize();

  runApp(const MyVaultApp());
}