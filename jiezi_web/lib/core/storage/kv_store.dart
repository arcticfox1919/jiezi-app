/// Generic synchronous-read / asynchronous-write key-value store.
///
/// Reads are **synchronous** because all production implementations keep the
/// box fully resident in RAM (Hive, in-memory).  Writes are asynchronous
/// because they may flush to disk or IndexedDB.
///
/// The generic API lets callers store any Hive-compatible type (`String`,
/// `int`, `bool`, `double`, `DateTime`, …) without type-specific helpers.
/// To add a new persistent data domain, open a second [HiveKvStore] with a
/// different box name and inject it as its own Riverpod provider.
abstract interface class KvStore {
  /// Returns the value stored under [key] cast to [T], or `null` if absent.
  ///
  /// Synchronous — the underlying box is memory-resident after opening.
  T? read<T>(String key);

  /// Persists [value] under [key] and flushes to the underlying store.
  Future<void> write<T>(String key, T value);

  /// Removes the entry for [key].  No-op if the key does not exist.
  Future<void> delete(String key);

  /// Clears **all** entries from this store.
  Future<void> clear();
}
