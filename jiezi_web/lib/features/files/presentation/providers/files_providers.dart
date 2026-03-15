import 'dart:typed_data';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:jiezi_api/jiezi_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/error/app_error.dart';
import '../../data/files_repository_impl.dart';
import '../../data/resumable_upload_service.dart';
import '../../data/web_file_transfer_service.dart';
import '../../domain/repositories/i_files_repository.dart';

part 'files_providers.g.dart';

// ────────────────────────────────────────────────────────────────────────────
// Repository
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Future<IFilesRepository> filesRepository(Ref ref) async {
  final client = await ref.watch(jieziClientProvider.future);
  return FilesRepositoryImpl(filesClient: client.files);
}

// ────────────────────────────────────────────────────────────────────────────
// File transfer service
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
WebFileTransferService webFileTransfer(Ref ref) {
  return const WebFileTransferService();
}

@Riverpod(keepAlive: true)
Future<ResumableUploadService> resumableUploadService(Ref ref) async {
  final client = await ref.watch(resumableUploadClientProvider.future);
  return ResumableUploadService(client);
}

// ────────────────────────────────────────────────────────────────────────────
// File browser state & notifier
// ────────────────────────────────────────────────────────────────────────────

/// A [TreeNode] whose [data] is a [FileNode] from the API model.
typedef FileTreeNode = TreeNode<FileNode>;

/// Controls which pane is shown in the file browser.
enum ViewMode {
  /// Hierarchical tree — lazy-loads children on expand.
  tree,

  /// Flat list — shows children of the currently selected directory.
  list,
}

/// Immutable snapshot of the file browser.
///
/// The file hierarchy is represented as a [FileTreeNode] tree whose root is a
/// synthetic container node ([data] == `null`).  Each real [FileNode] lives in
/// a child [FileTreeNode] keyed by its [FileNode.id].  Children are loaded
/// lazily when the user expands a directory node.
class FileBrowserState {
  const FileBrowserState({
    this.treeRoot,
    this.selectedNode,
    this.viewMode = ViewMode.tree,
    this.isLoading = false,
    this.isUploading = false,
    this.error,
  });

  /// The root of the lazy-loaded file tree.  `null` while the initial root
  /// listing is in progress.
  final FileTreeNode? treeRoot;

  /// The directory node that is currently focused for CRUD / upload actions.
  final FileTreeNode? selectedNode;

  /// Whether to show the tree pane or the flat-list pane.
  final ViewMode viewMode;

  final bool isLoading;

  /// True while an upload XHR is in progress.
  final bool isUploading;

  final AppError? error;

  /// Convenience accessor for the [FileNode] of the selected directory.
  FileNode? get currentDir => selectedNode?.data;

  /// Children of [selectedNode], sorted directories-first then alpha.
  List<FileTreeNode> get selectedChildren =>
      selectedNode?.childrenAsList.cast<FileTreeNode>() ?? [];

  FileBrowserState copyWith({
    FileTreeNode? treeRoot,
    FileTreeNode? selectedNode,
    ViewMode? viewMode,
    bool? isLoading,
    bool? isUploading,
    AppError? error,
    bool clearError = false,
    bool clearSelectedNode = false,
  }) {
    return FileBrowserState(
      treeRoot: treeRoot ?? this.treeRoot,
      selectedNode: clearSelectedNode
          ? null
          : (selectedNode ?? this.selectedNode),
      viewMode: viewMode ?? this.viewMode,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class FileBrowser extends _$FileBrowser {
  @override
  FileBrowserState build() {
    // Kick-off root loading after the current frame to avoid calling async
    // methods during synchronous build.
    Future.microtask(_loadRoots);
    return const FileBrowserState(isLoading: true);
  }

  // ── View mode ──────────────────────────────────────────────────────────────

  /// Switches between [ViewMode.tree] and [ViewMode.list].
  void setViewMode(ViewMode mode) => state = state.copyWith(viewMode: mode);

  // ── Tree operations ────────────────────────────────────────────────────────

  /// Lazily loads [FileNode] children for [treeNode] if not already loaded.
  ///
  /// Called by the tree-view widget when the user expands a directory node.
  /// Children are appended to [treeNode] and the notifier state is updated so
  /// that the selected directory tracks the expanded node.
  Future<void> loadChildren(FileTreeNode treeNode) async {
    final nodeData = treeNode.data;
    if (nodeData == null) return;
    // Skip if children were already fetched (non-root nodes with children).
    if (treeNode.childrenAsList.isNotEmpty) {
      state = state.copyWith(selectedNode: treeNode, clearError: true);
      return;
    }
    state = state.copyWith(
      selectedNode: treeNode,
      isLoading: true,
      clearError: true,
    );
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      final items = await repo.listChildren(nodeData.id);
      final sorted = _sorted(items);
      treeNode.addAll(sorted.map((n) => FileTreeNode(key: n.id, data: n)));
      state = state.copyWith(isLoading: false);
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: UnknownError(message: e.toString()),
      );
    }
  }

  /// Reloads the children of [selectedNode] from the server.
  ///
  /// Clears the existing children before fetching to ensure stale entries are
  /// removed (e.g. after rename / delete / create).
  Future<void> refresh() async {
    final treeNode = state.selectedNode;
    if (treeNode == null) {
      await _loadRoots();
      return;
    }
    // Remove all existing children so they are re-fetched from the API.
    treeNode.clear();
    await loadChildren(treeNode);
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  /// Creates a new subdirectory with [name] inside [selectedNode].
  Future<void> createFolder(String name) async {
    final parentId = state.currentDir?.id;
    if (parentId == null) return;
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      await repo.createDirectory(name: name, parentId: parentId);
      await refresh();
    } on AppError catch (e) {
      state = state.copyWith(error: e);
    }
  }

  /// Renames the node identified by [id] to [newName].
  Future<void> renameNode(String id, String newName) async {
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      await repo.rename(id: id, newName: newName);
      await refresh();
    } on AppError catch (e) {
      state = state.copyWith(error: e);
    }
  }

