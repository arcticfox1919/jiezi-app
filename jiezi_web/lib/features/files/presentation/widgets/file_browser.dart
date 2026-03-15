import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiezi_api/jiezi_api.dart';
import 'package:web/web.dart' as web;

import '../../../../l10n/app_localizations.dart';
import '../providers/files_providers.dart';
import 'file_list_pane.dart';
import 'file_list_tile.dart';

/// Full-featured file browser panel.
///
/// Hosts two interchangeable panes — a lazy-loading tree ([ViewMode.tree]) and
/// a flat list of the selected directory's children ([ViewMode.list]).
/// The user switches between them with a [SegmentedButton] in the toolbar.
/// Both panes are kept alive via [IndexedStack] so scroll/expansion state is
/// preserved across switches.
///
/// The panel doubles as a drop target: dragging files from the OS onto any
/// part of the browser uploads them into the currently selected directory.
class FileBrowser extends ConsumerStatefulWidget {
  const FileBrowser({super.key});

  @override
  ConsumerState<FileBrowser> createState() => _FileBrowserState();
}

class _FileBrowserState extends ConsumerState<FileBrowser> {
  bool _isDragOver = false;

  // Native DOM event listener refs so they can be removed on dispose.
  JSFunction? _onDragOver;
  JSFunction? _onDragLeave;
  JSFunction? _onDrop;

  @override
  void initState() {
    super.initState();
    _registerDropListeners();
  }

  @override
  void dispose() {
    _unregisterDropListeners();
    super.dispose();
  }

  void _registerDropListeners() {
    final body = web.document.body;
    if (body == null) return;

    _onDragOver = (web.DragEvent e) {
      e.preventDefault();
      if (!_isDragOver) setState(() => _isDragOver = true);
    }.toJS;

    _onDragLeave = (web.DragEvent e) {
      // Only clear the flag when the pointer leaves the whole window.
      if (e.relatedTarget == null) setState(() => _isDragOver = false);
    }.toJS;

    _onDrop = (web.DragEvent e) {
      e.preventDefault();
      setState(() => _isDragOver = false);
      final dt = e.dataTransfer;
      if (dt == null) return;
      final items = dt.files;
      if (items.length == 0) return;
      _handleDroppedFiles(items);
    }.toJS;

    body.addEventListener('dragover', _onDragOver);
    body.addEventListener('dragleave', _onDragLeave);
    body.addEventListener('drop', _onDrop);
  }

  void _unregisterDropListeners() {
    final body = web.document.body;
    if (body == null) return;
    if (_onDragOver != null) body.removeEventListener('dragover', _onDragOver);
    if (_onDragLeave != null) {
      body.removeEventListener('dragleave', _onDragLeave);
    }
    if (_onDrop != null) body.removeEventListener('drop', _onDrop);
  }

  Future<void> _handleDroppedFiles(web.FileList fileList) async {
    final files = <({String name, Uint8List bytes, String mimeType})>[];
    for (var i = 0; i < fileList.length; i++) {
      final file = fileList.item(i);
      if (file == null) continue;
      final bytes = await _readFile(file);
      files.add((
        name: file.name,
        bytes: bytes,
        mimeType: file.type.isNotEmpty ? file.type : 'application/octet-stream',
      ));
    }
    if (files.isNotEmpty) {
      await ref.read(fileBrowserProvider.notifier).dropUpload(files);
    }
  }

