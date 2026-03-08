import 'package:gio/gio.dart';

import '../storage/token_store.dart';

/// Gio [Interceptor] that injects `Authorization: Bearer <token>` on every
/// request when an access token is present in [TokenStore].
///
/// When the store holds no token (unauthenticated / setup flow) the request is
/// forwarded unchanged — safe to use on all requests.
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

  Future<StreamedResponse> call(Chain chain) async {
    final token = _store.getAccessToken();
    if (token != null) {
      chain.request.headers[_kAuthorization] = 'Bearer $token';
    }
    return chain.proceed(chain.request);
  }
}
