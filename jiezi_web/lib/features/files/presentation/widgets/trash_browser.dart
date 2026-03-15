import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiezi_api/jiezi_api.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/files_providers.dart';

/// Displays soft-deleted nodes with Restore and Delete Forever actions.
class TrashBrowser extends ConsumerWidget {
  const TrashBrowser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trashProvider);
    final l10n = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(state.error!.message),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => ref.read(trashProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(child: Text(l10n.emptyTrashMessage));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(trashProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (_, i) => _TrashTile(node: state.items[i]),
      ),
    );
  }
}

class _TrashTile extends ConsumerWidget {
  const _TrashTile({required this.node});

  final FileNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDir = node.nodeType == NodeType.directory;

    return ListTile(
      leading: Icon(
        isDir ? Icons.folder_outlined : Icons.insert_drive_file_outlined,
      ),
      title: Text(node.name),
      subtitle: node.deletedAt != null
          ? Text('Deleted ${_formatDate(node.deletedAt!)}')
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.restore_outlined),
            tooltip: l10n.restoreAction,
            onPressed: () => _restore(context, ref, l10n),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            tooltip: l10n.deleteForeverAction,
            color: Theme.of(context).colorScheme.error,
            onPressed: () => _confirmPermanentDelete(context, ref, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    await ref.read(trashProvider.notifier).restoreItem(node.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${node.name} ${l10n.restoreAction.toLowerCase()}d'),
        ),
      );
    }
  }

  Future<void> _confirmPermanentDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.permanentDeleteConfirmTitle),
        content: Text(l10n.permanentDeleteConfirmBody),
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
            child: Text(l10n.deleteForeverAction),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(trashProvider.notifier).permanentDeleteItem(node.id);
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