  /// Soft-deletes the node identified by [id].
  Future<void> deleteNode(String id) async {
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      await repo.softDelete(id);
      await refresh();
    } on AppError catch (e) {
      state = state.copyWith(error: e);
    }
  }

  // ── Upload ─────────────────────────────────────────────────────────────────

  /// Opens the OS file picker and uploads the chosen file into [selectedNode]
  /// using the resumable chunked-upload protocol.
  Future<void> uploadFile() async {
    final parentId = state.currentDir?.id;
    if (parentId == null) return;

    // Read the file first (before showing the uploading indicator) so the
    // spinner only appears while bytes are actually being transferred.
    final transfer = ref.read(webFileTransferProvider);
    final picked = await transfer.pickFile();
    if (picked == null) return; // user cancelled

    state = state.copyWith(isUploading: true, clearError: true);
    try {
      final service = await ref.read(resumableUploadServiceProvider.future);
      await service.upload(
        parentId: parentId,
        fileName: picked.name,
        bytes: picked.bytes,
        mimeType: picked.mimeType,
      );
      await refresh();
    } on Exception catch (e) {
      state = state.copyWith(error: UnknownError(message: e.toString()));
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }

  /// Uploads one or more files from a drag-and-drop event into [selectedNode].
  ///
  /// [files] is a list of `(fileName, bytes, mimeType)` records obtained from
  /// the browser's [DataTransfer] API.
  Future<void> dropUpload(
    List<({String name, Uint8List bytes, String mimeType})> files,
  ) async {
    final parentId = state.currentDir?.id;
    if (parentId == null || files.isEmpty) return;

    state = state.copyWith(isUploading: true, clearError: true);
    try {
      final service = await ref.read(resumableUploadServiceProvider.future);
      for (final f in files) {
        await service.upload(
          parentId: parentId,
          fileName: f.name,
          bytes: f.bytes,
          mimeType: f.mimeType,
        );
      }
      await refresh();
    } on Exception catch (e) {
      state = state.copyWith(error: UnknownError(message: e.toString()));
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }

  // ── Download ───────────────────────────────────────────────────────────────

  /// Downloads [node] via [DownloadClient] and triggers the browser save dialog.
  Future<void> downloadNode(FileNode node) async {
    try {
      final downloader = await ref.read(downloadClientProvider.future);
      final bytes = await downloader.downloadFile(node.id);
      final transfer = ref.read(webFileTransferProvider);
      transfer.triggerSaveDialog(bytes: bytes, fileName: node.name);
    } on Exception catch (e) {
      state = state.copyWith(error: UnknownError(message: e.toString()));
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _loadRoots() async {
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      var roots = await repo.listRoots();
      // First-time users have no root yet — provision the default directory tree.
      if (roots.isEmpty) {
        await repo.createRoot();
        roots = await repo.listRoots();
      }
      if (roots.isEmpty) {
        state = const FileBrowserState();
        return;
      }
      // Build a synthetic root node (invisible in the tree) and add all server
      // roots as its immediate children — each is a top-level directory.
      final syntheticRoot = FileTreeNode.root();
      final rootNodes = <FileTreeNode>[];
      for (final root in roots) {
        final rootNode = FileTreeNode(key: root.id, data: root);
        syntheticRoot.add(rootNode);
        rootNodes.add(rootNode);
      }
      // Select and pre-load the first root so the list-view is populated
      // immediately without requiring the user to manually expand a node.
      state = state.copyWith(
        treeRoot: syntheticRoot,
        selectedNode: rootNodes.first,
        isLoading: false,
        clearError: true,
      );
      // Load children of the first root in the background.
      await loadChildren(rootNodes.first);
    } on AppError catch (e) {
      state = FileBrowserState(error: e);
    } catch (e) {
      state = FileBrowserState(error: UnknownError(message: e.toString()));
    }
  }

  /// Directories first, then files — each group sorted alphabetically.
  static List<FileNode> _sorted(List<FileNode> items) {
    final dirs = items.where((n) => n.nodeType == NodeType.directory).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final files = items.where((n) => n.nodeType != NodeType.directory).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return [...dirs, ...files];
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Trash state & notifier
// ────────────────────────────────────────────────────────────────────────────

/// Immutable snapshot of the trash browser.
class TrashState {
  const TrashState({this.items = const [], this.isLoading = false, this.error});

  final List<FileNode> items;
  final bool isLoading;
  final AppError? error;

  TrashState copyWith({
    List<FileNode>? items,
    bool? isLoading,
    AppError? error,
    bool clearError = false,
  }) {
    return TrashState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class Trash extends _$Trash {
  @override
  TrashState build() {
    Future.microtask(_load);
    return const TrashState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _load();
  }

  Future<void> restoreItem(String id) async {
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      await repo.restore(id);
      await refresh();
    } on AppError catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> permanentDeleteItem(String id) async {
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      await repo.permanentDelete(id);
      await refresh();
    } on AppError catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> _load() async {
    try {
      final repo = await ref.read(filesRepositoryProvider.future);
      final items = await repo.listTrash();
      items.sort(
        (a, b) =>
            (b.deletedAt ?? b.updatedAt).compareTo(a.deletedAt ?? a.updatedAt),
      );
      state = state.copyWith(items: items, isLoading: false, clearError: true);
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
