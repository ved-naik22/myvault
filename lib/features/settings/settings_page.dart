import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

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
                const Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.palette_outlined,
                    ),
                    title: const Text('Theme'),
                    subtitle: Text(
                      _themeName(settings.themeMode),
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

                const SizedBox(height: 24),

                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Card(
                  child: SwitchListTile(
                    secondary: const Icon(
                      Icons.notifications_outlined,
                    ),
                    title: const Text(
                      'Notifications',
                    ),
                    subtitle: Text(
                      settings.notificationsEnabled
                          ? 'Notifications are enabled.'
                          : 'Notifications are disabled.',
                    ),
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      settings.setNotifications(value);
                    },
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Application',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.info_outline,
                        ),
                        title: const Text(
                          'About MyVault',
                        ),
                        subtitle: const Text(
                          'Information about this application.',
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          _showAboutDialog(context);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.restore,
                        ),
                        title: const Text(
                          'Reset Settings',
                        ),
                        subtitle: const Text(
                          'Restore default settings.',
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          _confirmReset(
                            context,
                            settings,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Center(
                  child: Text(
                    'MyVault',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Center(
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';

      case ThemeMode.dark:
        return 'Dark';

      case ThemeMode.system:
        return 'System default';
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;

      case ThemeMode.dark:
        return Icons.dark_mode;

      case ThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    SettingsProvider settings,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }

              settings.setThemeMode(value);
              Navigator.of(dialogContext).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  secondary: Icon(
                    _themeIcon(ThemeMode.system),
                  ),
                  title: const Text(
                    'System default',
                  ),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  secondary: Icon(
                    _themeIcon(ThemeMode.light),
                  ),
                  title: const Text('Light'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  secondary: Icon(
                    _themeIcon(ThemeMode.dark),
                  ),
                  title: const Text('Dark'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MyVault',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.lock,
        size: 40,
      ),
      applicationLegalese:
          'Personal information and document management application.',
      children: const [
        SizedBox(height: 20),
        Text(
          'MyVault helps you keep your personal information and important documents organized in one place.',
        ),
      ],
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    SettingsProvider settings,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Settings?'),
          content: const Text(
            'This will restore the default theme and enable notifications.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (result != true || !context.mounted) {
      return;
    }

    await settings.resetSettings();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Settings restored to default.',
        ),
      ),
    );
  }
}