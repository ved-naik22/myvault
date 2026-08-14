import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String boxName = 'settingsBox';

  static const String themeModeKey = 'themeMode';
  static const String notificationsKey = 'notifications';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }

    return Hive.openBox<dynamic>(boxName);
  }

  Future<String> getThemeMode() async {
    final box = await _openBox();

    return box.get(
      themeModeKey,
      defaultValue: 'system',
    ) as String;
  }

  Future<void> saveThemeMode(String mode) async {
    final box = await _openBox();

    await box.put(themeModeKey, mode);
  }

  Future<bool> getNotifications() async {
    final box = await _openBox();

    return box.get(
      notificationsKey,
      defaultValue: true,
    ) as bool;
  }

  Future<void> saveNotifications(bool enabled) async {
    final box = await _openBox();

    await box.put(notificationsKey, enabled);
  }

  Future<void> resetSettings() async {
    final box = await _openBox();

    await box.put(themeModeKey, 'system');
    await box.put(notificationsKey, true);
  }
}