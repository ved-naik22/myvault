import 'package:flutter/material.dart';

import '../services/security_service.dart';

class SecurityProvider extends ChangeNotifier {
  final SecurityService _service = SecurityService();

  bool _isLoading = true;
  bool _isLockEnabled = false;
  bool _isLocked = false;

  bool get isLoading => _isLoading;
  bool get isLockEnabled => _isLockEnabled;
  bool get isLocked => _isLocked;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _isLockEnabled = await _service.isLockEnabled();

    _isLocked = _isLockEnabled;

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> enableLock(String pin) async {
    if (!_validPin(pin)) {
      return false;
    }

    await _service.enableLock(pin);

    _isLockEnabled = true;

    // Do not immediately lock the application here.
    // The user remains on the Security page after enabling it.
    _isLocked = false;

    notifyListeners();

    return true;
  }

  Future<void> disableLock() async {
    await _service.disableLock();

    _isLockEnabled = false;
    _isLocked = false;

    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    if (!_validPin(pin)) {
      return false;
    }

    final valid = await _service.verifyPin(pin);

    if (valid) {
      _isLocked = false;
      notifyListeners();
    }

    return valid;
  }

  Future<bool> changePin(String newPin) async {
    if (!_validPin(newPin)) {
      return false;
    }

    await _service.changePin(newPin);

    notifyListeners();

    return true;
  }

  void lockApp() {
    if (!_isLockEnabled) {
      return;
    }

    _isLocked = true;
    notifyListeners();
  }

  bool _validPin(String pin) {
    return RegExp(r'^\d{4}$').hasMatch(pin);
  }
}