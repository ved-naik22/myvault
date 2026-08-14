import 'package:flutter/material.dart';

import 'models/profile_model.dart';
import 'widgets/profile_form.dart';

class EditProfilePage extends StatelessWidget {
  final ProfileModel? profile;

  const EditProfilePage({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile == null ? 'Create Profile' : 'Edit Profile',
        ),
      ),
      body: SafeArea(
        child: ProfileForm(
          profile: profile,
        ),
      ),
    );
  }
}