import 'package:flutter/material.dart';

import '../documents/documents_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/dashboard_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    DocumentsPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Documents',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyVault'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 25),

            DashboardCard(
              title: 'Documents',
              subtitle: 'Store Aadhaar, PAN, Passport',
              icon: Icons.folder_copy,
            ),

            SizedBox(height: 15),

            DashboardCard(
              title: 'Passwords',
              subtitle: 'Secure all your passwords',
              icon: Icons.lock,
            ),

            SizedBox(height: 15),

            DashboardCard(
              title: 'Profile',
              subtitle: 'Manage personal information',
              icon: Icons.person,
            ),
          ],
        ),
      ),
    );
  }
}