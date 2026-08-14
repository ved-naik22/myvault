import 'dart:io';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    this.radius = 60,
    this.onTap,
    this.showEditIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync();

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundImage: hasImage ? FileImage(File(imagePath!)) : null,
      child: hasImage
          ? null
          : Icon(
              Icons.person,
              size: radius,
              color: Theme.of(context).colorScheme.primary,
            ),
    );

    if (showEditIcon) {
      avatar = Stack(
        alignment: Alignment.bottomRight,
        children: [
          avatar,
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 3,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}