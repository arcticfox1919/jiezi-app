import 'dart:async';
import 'dart:convert';

import 'package:gio/gio.dart';
import 'package:jiezi_api/jiezi_api.dart';

import '../storage/token_store.dart';

/// Gio [Interceptor] that performs transparent token refresh on 401 responses.
///
/// **Chain position**: must be registered BEFORE [BearerTokenInterceptor] so
/// that the flow is:
///
/// ```
/// TokenRefreshInterceptor
///   → BearerTokenInterceptor  (injects token)
///     → network
///   ← response
/// ← intercept 401 here, refresh, retry
/// ```
///
/// **Retry loop prevention**: a marker header [_kRetried] is added to the
/// cloned request so that [TokenRefreshInterceptor] does not attempt another
/// refresh if the retried request also returns 401 (session truly invalid).
///
/// **Concurrent request coalescing**: if multiple requests receive 401
/// simultaneously, only one refresh call is issued to the server.  All other
/// callers await the same [Completer] and then retry with the fresh token.
///
/// **Refresh transport**: uses a dedicated, interceptor-free [AuthClient]
/// ([_authClient]) to call [AuthClient.refresh], reusing the generated API
/// client instead of reimplementing the HTTP call.
class TokenRefreshInterceptor {
  /// Creates a [TokenRefreshInterceptor].
  ///
  /// [tokenStore]  — reads the current refresh token, writes the new pair.
  /// [authClient]  — bare (no interceptors) [AuthClient] used exclusively to
  ///                 call [AuthClient.refresh]; must not share its [Gio]
  ///                 instance with [gio] to avoid re-entrant refresh loops.
  /// [gio]         — main [Gio] instance; used to retry the original request
  ///                 through the full interceptor chain (so [BearerTokenInterceptor]
  ///                 can inject the fresh token before the request goes to network).
  TokenRefreshInterceptor({
    required TokenStore tokenStore,
    required AuthClient authClient,
    required Gio gio,
  }) : _store = tokenStore,
       _authClient = authClient,
       _mainGio = gio;

  final TokenStore _store;

  /// Bare [AuthClient] — its internal [Gio] has no interceptors, so calling
  /// [AuthClient.refresh] cannot trigger another refresh cycle.
  final AuthClient _authClient;

  final Gio _mainGio;

  /// Non-null while a refresh is in progress (coalescing lock).
  Completer<TokenPair?>? _inflightRefresh;

  /// Header stamped on retried requests to break infinite refresh loops.
  static const _kRetried = 'X-Token-Refreshed';

  // ── Interceptor entry point ───────────────────────────────────────────────

  Future<StreamedResponse> call(Chain chain) async {
    // Already retried once — do not refresh again.
    if (chain.request.headers.containsKey(_kRetried)) {
      return chain.proceed(chain.request);
    }

    final response = await chain.proceed(chain.request);
    if (response.statusCode != 401) return response;

    // Drain the 401 body to release the underlying HTTP connection.
    await response.stream.drain<void>();

    final newPair = await _refreshTokens();

    if (newPair == null) {
      await _store.clearTokens();
      return _syntheticResponse(
        401,
        '{"code":401,"message":"session expired, please sign in again"}',
      );
    }

    // Persist fresh tokens before retrying.
    await _store.saveTokens(
      accessToken: newPair.accessToken,
      refreshToken: newPair.refreshToken,
    );

    // Clone the original request, strip the stale Authorization header
    // (BearerTokenInterceptor will re-inject the fresh one), and mark as
    // retried so the refresh interceptor skips on the second pass.
    final retryRequest = _cloneRequest(chain.request);
    retryRequest.headers.remove('Authorization');
    retryRequest.headers[_kRetried] = '1';

    // Re-enter the full interceptor chain via the main Gio instance.
    return _mainGio.send(retryRequest);
  }

  // ── Token refresh with concurrency coalescing ─────────────────────────────

  Future<TokenPair?> _refreshTokens() async {
    // Coalesce: if another request already started a refresh, wait for it.
    if (_inflightRefresh != null) return _inflightRefresh!.future;

    final completer = Completer<TokenPair?>();
    _inflightRefresh = completer;

    try {
      final result = await _doRefresh();
      completer.complete(result);
      return result;
    } catch (_) {
      completer.complete(null);
      return null;
    } finally {
      // Clear lock only if it still points to our completer.
      if (_inflightRefresh == completer) _inflightRefresh = null;
    }
  }

  Future<TokenPair?> _doRefresh() async {
    final refreshToken = _store.getRefreshToken();
    if (refreshToken == null) return null;
    return _authClient.refresh(body: RefreshBody(refreshToken: refreshToken));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Clones a [BaseRequest] so the original can be discarded safely.
  ///
  /// Only [Request] (text / JSON bodies) is supported; all REST API calls from
  /// [JieziClient] use this concrete type.  Streaming / multipart requests are
  /// returned as-is (they cannot be replayed).
  BaseRequest _cloneRequest(BaseRequest original) {
    if (original is Request) {
      return Request(original.method, original.url)
        ..headers.addAll(original.headers)
        ..encoding = original.encoding
        ..bodyBytes = original.bodyBytes;
    }
    return original;
  }

  StreamedResponse _syntheticResponse(int statusCode, String body) {
    return StreamedResponse(
      Stream.value(utf8.encode(body)),
      statusCode,
      headers: const {'content-type': 'application/json'},
    );
  }
}
