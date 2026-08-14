import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings =
        context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settings.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.palette_outlined,
                    ),
                    title: const Text(
                      'Theme',
                    ),
                    subtitle: Text(
                      _themeName(
                        settings.themeMode,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      _showThemeDialog(
                        context,
                        settings,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                    ),
                    title: const Text(
                      'About MyVault',
                    ),
                    subtitle: const Text(
                      'Personal information vault',
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.verified_outlined,
                    ),
                    title: const Text(
                      'App Version',
                    ),
                    subtitle: const Text(
                      'MyVault 1.0.0',
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _themeName(
    ThemeMode mode,
  ) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';

      case ThemeMode.dark:
        return 'Dark';

      case ThemeMode.system:
        return 'System default';
    }
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    SettingsProvider settings,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Choose Theme',
          ),
          content: RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (value) async {
              if (value == null) {
                return;
              }

              await settings.setThemeMode(
                value,
              );

              if (dialogContext.mounted) {
                Navigator.pop(
                  dialogContext,
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text(
                    'System default',
                  ),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text(
                    'Light',
                  ),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text(
                    'Dark',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}