  Future<Uint8List> _readFile(web.File file) {
    final completer = Completer<Uint8List>();
    final reader = web.FileReader();
    reader.onloadend = (web.Event _) {
      try {
        completer.complete(
          (reader.result as JSArrayBuffer).toDart.asUint8List(),
        );
      } catch (e) {
        completer.completeError(Exception('Failed to read file: $e'));
      }
    }.toJS;
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileBrowserProvider);
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildToolbar(context, ref, state),
              const Divider(height: 1),
              Expanded(child: _buildActivePane(context, ref, state, l10n)),
            ],
          ),
          floatingActionButton: _buildFab(context, ref, state, l10n),
        ),
        // Drag-over overlay
        if (_isDragOver)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.dropFilesHint,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // Upload progress overlay
        if (state.isUploading)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  /// Toolbar: current directory name on the left; view-mode toggle on the right.
  Widget _buildToolbar(
    BuildContext context,
    WidgetRef ref,
    FileBrowserState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.currentDir?.name ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SegmentedButton<ViewMode>(
            segments: const [
              ButtonSegment(
                value: ViewMode.tree,
                icon: Icon(Icons.account_tree_outlined),
                tooltip: 'Tree view',
              ),
              ButtonSegment(
                value: ViewMode.list,
                icon: Icon(Icons.list_outlined),
                tooltip: 'List view',
              ),
            ],
            selected: {state.viewMode},
            onSelectionChanged: (s) =>
                ref.read(fileBrowserProvider.notifier).setViewMode(s.first),
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }

  /// Switches between [_TreePane] and [FileListPane] via [IndexedStack].
  Widget _buildActivePane(
    BuildContext context,
    WidgetRef ref,
    FileBrowserState state,
    AppLocalizations l10n,
  ) {
    if (state.isLoading && state.treeRoot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.treeRoot == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(state.error!.message),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => ref.read(fileBrowserProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.treeRoot == null) {
      return Center(child: Text(l10n.emptyFolderMessage));
    }

    return IndexedStack(
      index: state.viewMode == ViewMode.tree ? 0 : 1,
      children: const [_TreePane(), FileListPane()],
    );
  }

  Widget? _buildFab(
    BuildContext context,
    WidgetRef ref,
    FileBrowserState state,
    AppLocalizations l10n,
  ) {
    if (state.isLoading || state.currentDir == null) return null;

    return FloatingActionButton(
      onPressed: () => _showAddMenu(context, ref, l10n),
      child: state.isUploading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.add),
    );
  }

  void _showAddMenu(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: Text(l10n.newFolderTitle),
              onTap: () {
                Navigator.of(ctx).pop();
                _showNewFolderDialog(context, ref, l10n);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: Text(l10n.uploadAction),
              onTap: () {
                Navigator.of(ctx).pop();
                ref.read(fileBrowserProvider.notifier).uploadFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNewFolderDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newFolderTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.folderNameLabel),
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.createButton),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(fileBrowserProvider.notifier)
          .createFolder(controller.text.trim());
    }
    controller.dispose();
  }
}

// ---------------------------------------------------------------------------
// Private tree pane — lazy-loading hierarchical view
// ---------------------------------------------------------------------------

/// Shows the entire VFS tree with lazy-loaded children.
///
/// Extracted from [FileBrowser] so it can live alongside [FileListPane] inside
/// an [IndexedStack] without re-building when the user switches view modes.
class _TreePane extends ConsumerWidget {
  const _TreePane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileBrowserProvider);
    final l10n = AppLocalizations.of(context)!;

    final root = state.treeRoot;
    if (root == null) return Center(child: Text(l10n.emptyFolderMessage));

    return TreeView.simpleTyped<FileNode, FileTreeNode>(
      tree: root,
      showRootNode: false,
      expansionBehavior: ExpansionBehavior.scrollToLastChild,
      expansionIndicatorBuilder: (ctx, node) => ChevronIndicator.rightDown(
        tree: node,
        padding: const EdgeInsets.all(8),
      ),
      indentation: const Indentation(style: IndentStyle.squareJoint, width: 20),
      onItemTap: (node) => _onNodeTap(ref, node),
      builder: (ctx, node) => _buildNodeTile(node),
    );
  }

  void _onNodeTap(WidgetRef ref, FileTreeNode node) {
    final data = node.data;
    if (data == null) return;
    if (data.nodeType == NodeType.directory) {
      ref.read(fileBrowserProvider.notifier).loadChildren(node);
    }
  }

  Widget _buildNodeTile(FileTreeNode node) {
    final data = node.data;
    if (data == null) return const SizedBox.shrink();
    return FileListTile(node: data);
  }
}
