import 'dart:io';

import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileInfoCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        profile.profileImage.isNotEmpty &&
        File(profile.profileImage).existsSync();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              backgroundImage:
                  hasImage ? FileImage(File(profile.profileImage)) : null,
              child: hasImage
                  ? null
                  : Icon(
                      Icons.person,
                      size: 42,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName.isEmpty
                        ? 'No Name'
                        : profile.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    profile.email.isEmpty
                        ? 'No email added'
                        : profile.email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  if (profile.phone.isNotEmpty)
                    Text(
                      profile.phone,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}