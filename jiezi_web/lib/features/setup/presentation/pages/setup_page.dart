import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jiezi_web/l10n/app_localizations.dart';

import '../providers/setup_providers.dart';
import '../widgets/setup_widgets.dart';
import 'setup_wizard.dart';

/// First-run setup wizard page.
///
/// This page is only reachable when [SetupStatus.setupRequired] is `true`.
/// On successful submission the router guard automatically redirects to
/// the login page.
///
/// Responsibilities:
/// - Wraps the form in a [Scaffold] and centres it on the page.
/// - Listens to [setupProvider] and surfaces success/error [SnackBar]s.
/// - Delegates form state and validation to [SetupForm].
class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(setupProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.setupCompleteMessage)));
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
                const SetupHeader(),
                const SizedBox(height: 32),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(32),
                    child: SetupWizard(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.setupOnceNote,
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
