import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  Future<void> loadProfile() async {
    _profile = await _service.getProfile();
    notifyListeners();
  }

  Future<void> saveProfile(ProfileModel profile) async {
    await _service.saveProfile(profile);
    _profile = profile;
    notifyListeners();
  }
}