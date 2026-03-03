// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(setupRepository)
final setupRepositoryProvider = SetupRepositoryProvider._();

final class SetupRepositoryProvider
    extends
        $FunctionalProvider<
          ISetupRepository,
          ISetupRepository,
          ISetupRepository
        >
    with $Provider<ISetupRepository> {
  SetupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupRepositoryHash();

  @$internal
  @override
  $ProviderElement<ISetupRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISetupRepository create(Ref ref) {
    return setupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISetupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISetupRepository>(value),
    );
  }
}

String _$setupRepositoryHash() => r'6242c7b793d166cdc2ba689eada4bce33f5e19fe';

/// Resolves the server's current setup state.
///
/// Keep-alive because the router guard reads it on every navigation event.

@ProviderFor(setupStatus)
final setupStatusProvider = SetupStatusProvider._();

/// Resolves the server's current setup state.
///
/// Keep-alive because the router guard reads it on every navigation event.

final class SetupStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<SetupStatus>,
          SetupStatus,
          FutureOr<SetupStatus>
        >
    with $FutureModifier<SetupStatus>, $FutureProvider<SetupStatus> {
  /// Resolves the server's current setup state.
  ///
  /// Keep-alive because the router guard reads it on every navigation event.
  SetupStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupStatusHash();

  @$internal
  @override
  $FutureProviderElement<SetupStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SetupStatus> create(Ref ref) {
    return setupStatus(ref);
  }
}

String _$setupStatusHash() => r'dd4d9b7a86200e65a617182a75df0fb3cd32e012';

/// Manages the asynchronous state of the first-run setup submission.

@ProviderFor(SetupNotifier)
final setupProvider = SetupNotifierProvider._();

/// Manages the asynchronous state of the first-run setup submission.
final class SetupNotifierProvider
    extends $NotifierProvider<SetupNotifier, AsyncValue<void>> {
  /// Manages the asynchronous state of the first-run setup submission.
  SetupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupNotifierHash();

  @$internal
  @override
  SetupNotifier create() => SetupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$setupNotifierHash() => r'bfd5b6d8068697c0eaf87828f197194a8031886c';

/// Manages the asynchronous state of the first-run setup submission.

abstract class _$SetupNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
