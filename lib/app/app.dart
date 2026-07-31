import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/profile/providers/profile_provider.dart';
import 'theme/app_theme.dart';

class MyVaultApp extends StatelessWidget {
  const MyVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadProfile(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyVault',
        theme: AppTheme.lightTheme,
        home: const DashboardPage(),
      ),
    );
  }
}