// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(filesRepository)
final filesRepositoryProvider = FilesRepositoryProvider._();

final class FilesRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<IFilesRepository>,
          IFilesRepository,
          FutureOr<IFilesRepository>
        >
    with $FutureModifier<IFilesRepository>, $FutureProvider<IFilesRepository> {
  FilesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filesRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<IFilesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IFilesRepository> create(Ref ref) {
    return filesRepository(ref);
  }
}

String _$filesRepositoryHash() => r'9586c1893aa6a4f241f1eac16969898fad9372f1';

@ProviderFor(webFileTransfer)
final webFileTransferProvider = WebFileTransferProvider._();

final class WebFileTransferProvider
    extends
        $FunctionalProvider<
          WebFileTransferService,
          WebFileTransferService,
          WebFileTransferService
        >
    with $Provider<WebFileTransferService> {
  WebFileTransferProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webFileTransferProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webFileTransferHash();

  @$internal
  @override
  $ProviderElement<WebFileTransferService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WebFileTransferService create(Ref ref) {
    return webFileTransfer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebFileTransferService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebFileTransferService>(value),
    );
  }
}

String _$webFileTransferHash() => r'7bcf8fdb7085ac8ba1adc8561a45458a7663d534';

@ProviderFor(resumableUploadService)
final resumableUploadServiceProvider = ResumableUploadServiceProvider._();

final class ResumableUploadServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ResumableUploadService>,
          ResumableUploadService,
          FutureOr<ResumableUploadService>
        >
    with
        $FutureModifier<ResumableUploadService>,
        $FutureProvider<ResumableUploadService> {
  ResumableUploadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumableUploadServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumableUploadServiceHash();

  @$internal
  @override
  $FutureProviderElement<ResumableUploadService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ResumableUploadService> create(Ref ref) {
    return resumableUploadService(ref);
  }
}

String _$resumableUploadServiceHash() =>
    r'b225b3a832baffc1ff70acf95476b1fe283e2221';

@ProviderFor(FileBrowser)
final fileBrowserProvider = FileBrowserProvider._();

final class FileBrowserProvider
    extends $NotifierProvider<FileBrowser, FileBrowserState> {
  FileBrowserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileBrowserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileBrowserHash();

  @$internal
  @override
  FileBrowser create() => FileBrowser();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileBrowserState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileBrowserState>(value),
    );
  }
}

String _$fileBrowserHash() => r'f5eee024b93129f06682904015ffd1d2a62ceb09';

abstract class _$FileBrowser extends $Notifier<FileBrowserState> {
  FileBrowserState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FileBrowserState, FileBrowserState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FileBrowserState, FileBrowserState>,
              FileBrowserState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Trash)
final trashProvider = TrashProvider._();

final class TrashProvider extends $NotifierProvider<Trash, TrashState> {
  TrashProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trashProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trashHash();

  @$internal
  @override
  Trash create() => Trash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrashState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrashState>(value),
    );
  }
}

String _$trashHash() => r'a9ed00aefc916394cfe73c179a612b27f6359efb';

abstract class _$Trash extends $Notifier<TrashState> {
  TrashState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TrashState, TrashState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrashState, TrashState>,
              TrashState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
