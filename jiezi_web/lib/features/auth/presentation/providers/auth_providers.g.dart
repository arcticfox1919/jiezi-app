// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<IAuthRepository>,
          IAuthRepository,
          FutureOr<IAuthRepository>
        >
    with $FutureModifier<IAuthRepository>, $FutureProvider<IAuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<IAuthRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IAuthRepository> create(Ref ref) {
    return authRepository(ref);
  }
}

String _$authRepositoryHash() => r'24990b8c2596d6682f13298cf98c7d1aff320ce6';

/// Provides the current [AuthState].
///
/// On cold start it attempts to restore a session from persisted tokens.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Provides the current [AuthState].
///
/// On cold start it attempts to restore a session from persisted tokens.

final class AuthStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthState>,
          AuthState,
          FutureOr<AuthState>
        >
    with $FutureModifier<AuthState>, $FutureProvider<AuthState> {
  /// Provides the current [AuthState].
  ///
  /// On cold start it attempts to restore a session from persisted tokens.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $FutureProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthState> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'314084a186f9956f0a9b44b487adff4ad3ee5b2a';

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AsyncValue<void>> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$authNotifierHash() => r'7e3e7f73ad329d5bde2f92f63f77c94550f9f513';

abstract class _$AuthNotifier extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(RegisterNotifier)
final registerProvider = RegisterNotifierProvider._();

final class RegisterNotifierProvider
    extends $NotifierProvider<RegisterNotifier, RegisterFormState> {
  RegisterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerNotifierHash();

  @$internal
  @override
  RegisterNotifier create() => RegisterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterFormState>(value),
    );
  }
}

String _$registerNotifierHash() => r'425b58dfd0d05af4189972f7613cfbd8bd291c33';

abstract class _$RegisterNotifier extends $Notifier<RegisterFormState> {
  RegisterFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RegisterFormState, RegisterFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RegisterFormState, RegisterFormState>,
              RegisterFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
