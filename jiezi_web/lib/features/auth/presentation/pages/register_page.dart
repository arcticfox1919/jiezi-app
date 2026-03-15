import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/error/app_error.dart';
import '../../../../shared/widgets/tooltip_icon.dart';
import '../providers/auth_providers.dart';

/// Registration page — creates a new user account.
///
/// Handles the optional email OTP flow: when the server returns HTTP 422 the
/// OTP field is revealed progressively and the user can request a code via
/// the "Send Code" button before resubmitting.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _displayNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    await ref
        .read(registerProvider.notifier)
        .sendOtp(email: _emailCtrl.text.trim());
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final displayName = _displayNameCtrl.text.trim();
    await ref
        .read(registerProvider.notifier)
        .register(
          username: _usernameCtrl.text.trim(),
          displayName: displayName.isEmpty ? null : displayName,
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          otp: _otpCtrl.text.trim().isEmpty ? null : _otpCtrl.text.trim(),
        );
  }

  /// Maps a domain [AppError] to a brief localised message.
  ///
  /// Returns `null` when the error should not be shown as a banner (e.g. 422
  /// is handled by revealing the OTP field instead).
  String? _errorBannerText(AppLocalizations l10n, AppError? error) {
    if (error == null) return null;
    return switch (error) {
      ServerError(statusCode: 403) => l10n.registrationDisabledError,
      ServerError(statusCode: 409) => l10n.accountExistsError,
      ServerError(statusCode: 422) => null, // OTP field handles this
      ServerError(:final message) => message,
      _ => error.message,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(registerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final errorBanner = _errorBannerText(l10n, state.error);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.cloud_outlined,
                    size: 32,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appName,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.registerTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Error banner
                          if (errorBanner != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: colorScheme.onErrorContainer,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      errorBanner,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onErrorContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Username
                          TextFormField(
                            controller: _usernameCtrl,
                            autofillHints: const [AutofillHints.username],
                            decoration: InputDecoration(
                              labelText: l10n.usernameLabel,
                              prefixIcon: const Icon(Icons.person_outlined),
                              suffixIcon: TooltipIcon(
                                message: l10n.usernameTooltip,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? l10n.fieldRequired
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Display name (optional)
                          TextFormField(
                            controller: _displayNameCtrl,
                            decoration: InputDecoration(
                              labelText: l10n.displayNameLabel,
                              prefixIcon: const Icon(Icons.badge_outlined),
                              suffixIcon: TooltipIcon(
                                message: l10n.displayNameTooltip,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: InputDecoration(
                              labelText: l10n.emailLabel,
                              prefixIcon: const Icon(Icons.email_outlined),
                              suffixIcon: TooltipIcon(
                                message: l10n.emailTooltip,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? l10n.fieldRequired
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            autofillHints: const [AutofillHints.newPassword],
                            decoration: InputDecoration(
                              labelText: l10n.passwordLabel,
                              prefixIcon: const Icon(Icons.lock_outlined),
                              border: const OutlineInputBorder(),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TooltipIcon(message: l10n.passwordTooltip),
                                  IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? l10n.fieldRequired
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Confirm password
                          TextFormField(
                            controller: _confirmPasswordCtrl,
                            obscureText: _obscureConfirmPassword,
                            autofillHints: const [AutofillHints.newPassword],
                            decoration: InputDecoration(
                              labelText: l10n.confirmPasswordLabel,
                              prefixIcon: const Icon(Icons.lock_outlined),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              if (v != _passwordCtrl.text) {
                                return l10n.passwordMismatch;
                              }
                              return null;
                            },
                          ),

                          // OTP section — revealed after HTTP 422
                          if (state.otpRequired) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                state.otpSent
                                    ? l10n.codeSentMessage
                                    : l10n.otpRequiredMessage,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _otpCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: l10n.otpLabel,
                                      hintText: l10n.otpHint,
                                      prefixIcon: const Icon(
                                        Icons.pin_outlined,
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? l10n.fieldRequired
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: FilledButton.tonal(
                                    onPressed: state.isLoading
                                        ? null
                                        : _sendOtp,
                                    child: Text(l10n.sendCodeButton),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: state.isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(l10n.registerButton),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount),
                    TextButton(
                      onPressed: () => context.go(Routes.login),
                      child: Text(l10n.signInLink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
