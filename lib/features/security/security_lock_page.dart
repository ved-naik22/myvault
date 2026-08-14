import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/security_provider.dart';

class SecurityLockPage extends StatefulWidget {
  const SecurityLockPage({
    super.key,
  });

  @override
  State<SecurityLockPage> createState() =>
      _SecurityLockPageState();
}

class _SecurityLockPageState
    extends State<SecurityLockPage> {
  final TextEditingController _pinController =
      TextEditingController();

  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final pin = _pinController.text.trim();

    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() {
        _errorMessage =
            'Enter your 4-digit PIN.';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final security =
        context.read<SecurityProvider>();

    final success =
        await security.verifyPin(pin);

    if (!mounted) {
      return;
    }

    if (success) {
      _pinController.clear();

      setState(() {
        _isVerifying = false;
        _errorMessage = null;
      });

      return;
    }

    setState(() {
      _isVerifying = false;
      _errorMessage = 'Incorrect PIN.';
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock,
                      size: 50,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'MyVault is Locked',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Enter your PIN to access your vault.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: _pinController,
                    keyboardType:
                        TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      letterSpacing: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: '4-digit PIN',
                      hintText: '••••',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                      counterText: '',
                    ),
                    onSubmitted: (_) {
                      if (!_isVerifying) {
                        _unlock();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed:
                          _isVerifying ? null : _unlock,
                      icon: _isVerifying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.lock_open,
                            ),
                      label: Text(
                        _isVerifying
                            ? 'Checking...'
                            : 'Unlock Vault',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Your vault is protected by your PIN.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
