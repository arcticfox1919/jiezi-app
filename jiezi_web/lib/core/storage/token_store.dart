import 'kv_store.dart';

/// Domain-level token persistence contract.
///
/// Depend on this interface — not on [KvTokenStore] or any concrete store —
/// so the storage backend can be swapped (Hive → secure storage, …) without
/// touching any presentation or domain code.
abstract interface class TokenStore {
  /// Returns the persisted access token, or `null` if absent.
  String? getAccessToken();

  /// Returns the persisted refresh token, or `null` if absent.
  String? getRefreshToken();

  /// Persists [accessToken] and [refreshToken].
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// Removes both tokens (e.g. on logout).
  Future<void> clearTokens();
}

// ────────────────────────────────────────────────────────────────────────────
// Default implementation
// ────────────────────────────────────────────────────────────────────────────

/// [TokenStore] backed by any [KvStore].
///
/// Swapping the backend requires only a [KvStore] implementation change in
/// the DI layer — nothing in domain or presentation needs to change.
class KvTokenStore implements TokenStore {
  const KvTokenStore(this._store);

  static const _kAccess = 'auth.access_token';
  static const _kRefresh = 'auth.refresh_token';

  final KvStore _store;

  // Synchronous — the KV store is memory-resident.
  @override
  String? getAccessToken() => _store.read<String>(_kAccess);

  @override
  String? getRefreshToken() => _store.read<String>(_kRefresh);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) => Future.wait([
    _store.write(_kAccess, accessToken),
    _store.write(_kRefresh, refreshToken),
  ]).then((_) {});

  @override
  Future<void> clearTokens() => Future.wait([
    _store.delete(_kAccess),
    _store.delete(_kRefresh),
  ]).then((_) {});
}
