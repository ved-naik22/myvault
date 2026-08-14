import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/security_provider.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  Future<String?> _showPinDialog(
    BuildContext context, {
    required String title,
    required String buttonText,
  }) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: '4-digit PIN',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.length != 4) {
                  return 'Enter exactly 4 digits';
                }

                if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                  return 'PIN must contain numbers only';
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(
                    controller.text,
                  );
                }
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  Future<String?> _showConfirmPinDialog(
    BuildContext context,
    String firstPin,
  ) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm PIN'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: 'Confirm PIN',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != firstPin) {
                  return 'PINs do not match';
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(
                    controller.text,
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  Future<void> _enableLock(BuildContext context) async {
    final pin = await _showPinDialog(
      context,
      title: 'Create App PIN',
      buttonText: 'Next',
    );

    if (pin == null || !context.mounted) {
      return;
    }

    final confirmedPin = await _showConfirmPinDialog(
      context,
      pin,
    );

    if (confirmedPin == null || !context.mounted) {
      return;
    }

    await context.read<SecurityProvider>().enableLock(
          confirmedPin,
        );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App Lock enabled successfully.'),
      ),
    );
  }

  Future<void> _changePin(BuildContext context) async {
    final pin = await _showPinDialog(
      context,
      title: 'Create New PIN',
      buttonText: 'Next',
    );

    if (pin == null || !context.mounted) {
      return;
    }

    final confirmedPin = await _showConfirmPinDialog(
      context,
      pin,
    );

    if (confirmedPin == null || !context.mounted) {
      return;
    }

    await context.read<SecurityProvider>().changePin(
          confirmedPin,
        );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIN changed successfully.'),
      ),
    );
  }

  Future<void> _disableLock(BuildContext context) async {
    final provider = context.read<SecurityProvider>();

    final pin = await _showPinDialog(
      context,
      title: 'Enter Current PIN',
      buttonText: 'Disable',
    );

    if (pin == null || !context.mounted) {
      return;
    }

    final valid = await provider.verifyPin(pin);

    if (!context.mounted) {
      return;
    }

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect PIN.'),
        ),
      );
      return;
    }

    await provider.disableLock();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App Lock disabled.'),
      ),
    );
  }

  void _lockNow(BuildContext context) {
    final provider = context.read<SecurityProvider>();

    provider.lockApp();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final security = context.watch<SecurityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MyVault Security',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Protect your private information with an app PIN.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.lock),
              title: const Text(
                'App Lock',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                security.isLockEnabled
                    ? 'Your vault is protected by a PIN.'
                    : 'Require a PIN when opening MyVault.',
              ),
              value: security.isLockEnabled,
              onChanged: (value) {
                if (value) {
                  _enableLock(context);
                } else {
                  _disableLock(context);
                }
              },
            ),
          ),

          if (security.isLockEnabled) ...[
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.password),
                title: const Text('Change PIN'),
                subtitle: const Text(
                  'Change your 4-digit PIN.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _changePin(context),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Lock Now'),
                subtitle: const Text(
                  'Lock MyVault immediately.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _lockNow(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}