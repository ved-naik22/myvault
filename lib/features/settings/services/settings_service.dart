import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class SettingsService {
  static const String _boxName = 'settings';
  static const String _themeModeKey = 'themeMode';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }

    return Hive.openBox<dynamic>(_boxName);
  }

  Future<ThemeMode> getThemeMode() async {
    final box = await _openBox();

    final value = box.get(
      _themeModeKey,
      defaultValue: 'system',
    );

    switch (value) {
      case 'light':
        return ThemeMode.light;

      case 'dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(
    ThemeMode mode,
  ) async {
    final box = await _openBox();

    String value;

    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;

      case ThemeMode.dark:
        value = 'dark';
        break;

      case ThemeMode.system:
        value = 'system';
        break;
    }

    await box.put(
      _themeModeKey,
      value,
    );
  }
}