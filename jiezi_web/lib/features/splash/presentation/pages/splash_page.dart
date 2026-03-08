import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

import '../../../setup/presentation/providers/setup_providers.dart';

/// Splash / loading screen shown while the router resolves the initial destination.
///
/// Displayed only for a brief moment while [setupStatusProvider] and
/// [authStateProvider] load.  The [RouterNotifier] redirect guard forwards to
/// the correct destination as soon as both providers are ready.
///
/// If [setupStatusProvider] errors (e.g. API server unreachable) this page
/// surfaces a message and a retry button instead of spinning forever.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupAsync = ref.watch(setupStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: setupAsync.hasError
            ? _ErrorView(
                error: setupAsync.error,
                colorScheme: colorScheme,
                textTheme: textTheme,
                onRetry: () => ref.invalidate(setupStatusProvider),
              )
            : _LoadingView(colorScheme: colorScheme),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 24),
        CircularProgressIndicator(color: colorScheme.primary, strokeWidth: 2.5),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.error,
    required this.colorScheme,
    required this.textTheme,
    required this.onRetry,
  });

  final Object? error;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.errorContainer,
            child: Icon(
              Icons.cloud_off_outlined,
              size: 36,
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.cannotReachServer,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retryButton),
          ),
        ],
      ),
    );
  }
}
