import 'package:flutter/material.dart';

import '../features/navigation/navigation_page.dart';
import 'theme/app_theme.dart';

class MyVaultApp extends StatelessWidget {
  const MyVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyVault',
      theme: AppTheme.lightTheme,
      home: const NavigationPage(),
    );
  }
}