import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  static const String _pinHashKey =
      'myvault_pin_hash';

  static const String _lockEnabledKey =
      'myvault_lock_enabled';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  Future<bool> isLockEnabled() async {
    final value = await _storage.read(
      key: _lockEnabledKey,
    );

    return value == 'true';
  }

  Future<void> setLockEnabled(
    bool enabled,
  ) async {
    await _storage.write(
      key: _lockEnabledKey,
      value: enabled.toString(),
    );
  }

  Future<bool> hasPin() async {
    final hash = await _storage.read(
      key: _pinHashKey,
    );

    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(
    String pin,
  ) async {
    final hash = _hashPin(pin);

    await _storage.write(
      key: _pinHashKey,
      value: hash,
    );
  }

  Future<bool> verifyPin(
    String pin,
  ) async {
    final storedHash = await _storage.read(
      key: _pinHashKey,
    );

    if (storedHash == null ||
        storedHash.isEmpty) {
      return false;
    }

    return storedHash == _hashPin(pin);
  }

  Future<void> removePin() async {
    await _storage.delete(
      key: _pinHashKey,
    );

    await _storage.write(
      key: _lockEnabledKey,
      value: 'false',
    );
  }

  String _hashPin(
    String pin,
  ) {
    return sha256
        .convert(
          utf8.encode(pin),
        )
        .toString();
  }
}