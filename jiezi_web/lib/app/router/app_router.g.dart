// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bridges Riverpod state changes into go_router refreshes.
///
/// Implements [Listenable] so that [GoRouter.refreshListenable] can drive
/// redirects whenever auth or setup state changes.

@ProviderFor(RouterNotifier)
final routerProvider = RouterNotifierProvider._();

/// Bridges Riverpod state changes into go_router refreshes.
///
/// Implements [Listenable] so that [GoRouter.refreshListenable] can drive
/// redirects whenever auth or setup state changes.
final class RouterNotifierProvider
    extends $NotifierProvider<RouterNotifier, void> {
  /// Bridges Riverpod state changes into go_router refreshes.
  ///
  /// Implements [Listenable] so that [GoRouter.refreshListenable] can drive
  /// redirects whenever auth or setup state changes.
  RouterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerNotifierHash();

  @$internal
  @override
  RouterNotifier create() => RouterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$routerNotifierHash() => r'42ec9633ccad60e2463f22bdf17aea3631e33a77';

/// Bridges Riverpod state changes into go_router refreshes.
///
/// Implements [Listenable] so that [GoRouter.refreshListenable] can drive
/// redirects whenever auth or setup state changes.

abstract class _$RouterNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'f36b3c6e2ac1304021adf590e66145c549ab6cf2';
