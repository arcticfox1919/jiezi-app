import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/files_providers.dart';
import 'file_list_tile.dart';

/// Flat-list view of the currently selected directory's immediate children.
///
/// This pane is shown when [ViewMode.list] is active.  It is purely a
/// presentation widget — all data loading is driven by [FileBrowserNotifier].
class FileListPane extends ConsumerWidget {
  const FileListPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileBrowserProvider);
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
              onPressed: () => ref.read(fileBrowserProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final children = state.selectedChildren;
    if (children.isEmpty) {
      return Center(child: Text(l10n.emptyFolderMessage));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(fileBrowserProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: children.length,
        itemBuilder: (_, i) {
          final node = children[i];
          // For directories, tapping in list-view loads children and focuses
          // that node (so FAB and CRUD actions target it).
          return node.data == null
              ? const SizedBox.shrink()
              : FileListTile(
                  node: node.data!,
                  onDirectoryTap: () =>
                      ref.read(fileBrowserProvider.notifier).loadChildren(node),
                );
        },
      ),
    );
  }
}
