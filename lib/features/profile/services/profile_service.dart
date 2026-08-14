import 'package:hive_flutter/hive_flutter.dart';

import '../models/profile_model.dart';

class ProfileService {
  static const String boxName = 'profile';
  static const String profileKey = 'user';

  Future<Box<ProfileModel>> openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<ProfileModel>(boxName);
    }

    return await Hive.openBox<ProfileModel>(boxName);
  }

  Future<void> saveProfile(ProfileModel profile) async {
    final box = await openBox();
    await box.put(profileKey, profile);
  }

  Future<ProfileModel?> getProfile() async {
    final box = await openBox();
    return box.get(profileKey);
  }

  Future<void> deleteProfile() async {
    final box = await openBox();
    await box.delete(profileKey);
  }
}