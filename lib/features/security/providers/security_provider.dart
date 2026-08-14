import 'package:flutter/material.dart';

import '../services/security_service.dart';

class SecurityProvider extends ChangeNotifier {
  final SecurityService _service = SecurityService();

  bool _isLoading = true;
  bool _lockEnabled = false;
  bool _hasPin = false;
  bool _isUnlocked = false;

  bool get isLoading => _isLoading;
  bool get lockEnabled => _lockEnabled;
  bool get hasPin => _hasPin;
  bool get isUnlocked => _isUnlocked;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _lockEnabled = await _service.isLockEnabled();
      _hasPin = await _service.hasPin();

      if (_lockEnabled && _hasPin) {
        _isUnlocked = false;
      } else {
        _isUnlocked = true;
      }
    } catch (e) {
      debugPrint('Security initialization failed: $e');

      _lockEnabled = false;
      _hasPin = false;
      _isUnlocked = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> setPin(String pin) async {
    if (!_isValidPin(pin)) {
      return false;
    }

    await _service.setPin(pin);
    await _service.setLockEnabled(true);

    _hasPin = true;
    _lockEnabled = true;
    _isUnlocked = true;

    notifyListeners();

    return true;
  }

  Future<bool> changePin(
    String oldPin,
    String newPin,
  ) async {
    if (!_isValidPin(newPin)) {
      return false;
    }

    final oldPinCorrect = await _service.verifyPin(oldPin);

    if (!oldPinCorrect) {
      return false;
    }

    await _service.setPin(newPin);

    _hasPin = true;

    notifyListeners();

    return true;
  }

  Future<bool> verifyPin(String pin) async {
    if (!_isValidPin(pin)) {
      return false;
    }

    final valid = await _service.verifyPin(pin);

    if (valid) {
      _isUnlocked = true;
      notifyListeners();
    }

    return valid;
  }

  Future<void> enableLock() async {
    if (!_hasPin) {
      return;
    }

    await _service.setLockEnabled(true);

    _lockEnabled = true;
    _isUnlocked = false;

    notifyListeners();
  }

  Future<void> disableLock() async {
    await _service.setLockEnabled(false);

    _lockEnabled = false;
    _isUnlocked = true;

    notifyListeners();
  }

  Future<void> removePin() async {
    await _service.removePin();

    _hasPin = false;
    _lockEnabled = false;
    _isUnlocked = true;

    notifyListeners();
  }

  void lockVault() {
    if (_lockEnabled && _hasPin) {
      _isUnlocked = false;
      notifyListeners();
    }
  }

  void unlockVault() {
    if (_lockEnabled && _hasPin) {
      _isUnlocked = true;
      notifyListeners();
    }
  }

  bool _isValidPin(String pin) {
    return RegExp(r'^\d{4}$').hasMatch(pin);
  }
}