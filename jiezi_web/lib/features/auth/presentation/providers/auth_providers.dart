import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/env.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/error/app_error.dart';
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

// ────────────────────────────────────────────────────────────────────────────
// Registration form state
// ────────────────────────────────────────────────────────────────────────────

/// Immutable view-state for the registration form.
final class RegisterFormState {
  const RegisterFormState({
    this.isLoading = false,
    this.otpRequired = false,
    this.otpSent = false,
    this.error,
  });

  final bool isLoading;

  /// `true` when the server signalled that email OTP is required (HTTP 422).
  final bool otpRequired;

  /// `true` after a successful [RegisterNotifier.sendOtp] call.
  final bool otpSent;

  /// Non-null when the last operation produced an error.
  final AppError? error;

  RegisterFormState copyWith({
    bool? isLoading,
    bool? otpRequired,
    bool? otpSent,
    AppError? error,
    bool clearError = false,
  }) => RegisterFormState(
    isLoading: isLoading ?? this.isLoading,
    otpRequired: otpRequired ?? this.otpRequired,
    otpSent: otpSent ?? this.otpSent,
    error: clearError ? null : (error ?? this.error),
  );
}

// ────────────────────────────────────────────────────────────────────────────
// Registration notifier
// ────────────────────────────────────────────────────────────────────────────

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterFormState build() =>
      RegisterFormState(otpRequired: kEmailOtp);

  /// Sends a 6-digit OTP to [email] for email verification.
  Future<void> sendOtp({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = await ref.read(authRepositoryProvider.future);
      await repo.sendRegisterOtp(email: email);
      state = state.copyWith(isLoading: false, otpSent: true);
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: UnknownError(message: e.toString()),
      );
    }
  }

  /// Creates a new account and, on success, auto-logs in.
  ///
  /// On HTTP 422 the server requires an OTP — [RegisterFormState.otpRequired]
  /// is set to `true` so the UI reveals the verification code field.
  Future<void> register({
    required String username,
    String? displayName,
    required String email,
    required String password,
    String? otp,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = await ref.read(authRepositoryProvider.future);
      await repo.register(
        username: username,
        displayName: displayName,
        email: email,
        password: password,
        otp: otp,
      );
      // Account created — auto-login so the router guard redirects to the dashboard.
      await ref
          .read(authProvider.notifier)
          .login(credential: username, password: password);
      state = state.copyWith(isLoading: false);
    } on ServerError catch (e) {
      if (e.statusCode == 422) {
        // OTP required or invalid — expose the OTP field.
        state = state.copyWith(isLoading: false, otpRequired: true, error: e);
      } else {
        state = state.copyWith(isLoading: false, error: e);
      }
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: UnknownError(message: e.toString()),
      );
    }
  }
}
