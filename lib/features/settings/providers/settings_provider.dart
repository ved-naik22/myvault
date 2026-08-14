import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();

  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _isLoading = true;

  ThemeMode get themeMode => _themeMode;

  bool get notificationsEnabled => _notificationsEnabled;

  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final savedTheme = await _service.getThemeMode();
    final savedNotifications =
        await _service.getNotifications();

    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;

      case 'dark':
        _themeMode = ThemeMode.dark;
        break;

      default:
        _themeMode = ThemeMode.system;
    }

    _notificationsEnabled = savedNotifications;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

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
    }

    await _service.saveThemeMode(value);

    notifyListeners();
  }

  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;

    await _service.saveNotifications(enabled);

    notifyListeners();
  }

  Future<void> resetSettings() async {
    await _service.resetSettings();

    _themeMode = ThemeMode.system;
    _notificationsEnabled = true;

    notifyListeners();
  }
}