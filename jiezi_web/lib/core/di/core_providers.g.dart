// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Base URL for the Jiezi Cloud API.
///
/// Override via a [ProviderScope] override in tests or for local development:
/// ```dart
/// ProviderScope(
///   overrides: [apiBaseUrlProvider.overrideWithValue('http://localhost:3000')],
///   child: const App(),
/// )
/// ```

@ProviderFor(apiBaseUrl)
final apiBaseUrlProvider = ApiBaseUrlProvider._();

/// Base URL for the Jiezi Cloud API.
///
/// Override via a [ProviderScope] override in tests or for local development:
/// ```dart
/// ProviderScope(
///   overrides: [apiBaseUrlProvider.overrideWithValue('http://localhost:3000')],
///   child: const App(),
/// )
/// ```

final class ApiBaseUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Base URL for the Jiezi Cloud API.
  ///
  /// Override via a [ProviderScope] override in tests or for local development:
  /// ```dart
  /// ProviderScope(
  ///   overrides: [apiBaseUrlProvider.overrideWithValue('http://localhost:3000')],
  ///   child: const App(),
  /// )
  /// ```
  ApiBaseUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiBaseUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiBaseUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return apiBaseUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$apiBaseUrlHash() => r'8351588cbdf03f1e08dc6ac707fdce35b6d9df57';

/// Pre-opened Hive box for auth tokens.
///
/// The box is opened once in [main] and injected via [ProviderScope.overrides]
/// so this provider never needs to do async work at runtime.

@ProviderFor(authBox)
final authBoxProvider = AuthBoxProvider._();

/// Pre-opened Hive box for auth tokens.
///
/// The box is opened once in [main] and injected via [ProviderScope.overrides]
/// so this provider never needs to do async work at runtime.

final class AuthBoxProvider
    extends
        $FunctionalProvider<
          AsyncValue<HiveKvStore>,
          HiveKvStore,
          FutureOr<HiveKvStore>
        >
    with $FutureModifier<HiveKvStore>, $FutureProvider<HiveKvStore> {
  /// Pre-opened Hive box for auth tokens.
  ///
  /// The box is opened once in [main] and injected via [ProviderScope.overrides]
  /// so this provider never needs to do async work at runtime.
  AuthBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authBoxHash();

  @$internal
  @override
  $FutureProviderElement<HiveKvStore> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HiveKvStore> create(Ref ref) {
    return authBox(ref);
  }
}

String _$authBoxHash() => r'cdba7bcd846952ccb08f9c056b6efc7aadb5bd42';

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

final class TokenStorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<TokenStore>,
          TokenStore,
          FutureOr<TokenStore>
        >
    with $FutureModifier<TokenStore>, $FutureProvider<TokenStore> {
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $FutureProviderElement<TokenStore> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TokenStore> create(Ref ref) {
    return tokenStorage(ref);
  }
}

String _$tokenStorageHash() => r'fb324cc44cec38170ad4b8e8099fc5ae55d83d06';

@ProviderFor(gio)
final gioProvider = GioProvider._();

final class GioProvider extends $FunctionalProvider<Gio, Gio, Gio>
    with $Provider<Gio> {
  GioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gioHash();

  @$internal
  @override
  $ProviderElement<Gio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Gio create(Ref ref) {
    return gio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Gio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Gio>(value),
    );
  }
}

String _$gioHash() => r'9ef02813d2a7e321a0e58fc812266d3e45b4be0b';

@ProviderFor(jieziClient)
final jieziClientProvider = JieziClientProvider._();

final class JieziClientProvider
    extends $FunctionalProvider<JieziClient, JieziClient, JieziClient>
    with $Provider<JieziClient> {
  JieziClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jieziClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jieziClientHash();

  @$internal
  @override
  $ProviderElement<JieziClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JieziClient create(Ref ref) {
    return jieziClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JieziClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JieziClient>(value),
    );
  }
}

String _$jieziClientHash() => r'13a0785fcd92323f94f8344686903e90fbbc5bb1';
