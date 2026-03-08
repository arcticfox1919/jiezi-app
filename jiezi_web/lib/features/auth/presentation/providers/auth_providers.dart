import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/repositories/i_auth_repository.dart';

part 'auth_providers.g.dart';

// ────────────────────────────────────────────────────────────────────────────
// Repository provider
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Future<IAuthRepository> authRepository(Ref ref) async {
  final client = await ref.watch(jieziClientProvider.future);
  final storage = await ref.watch(tokenStorageProvider.future);
  return AuthRepositoryImpl(authClient: client.auth, tokenStorage: storage);
}

// ────────────────────────────────────────────────────────────────────────────
// Auth state (kept alive — drives the router guard)
// ────────────────────────────────────────────────────────────────────────────

/// Provides the current [AuthState].
///
/// On cold start it attempts to restore a session from persisted tokens.
@Riverpod(keepAlive: true)
Future<AuthState> authState(Ref ref) async {
  final repo = await ref.watch(authRepositoryProvider.future);
  return repo.restoreSession();
}

// ────────────────────────────────────────────────────────────────────────────
// Auth notifier
// ────────────────────────────────────────────────────────────────────────────

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Authenticates with [credential] (username or email) and [password].
  ///
  /// On success, invalidates [authStateProvider] so the router guard
  /// re-evaluates and redirects to the dashboard.
  Future<void> login({
    required String credential,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      await repo.login(username: credential, password: password);
      ref.invalidate(authStateProvider);
    });
  }

  /// Logs out and clears the local session.
  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Read the current auth state via the provider's future.
      final authAsync = await ref.read(authStateProvider.future);
      final refreshToken = authAsync.refreshToken;
      if (refreshToken != null) {
        final repo = await ref.read(authRepositoryProvider.future);
        await repo.logout(refreshToken: refreshToken);
      }
      ref.invalidate(authStateProvider);
    });
  }
}
