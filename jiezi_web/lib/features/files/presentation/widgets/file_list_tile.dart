import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiezi_api/jiezi_api.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/files_providers.dart';

/// A single row in the file browser list.
///
/// Renders an icon, file name, and a [PopupMenuButton] with context actions:
/// - Rename (all node types)
/// - Delete → soft-delete (all node types)
/// - Download (files only)
class FileListTile extends ConsumerStatefulWidget {
  const FileListTile({super.key, required this.node, this.onDirectoryTap});

  final FileNode node;

  /// Called when the user taps a directory row in list-view mode.
  /// In tree-view mode this is `null` (expansion is handled by the tree widget).
  final VoidCallback? onDirectoryTap;

  @override
  ConsumerState<FileListTile> createState() => _FileListTileState();
}

class _FileListTileState extends ConsumerState<FileListTile> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final node = widget.node;
    final isDir = node.nodeType == NodeType.directory;

    return ListTile(
      leading: Icon(
        isDir ? Icons.folder_outlined : _iconForMime(node.mimeType),
        color: isDir ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(node.name),
      subtitle: isDir ? null : Text(_formatSize(node.size)),
      onTap: isDir ? widget.onDirectoryTap : null,
      trailing: PopupMenuButton<_Action>(
        onSelected: (action) => _handleAction(context, l10n, action),
        itemBuilder: (_) => [
          PopupMenuItem(value: _Action.rename, child: Text(l10n.renameTitle)),
          PopupMenuItem(value: _Action.delete, child: Text(l10n.deleteAction)),
          if (!isDir)
            PopupMenuItem(
              value: _Action.download,
              child: Text(l10n.downloadAction),
            ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    AppLocalizations l10n,
    _Action action,
  ) async {
    switch (action) {
      case _Action.rename:
        await _showRenameDialog(context, l10n);
      case _Action.delete:
        await _showDeleteConfirm(context, l10n);
      case _Action.download:
        await _download(context);
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController(text: widget.node.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renameTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.newNameLabel),
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.renameButton),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(fileBrowserProvider.notifier)
          .renameNode(widget.node.id, controller.text.trim());
    }
    controller.dispose();
  }

  Future<void> _showDeleteConfirm(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteAction),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(fileBrowserProvider.notifier).deleteNode(widget.node.id);
    }
  }

  Future<void> _download(BuildContext context) async {
    try {
      await ref.read(fileBrowserProvider.notifier).downloadNode(widget.node);
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  IconData _iconForMime(String? mime) {
    if (mime == null) return Icons.insert_drive_file_outlined;
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime.startsWith('video/')) return Icons.video_file_outlined;
    if (mime.startsWith('audio/')) return Icons.audio_file_outlined;
    if (mime.startsWith('text/')) return Icons.description_outlined;
    if (mime == 'application/pdf') return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

enum _Action { rename, delete, download }
