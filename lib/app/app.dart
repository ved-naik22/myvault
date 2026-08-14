import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/documents/providers/document_provider.dart';
import '../features/profile/providers/profile_provider.dart';
import '../features/security/lock_screen.dart';
import '../features/security/providers/security_provider.dart';
import 'theme/app_theme.dart';

class MyVaultApp extends StatelessWidget {
  const MyVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider()..loadProfile(),
        ),
        ChangeNotifierProvider<DocumentProvider>(
          create: (_) => DocumentProvider()..loadDocuments(),
        ),
        ChangeNotifierProvider<SecurityProvider>(
          create: (_) => SecurityProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyVault',
        theme: AppTheme.lightTheme,
        home: const SecurityShell(),
      ),
    );
  }
}

class SecurityShell extends StatelessWidget {
  const SecurityShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SecurityShellContent();
  }
}

class _SecurityShellContent extends StatelessWidget {
  const _SecurityShellContent();

  @override
  Widget build(BuildContext context) {
    final security = context.watch<SecurityProvider>();

    if (security.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        const DashboardPage(),

        Positioned.fill(
          child: IgnorePointer(
            ignoring: !security.isLocked,
            child: AnimatedOpacity(
              opacity: security.isLocked ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: const LockScreen(),
            ),
          ),
        ),
      ],
    );
  }
}