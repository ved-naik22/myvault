import 'package:hive_flutter/hive_flutter.dart';

class SecurityService {
  static const String boxName = 'securityBox';

  static const String _enabledKey = 'enabled';
  static const String _pinKey = 'pin';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }

    return Hive.openBox<dynamic>(boxName);
  }

  Future<bool> isLockEnabled() async {
    final box = await _openBox();

    return box.get(
      _enabledKey,
      defaultValue: false,
    ) as bool;
  }

  Future<bool> hasPin() async {
    final box = await _openBox();

    return box.get(_pinKey) != null;
  }

  Future<void> enableLock(String pin) async {
    final box = await _openBox();

    await box.put(_pinKey, pin);
    await box.put(_enabledKey, true);
  }

  Future<void> disableLock() async {
    final box = await _openBox();

    await box.put(_enabledKey, false);
  }

  Future<void> changePin(String newPin) async {
    final box = await _openBox();

    await box.put(_pinKey, newPin);
  }

  Future<bool> verifyPin(String pin) async {
    final box = await _openBox();

    final savedPin = box.get(_pinKey) as String?;

    if (savedPin == null) {
      return false;
    }

    return savedPin == pin;
  }
}