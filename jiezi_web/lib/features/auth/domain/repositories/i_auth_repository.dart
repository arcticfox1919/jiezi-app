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

  /// Creates a new user account.
  ///
  /// [otp] is only required when the server has email verification enabled
  /// (`email.verification_required = true`).  Throws [ServerError] with
  /// `statusCode == 422` when the server demands an OTP that was not supplied
  /// or is invalid, [ServerError] with `statusCode == 403` when registration
  /// is disabled, and [ServerError] with `statusCode == 409` when the
  /// username or email is already taken.
  Future<void> register({
    required String username,
    String? displayName,
    required String email,
    required String password,
    String? otp,
  });

  /// Sends a 6-digit OTP to [email] for use in [register].
  ///
  /// No-op (204) when the server does not require email verification.
  Future<void> sendRegisterOtp({required String email});
}
