import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiezi_api/jiezi_api.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Personal profile page — shows user info and storage usage.
///
/// Reads the current [User] from [authStateProvider]; no additional API calls
/// are needed because [User.storageUsed] and [User.storageQuota] are already
/// included in the `/auth/me` response that bootstraps auth state.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (state) {
        final user = state.user;
        if (user == null) return const SizedBox.shrink();
        return _ProfileBody(user: user, l10n: l10n);
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.l10n});

  final User user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatarCard(context, theme),
              const SizedBox(height: 20),
              _buildStorageCard(context, theme),
              const SizedBox(height: 20),
              _buildAccountCard(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  // ── Avatar + name card ────────────────────────────────────────────────────

  Widget _buildAvatarCard(BuildContext context, ThemeData theme) {
    final initials = _initials(user.displayName ?? user.username);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: user.avatarUrl == null
                  ? Text(
                      initials,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            if (user.displayName != null) ...[
              Text(user.displayName!, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '@${user.username}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ] else
              Text(user.username, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }

  // ── Storage card ──────────────────────────────────────────────────────────

  Widget _buildStorageCard(BuildContext context, ThemeData theme) {
    final usedBytes = user.storageUsed;
    final quotaBytes = user.storageQuota;
    final fraction = quotaBytes != null && quotaBytes > 0
        ? (usedBytes / quotaBytes).clamp(0.0, 1.0)
        : null;
    final usedStr = _formatBytes(usedBytes);
    final subtitle = quotaBytes != null
        ? l10n.storageUsedOf(usedStr, _formatBytes(quotaBytes))
        : l10n.storageUsedNoQuota(usedStr);

    final barColor = fraction != null && fraction > 0.9
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storage_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(l10n.storageTitle, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            if (fraction != null) ...[
              LinearProgressIndicator(
                value: fraction,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: barColor,
                minHeight: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Account detail card ───────────────────────────────────────────────────

  Widget _buildAccountCard(BuildContext context, ThemeData theme) {
    final joined = DateFormat.yMMMd().format(user.createdAt.toLocal());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.manage_accounts_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(l10n.accountTitle, style: theme.textTheme.titleMedium),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(label: l10n.usernameLabel, value: user.username),
            _InfoRow(label: l10n.emailLabel, value: user.email),
            if (user.displayName != null)
              _InfoRow(label: l10n.displayNameLabel, value: user.displayName!),
            _InfoRow(label: l10n.roleLabel, value: _roleName(user.role)),
            _InfoRow(label: l10n.joinedLabel, value: joined),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return name.substring(0, name.length.clamp(1, 2)).toUpperCase();
  }

  String _roleName(Role role) => switch (role) {
    Role.owner => 'Owner',
    Role.admin => 'Admin',
    Role.member => 'Member',
    Role.guest => 'Guest',
    _ => role.name,
  };

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
