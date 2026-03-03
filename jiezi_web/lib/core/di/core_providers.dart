import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gio/gio.dart';
import 'package:jiezi_api/jiezi_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
String apiBaseUrl(Ref ref) =>
    const String.fromEnvironment('API_BASE_URL', defaultValue: '');

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
// HTTP client  (unauthenticated — used for setup / login)
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Gio gio(Ref ref) => Gio();

// ────────────────────────────────────────────────────────────────────────────
// JieziClient (root API entry point)
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
JieziClient jieziClient(Ref ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final gioInstance = ref.watch(gioProvider);
  return JieziClient(gioInstance, baseUrl: baseUrl.isEmpty ? null : baseUrl);
}
