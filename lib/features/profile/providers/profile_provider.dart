import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  ProfileModel? _profile;
  bool _isLoading = false;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get hasProfile => _profile != null;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _service.getProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.saveProfile(profile);
      _profile = profile;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.deleteProfile();
      _profile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}