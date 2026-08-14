import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/security_provider.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();

  bool _isChecking = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final pin = _pinController.text.trim();

    if (pin.length != 4) {
      setState(() {
        _errorMessage = 'Enter your 4-digit PIN.';
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    final provider = context.read<SecurityProvider>();

    final valid = await provider.verifyPin(pin);

    if (!mounted) return;

    setState(() {
      _isChecking = false;
    });

    if (!valid) {
      setState(() {
        _errorMessage = 'Incorrect PIN.';
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'MyVault Locked',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Enter your 4-digit PIN to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    letterSpacing: 12,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••',
                    border: const OutlineInputBorder(),
                    errorText: _errorMessage,
                  ),
                  onSubmitted: (_) => _unlock(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isChecking ? null : _unlock,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.lock_open),
                    label: Text(
                      _isChecking ? 'Checking...' : 'Unlock',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}