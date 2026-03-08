import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gio/gio.dart';
import 'package:jiezi_api/jiezi_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/env.dart';
import '../network/bearer_token_interceptor.dart';
import '../network/token_refresh_interceptor.dart';
import '../storage/hive_kv_store.dart';
import '../storage/token_store.dart';

part 'core_providers.g.dart';

// ────────────────────────────────────────────────────────────────────────────
// App configuration
// ────────────────────────────────────────────────────────────────────────────

/// Base URL for the Jiezi Cloud API.
///
/// Override via a [ProviderScope] override in tests or for local development:
/// ```dart
/// ProviderScope(
///   overrides: [apiBaseUrlProvider.overrideWithValue('http://localhost:3000')],
///   child: const App(),
/// )
/// ```
@Riverpod(keepAlive: true)
String apiBaseUrl(Ref ref) => kApiBaseUrl;

// ────────────────────────────────────────────────────────────────────────────
// Hive boxes
// ────────────────────────────────────────────────────────────────────────────

/// Box name constants — keep these in one place to avoid typos.
abstract final class HiveBoxNames {
  /// Stores auth tokens.  Opened at startup before [runApp].
  static const auth = 'jiezi_auth';

  // Add more box names here as new storage domains are introduced:
  // static const userSettings = 'jiezi_user_settings';
  // static const fileCache    = 'jiezi_file_cache';
}

/// Pre-opened Hive box for auth tokens.
///
/// The box is opened once in [main] and injected via [ProviderScope.overrides]
/// so this provider never needs to do async work at runtime.
@Riverpod(keepAlive: true)
Future<HiveKvStore> authBox(Ref ref) => HiveKvStore.open(HiveBoxNames.auth);

// ────────────────────────────────────────────────────────────────────────────
// Token Storage
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Future<TokenStore> tokenStorage(Ref ref) async {
  final store = await ref.watch(authBoxProvider.future);
  return KvTokenStore(store);
}

// ────────────────────────────────────────────────────────────────────────────
// HTTP client (single global instance shared by all API clients)
//
// Interceptor chain order (first registered = first called):
//   1. TokenRefreshInterceptor  — catches 401, refreshes token pair, retries
//   2. BearerTokenInterceptor   — injects Authorization header
//   3. [gio internals: connect + callServer]
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Future<Gio> httpClient(Ref ref) async {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final tokenStore = await ref.watch(tokenStorageProvider.future);

  final gio = Gio();

  // A bare AuthClient (its internal Gio has no interceptors) dedicated to
  // token refresh calls.  Using the generated client avoids reimplementing
  // the HTTP request and JSON parsing that AuthClient.refresh already handles.
  final refreshAuthClient = AuthClient(
    Gio(),
    baseUrl: baseUrl.isEmpty ? null : baseUrl,
  );

  // TokenRefreshInterceptor must be first so it wraps the entire request.
  gio.addInterceptor(
    TokenRefreshInterceptor(
      tokenStore: tokenStore,
      authClient: refreshAuthClient,
      gio: gio,
    ).call,
  );
  gio.addInterceptor(BearerTokenInterceptor(tokenStore).call);

  return gio;
}

// ────────────────────────────────────────────────────────────────────────────
// JieziClient (root API entry point)
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Future<JieziClient> jieziClient(Ref ref) async {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final gio = await ref.watch(httpClientProvider.future);
  return JieziClient(gio, baseUrl: baseUrl.isEmpty ? null : baseUrl);
}
