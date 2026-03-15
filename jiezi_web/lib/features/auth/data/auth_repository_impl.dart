import 'package:jiezi_api/jiezi_api.dart';

import '../../../core/error/api_response_exception.dart';
import '../../../core/error/app_error.dart';
import '../../../core/storage/token_store.dart';
import '../domain/models/auth_state.dart';
import '../domain/repositories/i_auth_repository.dart';

/// [IAuthRepository] implementation backed by [AuthClient].
///
/// Persists tokens via [ITokenStorage] so sessions survive page reloads.
class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl({
    required AuthClient authClient,
    required TokenStore tokenStorage,
  }) : _auth = authClient,
       _storage = tokenStorage;

  final AuthClient _auth;
  final TokenStore _storage;

  @override
  Future<AuthState> login({
    required String username,
    required String password,
  }) async {
    try {
      final tokens = await _auth.login(
        // `credential` accepts either a username or an email address.
        body: LoginRequest(credential: username, password: password),
      );
      await _storage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      final user = await _auth.me();
      return AuthState.authenticated(
        user: user,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    try {
      await _auth.logout(body: LogoutBody(refreshToken: refreshToken));
    } finally {
      await _storage.clearTokens();
    }
  }

  @override
  Future<AuthState> restoreSession() async {
    final accessToken = _storage.getAccessToken();
    final refreshToken = _storage.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      return const AuthState.unauthenticated();
    }
    try {
      // The AuthClient already has the Bearer interceptor injected, so
      // /auth/me will receive the stored access token automatically.
      final user = await _auth.me();
      return AuthState.authenticated(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } on Exception {
      // Token is expired or invalid — clear storage and treat as logged out.
      await _storage.clearTokens();
      return const AuthState.unauthenticated();
    }
  }

  @override
  Future<void> register({
    required String username,
    String? displayName,
    required String email,
    required String password,
    String? otp,
  }) async {
    try {
      await _auth.register(
        body: RegisterRequest(
          username: username,
          displayName: displayName,
          email: email,
          password: password,
          emailOtp: otp,
        ),
      );
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> sendRegisterOtp({required String email}) async {
    try {
      await _auth.sendRegisterOtp(body: SendOtpRequest(email: email));
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  AppError _mapException(Exception e) {
    if (e is ApiResponseException) {
      if (e.statusCode == 401) return const UnauthorizedError();
      return ServerError(
        statusCode: e.statusCode,
        errorCode: e.errorCode,
        message: e.message,
      );
    }
    final msg = e.toString();
    if (msg.toLowerCase().contains('socket') ||
        msg.toLowerCase().contains('connection refused') ||
        msg.toLowerCase().contains('network is unreachable')) {
      return const NetworkError();
    }
    return UnknownError(message: msg);
  }
}
