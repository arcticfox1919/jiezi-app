import 'package:gio/gio.dart';

import '../storage/token_store.dart';

/// Gio [Interceptor] that injects `Authorization: Bearer <token>` on every
/// request when an access token is present in [TokenStore].
///
/// Public auth/setup endpoints are explicitly excluded so that stale tokens
/// are never forwarded to routes that do not require authentication
/// (login, register, token-refresh, setup wizard).
///
/// Usage:
/// ```dart
/// final gio = Gio();
/// gio.addInterceptor(BearerTokenInterceptor(tokenStore).call);
/// ```
class BearerTokenInterceptor {
  const BearerTokenInterceptor(this._store);

  final TokenStore _store;

  static const _kAuthorization = 'Authorization';

  /// Path suffixes that must never carry an Authorization header.
  /// These are public endpoints where a Bearer token is irrelevant and
  /// a stale/revoked token could cause unexpected server behaviour.
  static const _kPublicSuffixes = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];

  bool _isPublic(Uri url) {
    final path = url.path;
    if (path.contains('/setup')) return true;
    return _kPublicSuffixes.any(path.endsWith);
  }

  Future<StreamedResponse> call(Chain chain) async {
    final token = _store.getAccessToken();
    if (token != null && !_isPublic(chain.request.url)) {
      chain.request.headers[_kAuthorization] = 'Bearer $token';
    }
    return chain.proceed(chain.request);
  }
}
