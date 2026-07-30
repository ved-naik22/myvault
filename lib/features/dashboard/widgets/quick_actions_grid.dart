import 'package:flutter/material.dart';

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
      children: const [
        ActionTile(
          icon: Icons.person,
          title: 'Profile',
        ),
        ActionTile(
          icon: Icons.folder,
          title: 'Documents',
        ),
        ActionTile(
          icon: Icons.lock,
          title: 'Passwords',
        ),
        ActionTile(
          icon: Icons.settings,
          title: 'Settings',
        ),
      ],
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
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