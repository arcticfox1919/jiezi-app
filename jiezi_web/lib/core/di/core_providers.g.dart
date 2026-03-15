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

String _$apiBaseUrlHash() => r'b64aed5dfae0913bcc463501afc102455839077f';

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

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<AsyncValue<Gio>, Gio, FutureOr<Gio>>
    with $FutureModifier<Gio>, $FutureProvider<Gio> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $FutureProviderElement<Gio> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Gio> create(Ref ref) {
    return httpClient(ref);
  }
}

String _$httpClientHash() => r'0406c55c26eb20109967731e996fa5f804c91bd1';

@ProviderFor(jieziClient)
final jieziClientProvider = JieziClientProvider._();

final class JieziClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<JieziClient>,
          JieziClient,
          FutureOr<JieziClient>
        >
    with $FutureModifier<JieziClient>, $FutureProvider<JieziClient> {
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
  $FutureProviderElement<JieziClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JieziClient> create(Ref ref) {
    return jieziClient(ref);
  }
}

String _$jieziClientHash() => r'e429e749248fd3deddcb7439e6ece9dda1ea73c4';

@ProviderFor(resumableUploadClient)
final resumableUploadClientProvider = ResumableUploadClientProvider._();

final class ResumableUploadClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<ResumableUploadClient>,
          ResumableUploadClient,
          FutureOr<ResumableUploadClient>
        >
    with
        $FutureModifier<ResumableUploadClient>,
        $FutureProvider<ResumableUploadClient> {
  ResumableUploadClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumableUploadClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumableUploadClientHash();

  @$internal
  @override
  $FutureProviderElement<ResumableUploadClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ResumableUploadClient> create(Ref ref) {
    return resumableUploadClient(ref);
  }
}

String _$resumableUploadClientHash() =>
    r'c0718afbc389f613a523d4c723d23d4957fdf121';

@ProviderFor(downloadClient)
final downloadClientProvider = DownloadClientProvider._();

final class DownloadClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<DownloadClient>,
          DownloadClient,
          FutureOr<DownloadClient>
        >
    with $FutureModifier<DownloadClient>, $FutureProvider<DownloadClient> {
  DownloadClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadClientHash();

  @$internal
  @override
  $FutureProviderElement<DownloadClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DownloadClient> create(Ref ref) {
    return downloadClient(ref);
  }
}

String _$downloadClientHash() => r'de5f6ce7e3a353ca5f05dfbbe0fb75286cea2718';
