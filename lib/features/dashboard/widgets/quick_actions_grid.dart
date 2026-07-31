import 'package:flutter/material.dart';

import '../../documents/documents_page.dart';
import '../../profile/profile_page.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _ActionTile(
          icon: Icons.person,
          title: "Profile",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilePage(),
              ),
            );
          },
        ),
        _ActionTile(
          icon: Icons.folder,
          title: "Documents",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DocumentsPage(),
              ),
            );
          },
        ),
        _ActionTile(
          icon: Icons.lock,
          title: "Passwords",
          onTap: () {},
        ),
        _ActionTile(
          icon: Icons.settings,
          title: "Settings",
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}