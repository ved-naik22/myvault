import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/security_provider.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final security = context.watch<SecurityProvider>();

    if (security.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Security'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SecurityStatusCard(
            security: security,
          ),

          const SizedBox(height: 16),

          Card(
            child: SwitchListTile(
              secondary: Icon(
                security.lockEnabled
                    ? Icons.lock
                    : Icons.lock_open,
              ),
              title: const Text('App Lock'),
              subtitle: Text(
                security.lockEnabled
                    ? 'PIN protection is enabled.'
                    : 'PIN protection is disabled.',
              ),
              value: security.lockEnabled,
              onChanged: security.hasPin
                  ? (value) async {
                      if (value) {
                        await security.enableLock();
                      } else {
                        await security.disableLock();
                      }
                    }
                  : null,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.pin),
              title: Text(
                security.hasPin ? 'Change PIN' : 'Create PIN',
              ),
              subtitle: Text(
                security.hasPin
                    ? 'Change your existing 4-digit PIN.'
                    : 'Create a 4-digit PIN for MyVault.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (security.hasPin) {
                  _changePin(
                    context,
                    security,
                  );
                } else {
                  _createPin(
                    context,
                    security,
                  );
                }
              },
            ),
          ),

          if (security.hasPin) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                ),
                title: const Text('Remove PIN'),
                subtitle: const Text(
                  'Disable PIN protection.',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _removePin(
                    context,
                    security,
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your PIN is stored using secure device storage. '
                      'Never share your PIN with anyone.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createPin(
    BuildContext context,
    SecurityProvider security,
  ) async {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: '4-digit PIN',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                ),
              ),
              TextField(
                controller: confirmController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final pin = pinController.text.trim();
                final confirm =
                    confirmController.text.trim();

                if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
                  if (!dialogContext.mounted) {
                    return;
                  }

                  _error(
                    dialogContext,
                    'PIN must contain exactly 4 digits.',
                  );
                  return;
                }

                if (pin != confirm) {
                  if (!dialogContext.mounted) {
                    return;
                  }

                  _error(
                    dialogContext,
                    'PINs do not match.',
                  );
                  return;
                }

                final success =
                    await security.setPin(pin);

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  success,
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    pinController.dispose();
    confirmController.dispose();

    if (!context.mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'PIN created successfully.',
          ),
        ),
      );
    }
  }

  Future<void> _changePin(
    BuildContext context,
    SecurityProvider security,
  ) async {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                ),
              ),
              TextField(
                controller: newController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'New PIN',
                ),
              ),
              TextField(
                controller: confirmController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Confirm new PIN',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final newPin =
                    newController.text.trim();
                final confirm =
                    confirmController.text.trim();

                if (!RegExp(r'^\d{4}$').hasMatch(newPin)) {
                  if (!dialogContext.mounted) {
                    return;
                  }

                  _error(
                    dialogContext,
                    'New PIN must contain exactly 4 digits.',
                  );
                  return;
                }

                if (newPin != confirm) {
                  if (!dialogContext.mounted) {
                    return;
                  }

                  _error(
                    dialogContext,
                    'New PINs do not match.',
                  );
                  return;
                }

                final success =
                    await security.changePin(
                  oldController.text.trim(),
                  newPin,
                );

                if (!dialogContext.mounted) {
                  return;
                }

                if (!success) {
                  _error(
                    dialogContext,
                    'Current PIN is incorrect or new PIN is invalid.',
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );

    oldController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (!context.mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'PIN changed successfully.',
          ),
        ),
      );
    }
  }

  Future<void> _removePin(
    BuildContext context,
    SecurityProvider security,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove PIN?'),
          content: const Text(
            'This will disable MyVault app lock.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await security.removePin();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIN removed.'),
      ),
    );
  }

  void _error(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class _SecurityStatusCard extends StatelessWidget {
  final SecurityProvider security;

  const _SecurityStatusCard({
    required this.security,
  });

  @override
  Widget build(BuildContext context) {
    final protected =
        security.lockEnabled && security.hasPin;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(
                protected
                    ? Icons.verified_user
                    : Icons.security,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    protected
                        ? 'Vault Protected'
                        : 'Vault Not Protected',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    protected
                        ? 'Your MyVault is protected by a PIN.'
                        : 'Create a PIN to protect your vault.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}