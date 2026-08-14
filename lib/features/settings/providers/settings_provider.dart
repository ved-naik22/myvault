import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();

  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;

  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    if (!_isLoading) return;

    try {
      _themeMode = await _service.getThemeMode();
    } catch (e) {
      debugPrint('Settings initialization failed: $e');

      // Safe fallback
      _themeMode = ThemeMode.system;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    try {
      await _service.saveThemeMode(mode);
    } catch (e) {
      debugPrint('Failed to save theme: $e');
    }
  }
}