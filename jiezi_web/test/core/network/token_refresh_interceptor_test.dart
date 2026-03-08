import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gio/gio.dart' hide group;
import 'package:jiezi_api/jiezi_api.dart';

import 'package:jiezi_web/core/network/token_refresh_interceptor.dart';
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

/// A [Chain] that returns a pre-configured [StreamedResponse].
class _StubbedChain implements Chain {
  _StubbedChain({required BaseRequest request, required this.response})
    : _request = request;

  final BaseRequest _request;
  final StreamedResponse response;

  @override
  BaseRequest get request => _request;

  @override
  Future<StreamedResponse> proceed(BaseRequest request) async => response;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Builds an [AuthClient] whose underlying [Gio] always responds with the
/// given [statusCode] and [body].
AuthClient _fakeAuthClient({
  int statusCode = 200,
  String? body,
}) {
  final fakeGio = Gio();
  fakeGio.addInterceptor((chain) async {
    return StreamedResponse(
      Stream.value(
        utf8.encode(
          body ??
              '{"access_token":"new_access","refresh_token":"new_refresh","expires_in":3600}',
        ),
      ),
      statusCode,
      headers: const {'content-type': 'application/json'},
    );
  });
  return AuthClient(fakeGio, baseUrl: 'http://test');
}

/// Builds a [Gio] whose interceptor chain returns 200 for any request.
Gio _fakeMainGio() {
  final gio = Gio();
  gio.addInterceptor(
    (chain) async =>
        StreamedResponse(Stream.value(utf8.encode('{"ok":true}')), 200),
  );
  return gio;
}

StreamedResponse _response(int status) => StreamedResponse(
  Stream.value(utf8.encode('{"code":$status}')),
  status,
);

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('TokenRefreshInterceptor', () {
    test('passes through responses with status != 401 unchanged', () async {
      final store = _FakeTokenStore(refreshToken: 'rt');
      final interceptor = TokenRefreshInterceptor(
        tokenStore: store,
        authClient: _fakeAuthClient(),
        gio: _fakeMainGio(),
      );

      final chain = _StubbedChain(
        request: Request('GET', Uri.parse('http://example.com/data')),
        response: _response(200),
      );

      final result = await interceptor.call(chain);
      expect(result.statusCode, 200);
    });

    test('on 401: refreshes tokens, saves new pair, and retries', () async {
      final store = _FakeTokenStore(
        accessToken: 'old_access',
        refreshToken: 'old_refresh',
      );
      final interceptor = TokenRefreshInterceptor(
        tokenStore: store,
        authClient: _fakeAuthClient(),
        gio: _fakeMainGio(),
      );

      final chain = _StubbedChain(
        request: Request('GET', Uri.parse('http://example.com/me')),
        response: StreamedResponse(
          Stream.value(utf8.encode('{"code":401}')),
          401,
        ),
      );

      final result = await interceptor.call(chain);

      // The retry returns 200 from _fakeMainGio.
      expect(result.statusCode, 200);
      // Fresh tokens must have been persisted.
      expect(store.getAccessToken(), 'new_access');
      expect(store.getRefreshToken(), 'new_refresh');
    });

    test('on 401 with failed refresh: clears tokens and returns 401', () async {
      final store = _FakeTokenStore(refreshToken: 'expired_rt');
      // Return an invalid JSON body so AuthClient.refresh() throws when
      // trying to deserialise the response into TokenPair.
      final interceptor = TokenRefreshInterceptor(
        tokenStore: store,
        authClient: _fakeAuthClient(
          statusCode: 401,
          body: '{"error":"invalid_token"}',
        ),
        gio: _fakeMainGio(),
      );

      final chain = _StubbedChain(
        request: Request('GET', Uri.parse('http://example.com/me')),
        response: StreamedResponse(
          Stream.value(utf8.encode('{"code":401}')),
          401,
        ),
      );

      final result = await interceptor.call(chain);

      expect(result.statusCode, 401);
      // Tokens must have been cleared.
      expect(store.getAccessToken(), isNull);
      expect(store.getRefreshToken(), isNull);
    });

    test('request already marked as retried is passed through without refresh', () async {
      final store = _FakeTokenStore(refreshToken: 'rt');
      var refreshCalled = false;

      final fakeGio = Gio();
      fakeGio.addInterceptor((chain) async {
        refreshCalled = true;
        return StreamedResponse(
          Stream.value(
            utf8.encode(
              '{"access_token":"a","refresh_token":"r","expires_in":3600}',
            ),
          ),
          200,
        );
      });

      final interceptor = TokenRefreshInterceptor(
        tokenStore: store,
        authClient: AuthClient(fakeGio, baseUrl: 'http://test'),
        gio: _fakeMainGio(),
      );

      // Stamp the retry marker so the interceptor must skip refresh.
      final req = Request('GET', Uri.parse('http://example.com/me'))
        ..headers['X-Token-Refreshed'] = '1';

      final chain = _StubbedChain(request: req, response: _response(401));

      await interceptor.call(chain);

      expect(refreshCalled, isFalse);
    });

    test('concurrent 401s coalesce into a single refresh call', () async {
      final store = _FakeTokenStore(refreshToken: 'rt');
      var refreshCallCount = 0;

      final fakeGio = Gio();
      fakeGio.addInterceptor((chain) async {
        refreshCallCount++;
        // Simulate network latency so concurrent callers all queue up.
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return StreamedResponse(
          Stream.value(
            utf8.encode(
              '{"access_token":"new","refresh_token":"new_r","expires_in":3600}',
            ),
          ),
          200,
          headers: const {'content-type': 'application/json'},
        );
      });

      final interceptor = TokenRefreshInterceptor(
        tokenStore: store,
        authClient: AuthClient(fakeGio, baseUrl: 'http://test'),
        gio: _fakeMainGio(),
      );

      // Three independent chains, each with its own response stream.
      final chains = List.generate(
        3,
        (_) => _StubbedChain(
          request: Request('GET', Uri.parse('http://example.com/api')),
          response: StreamedResponse(
            Stream.value(utf8.encode('{"code":401}')),
            401,
          ),
        ),
      );

      // Fire three concurrent requests that all receive 401.
      await Future.wait([
        interceptor.call(chains[0]),
        interceptor.call(chains[1]),
        interceptor.call(chains[2]),
      ]);

      expect(refreshCallCount, 1);
    });
  });
}
