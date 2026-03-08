import 'package:flutter/material.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';
import 'package:jiezi_web/shared/widgets/tooltip_icon.dart';

import '../widgets/setup_widgets.dart';
import 'setup_step.dart';

// Static patterns — compiled once, reused across all validator calls.
final _usernameRegExp = RegExp(r'^[a-zA-Z0-9_\-]{3,50}$');
final _emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

/// Setup wizard — step 2: super-admin account credentials and nickname.
class AccountStep extends StatefulWidget {
  const AccountStep({super.key});

  @override
  State<AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends SetupStepState<AccountStep> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _displayNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  bool validate() => _formKey.currentState?.validate() ?? false;

  @override
  void contributeData(SetupFormDataBuilder builder) {
    builder.adminUsername = _usernameCtrl.text.trim();
    builder.adminDisplayName = _displayNameCtrl.text.trim().isEmpty
        ? null
        : _displayNameCtrl.text.trim();
    builder.adminEmail = _emailCtrl.text.trim();
    builder.adminPassword = _passwordCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Super-admin notice ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade600),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Colors.amber.shade800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.adminAccountNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Username ──────────────────────────────────────────────────────
          SetupRequiredField(
            controller: _usernameCtrl,
            label: l10n.usernameLabel,
            hint: l10n.usernameHint,
            icon: Icons.person_outlined,
            suffixIcon: TooltipIcon(message: l10n.usernameTooltip),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.usernameRequired;
              if (!_usernameRegExp.hasMatch(v)) return l10n.usernameFormat;
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ── Nickname (optional) ───────────────────────────────────────────
          TextFormField(
            controller: _displayNameCtrl,
            decoration: InputDecoration(
              labelText: l10n.displayNameLabel,
              hintText: l10n.displayNameHint,
              helperText: l10n.displayNameHelper,
              prefixIcon: const Icon(Icons.badge_outlined),
              suffixIcon: TooltipIcon(message: l10n.displayNameTooltip),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Email ─────────────────────────────────────────────────────────
          SetupRequiredField(
            controller: _emailCtrl,
            label: l10n.emailLabel,
            hint: l10n.emailHint,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.emailRequired;
              if (!_emailRegExp.hasMatch(v)) return l10n.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ── Password ──────────────────────────────────────────────────────
          SetupRequiredField(
            controller: _passwordCtrl,
            label: l10n.passwordLabel,
            hint: l10n.passwordHint,
            icon: Icons.lock_outlined,
            obscureText: _obscurePassword,
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
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ],
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.passwordRequired;
              if (v.length < 8) return l10n.passwordTooShort;
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ── Confirm password ──────────────────────────────────────────────
          SetupRequiredField(
            controller: _confirmCtrl,
            label: l10n.confirmPasswordLabel,
            hint: '',
            icon: Icons.lock_outlined,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            validator: (v) =>
                v != _passwordCtrl.text ? l10n.passwordMismatch : null,
          ),
        ],
      ),
    );
  }
}
