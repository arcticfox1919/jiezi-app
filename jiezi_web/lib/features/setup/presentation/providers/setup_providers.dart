import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/setup_repository_impl.dart';
import '../../domain/models/setup_form_data.dart';
import '../../domain/models/setup_status.dart';
import '../../domain/repositories/i_setup_repository.dart';

part 'setup_providers.g.dart';

// ────────────────────────────────────────────────────────────────────────────
// Repository provider
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
ISetupRepository setupRepository(Ref ref) {
  final client = ref.watch(jieziClientProvider).setup;
  return SetupRepositoryImpl(client);
}

// ────────────────────────────────────────────────────────────────────────────
// Setup status (auto-fetched on app start)
// ────────────────────────────────────────────────────────────────────────────

/// Resolves the server's current setup state.
///
/// Keep-alive because the router guard reads it on every navigation event.
@Riverpod(keepAlive: true)
Future<SetupStatus> setupStatus(Ref ref) async {
  final repo = ref.watch(setupRepositoryProvider);
  return repo.checkStatus();
}

// ────────────────────────────────────────────────────────────────────────────
// Setup wizard notifier
// ────────────────────────────────────────────────────────────────────────────

/// Manages the asynchronous state of the first-run setup submission.
@riverpod
class SetupNotifier extends _$SetupNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Submits [data] to the server and invalidates [setupStatusProvider] on
  /// success so the router guard re-evaluates and redirects to login.
  Future<void> complete(SetupFormData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(setupRepositoryProvider);
      await repo.completeSetup(data);
      // Invalidate cached setup status so router re-checks.
      ref.invalidate(setupStatusProvider);
    });
  }
}
