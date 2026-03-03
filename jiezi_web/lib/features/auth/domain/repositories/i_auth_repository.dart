import '../models/auth_state.dart';

/// Contract that the auth data layer must fulfil.
abstract interface class IAuthRepository {
  /// Attempts to authenticate with [username] and [password].
  ///
  /// Returns the resulting [AuthState] on success.
  /// Throws an [AppError] subclass on failure.
  Future<AuthState> login({required String username, required String password});

  /// Invalidates the current session on both client and server.
  Future<void> logout({required String refreshToken});

  /// Tries to restore a session from persisted tokens.
  ///
  /// Returns [AuthState.unauthenticated] if no tokens are found or
  /// they cannot be refreshed.
  Future<AuthState> restoreSession();
}
