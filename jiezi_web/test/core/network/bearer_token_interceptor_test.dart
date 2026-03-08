import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:gio/gio.dart' hide group;

import 'package:jiezi_web/core/network/bearer_token_interceptor.dart';
import 'package:jiezi_web/core/storage/token_store.dart';

// ── In-memory fake ────────────────────────────────────────────────────────────

class _FakeTokenStore implements TokenStore {
  _FakeTokenStore({String? accessToken, String? refreshToken})
    : _accessToken = accessToken,
      _refreshToken = refreshToken;

  String? _accessToken;
  String? _refreshToken;

  @override
  String? getAccessToken() => _accessToken;

  @override
  String? getRefreshToken() => _refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
  }
}

/// Records which request was passed to [proceed].
class _CapturingChain implements Chain {
  _CapturingChain(this.request);

  @override
  final BaseRequest request;

  BaseRequest? capturedRequest;

  @override
  Future<StreamedResponse> proceed(BaseRequest request) async {
    capturedRequest = request;
    return StreamedResponse(const Stream.empty(), 200);
  }
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('BearerTokenInterceptor', () {
    test('does not add Authorization header when no token is stored', () async {
      final store = _FakeTokenStore();
      final interceptor = BearerTokenInterceptor(store);
      final chain = _CapturingChain(Request('GET', Uri.parse('http://example.com/test')));

      await interceptor.call(chain);

      expect(chain.capturedRequest!.headers.containsKey('Authorization'), isFalse);
    });

    test('injects Bearer token when an access token is present', () async {
      final store = _FakeTokenStore(accessToken: 'tok_abc');
      final interceptor = BearerTokenInterceptor(store);
      final chain = _CapturingChain(Request('GET', Uri.parse('http://example.com/test')));

      await interceptor.call(chain);

      expect(chain.capturedRequest!.headers['Authorization'], 'Bearer tok_abc');
    });

    test('overwrites a stale Authorization header with the current token', () async {
      final store = _FakeTokenStore(accessToken: 'tok_new');
      final interceptor = BearerTokenInterceptor(store);
      final req = Request('GET', Uri.parse('http://example.com/test'))
        ..headers['Authorization'] = 'Bearer tok_old';
      final chain = _CapturingChain(req);

      await interceptor.call(chain);

      expect(chain.capturedRequest!.headers['Authorization'], 'Bearer tok_new');
    });

    test('returns the response from chain.proceed unchanged', () async {
      final store = _FakeTokenStore(accessToken: 'tok');
      final interceptor = BearerTokenInterceptor(store);
      Request req = Request('GET', Uri.parse('http://example.com/test'));
      final chain = _CapturingChain(req);

      final response = await interceptor.call(chain);

      expect(response.statusCode, 200);
    });
  });
}
