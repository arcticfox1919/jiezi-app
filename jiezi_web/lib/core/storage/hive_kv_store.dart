import 'package:hive_flutter/hive_flutter.dart';

import 'kv_store.dart';

/// [KvStore] backed by a Hive [Box].
///
/// Uses `Box<dynamic>` so any Hive-compatible type can be stored via the
/// generic [write] / [read] API without additional adapters.
///
/// - **Web**: persists to IndexedDB (binary, more efficient than localStorage).
/// - **Native**: writes a binary `.hive` file in the app-documents directory.
///
/// Use [HiveKvStore.open] to obtain an instance; it is safe to call multiple
/// times for the same [boxName] (Hive returns the already-open box).
class HiveKvStore implements KvStore {
  HiveKvStore(this._box);

  final Box<dynamic> _box;

  /// Opens [boxName] and returns a ready-to-use [HiveKvStore].
  static Future<HiveKvStore> open(String boxName) async {
    final box = await Hive.openBox<dynamic>(boxName);
    return HiveKvStore(box);
  }

  // ── KvStore ────────────────────────────────────────────────────────────────

  /// Synchronous — the box is fully resident in memory after [open].
  @override
  T? read<T>(String key) => _box.get(key) as T?;

  @override
  Future<void> write<T>(String key, T value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<void> clear() => _box.clear().then((_) {});
}
