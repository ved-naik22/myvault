import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/profile/providers/profile_provider.dart';
import '../features/documents/providers/document_provider.dart';
import '../features/security/providers/security_provider.dart';
import '../features/security/security_lock_page.dart';
import '../features/settings/providers/settings_provider.dart';
import 'theme/app_theme.dart';

class MyVaultApp extends StatelessWidget {
  const MyVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ProfileProvider()..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              DocumentProvider()..loadDocuments(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SecurityProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SettingsProvider()..initialize(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (
          context,
          settings,
          child,
        ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyVault',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,

            home: const _VaultGate(),
          );
        },
      ),
    );
  }
}

class _VaultGate extends StatelessWidget {
  const _VaultGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityProvider>(
      builder: (
        context,
        security,
        child,
      ) {
        if (security.isLoading) {
          return const _SecurityLoadingPage();
        }

        if (security.lockEnabled &&
            security.hasPin &&
            !security.isUnlocked) {
          return const SecurityLockPage();
        }

        return const DashboardPage();
      },
    );
  }
}

class _SecurityLoadingPage
    extends StatelessWidget {
  const _SecurityLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 52,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Checking security...',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}