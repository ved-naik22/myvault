import 'package:hive_flutter/hive_flutter.dart';

import '../models/profile_model.dart';

class ProfileService {
  static const String boxName = 'profileBox';

  Future<Box<ProfileModel>> openBox() async {
    return await Hive.openBox<ProfileModel>(boxName);
  }

  Future<void> saveProfile(ProfileModel profile) async {
    final box = await openBox();
    await box.put('user', profile);
  }

  Future<ProfileModel?> getProfile() async {
    final box = await openBox();
    return box.get('user');
  }
}