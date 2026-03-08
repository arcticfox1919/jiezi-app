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
          AsyncValue<ISetupRepository>,
          ISetupRepository,
          FutureOr<ISetupRepository>
        >
    with $FutureModifier<ISetupRepository>, $FutureProvider<ISetupRepository> {
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
  $FutureProviderElement<ISetupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ISetupRepository> create(Ref ref) {
    return setupRepository(ref);
  }
}

String _$setupRepositoryHash() => r'2eee0ad16f0c795efe6b30c185c367b5fce631a9';

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

String _$setupStatusHash() => r'cc21ea74c844779b306d4aa8ab84e5b0635b0289';

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

String _$setupNotifierHash() => r'f680eabd54978c4f6ef643811a9cabf905d15429';

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
