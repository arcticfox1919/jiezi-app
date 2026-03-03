import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/setup_form_data.dart';
import '../providers/setup_providers.dart';

/// First-run setup wizard page.
///
/// This page is only reachable when [SetupStatus.setupRequired] is `true`.
/// On successful submission the router guard automatically redirects to
/// the login page.
class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _formKey = GlobalKey<FormState>();

  // Site settings controllers.
  final _siteNameCtrl = TextEditingController();
  final _siteDescriptionCtrl = TextEditingController();

  // Admin account controllers.
  final _usernameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  // Optional settings.
  final _maxUploadCtrl = TextEditingController(text: '100');
  bool _registrationEnabled = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _siteNameCtrl.dispose();
    _siteDescriptionCtrl.dispose();
    _usernameCtrl.dispose();
    _displayNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _maxUploadCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = SetupFormData(
      siteName: _siteNameCtrl.text.trim(),
      siteDescription: _siteDescriptionCtrl.text.trim().isEmpty
          ? null
          : _siteDescriptionCtrl.text.trim(),
      adminUsername: _usernameCtrl.text.trim(),
      adminDisplayName: _displayNameCtrl.text.trim().isEmpty
          ? null
          : _displayNameCtrl.text.trim(),
      adminEmail: _emailCtrl.text.trim(),
      adminPassword: _passwordCtrl.text,
      registrationEnabled: _registrationEnabled,
      maxUploadSizeMb: int.tryParse(_maxUploadCtrl.text),
    );

    await ref.read(setupProvider.notifier).complete(data);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setupProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show a snack-bar only after a successful submission (previous was
    // AsyncLoading, now AsyncData).  The router guard then redirects.
    ref.listen(setupProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Setup complete! Redirecting…')),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: colorScheme.error,
            content: Text(next.error.toString()),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ────────────────────────────────────────────────
                _Header(textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 32),

                // ── Form card ─────────────────────────────────────────────
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // — Site settings —
                          _SectionTitle(
                            title: 'Site Settings',
                            icon: Icons.language_outlined,
                            colorScheme: colorScheme,
                          ),
                          const SizedBox(height: 16),
                          _RequiredField(
                            controller: _siteNameCtrl,
                            label: 'Site Name',
                            hint: 'e.g. Jiezi Cloud',
                            icon: Icons.business_outlined,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _siteDescriptionCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Site Description',
                              hintText: 'Optional tagline',
                              prefixIcon: Icon(Icons.description_outlined),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 28),

                          // — Admin account —
                          _SectionTitle(
                            title: 'Super-Admin Account',
                            icon: Icons.shield_outlined,
                            colorScheme: colorScheme,
                          ),
                          const SizedBox(height: 16),
                          _RequiredField(
                            controller: _usernameCtrl,
                            label: 'Username',
                            hint: 'admin',
                            icon: Icons.person_outlined,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Username is required';
                              }
                              final re = RegExp(r'^[a-zA-Z0-9_\-]{3,50}$');
                              if (!re.hasMatch(v)) {
                                return '3–50 chars: letters, numbers, _ or -';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _displayNameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Display Name',
                              hintText: 'System Administrator',
                              prefixIcon: Icon(Icons.badge_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _RequiredField(
                            controller: _emailCtrl,
                            label: 'Email',
                            hint: 'admin@example.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password *',
                              hintText: 'Minimum 8 characters',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordCtrl,
                            obscureText: _obscureConfirm,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password *',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v != _passwordCtrl.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          // — Advanced options —
                          _SectionTitle(
                            title: 'Advanced Options',
                            icon: Icons.tune_outlined,
                            colorScheme: colorScheme,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _maxUploadCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Max Upload Size (MB)',
                              hintText: '100',
                              prefixIcon: Icon(Icons.upload_file_outlined),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            value: _registrationEnabled,
                            onChanged: (v) =>
                                setState(() => _registrationEnabled = v),
                            title: const Text('Public Registration'),
                            subtitle: const Text(
                              'Allow visitors to create their own accounts',
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 32),

                          // — Submit button —
                          FilledButton(
                            onPressed: state.isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Complete Setup',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'This page is only accessible once. After setup, '
                  'it will no longer be available.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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

// ────────────────────────────────────────────────────────────────────────────
// Private helper widgets
// ────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.textTheme, required this.colorScheme});

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.cloud_outlined,
            size: 36,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Jiezi Cloud Setup',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Configure your server before you start',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.colorScheme,
  });

  final String title;
  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }
}

class _RequiredField extends StatelessWidget {
  const _RequiredField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null,
    );
  }
}
