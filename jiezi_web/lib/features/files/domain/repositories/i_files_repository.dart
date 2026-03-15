import 'package:jiezi_api/jiezi_api.dart';

/// Contract for virtual file-system CRUD operations.
///
/// Upload / download are intentionally excluded — they are platform-specific
/// and handled by [WebFileTransferService] in the data layer.
abstract interface class IFilesRepository {
  /// Returns the root-level nodes (space roots) for the current user.
  Future<List<FileNode>> listRoots();

  /// Provisions the personal root directory (and default subdirectories) for
  /// the current user.  Safe to call only when [listRoots] returned empty.
  Future<FileNode> createRoot();

  /// Lists the direct children of the directory identified by [parentId].
  Future<List<FileNode>> listChildren(String parentId);

  /// Creates a new subdirectory inside [parentId] with the given [name].
  Future<FileNode> createDirectory({
    required String name,
    required String parentId,
  });

  /// Renames the node identified by [id] to [newName].
  Future<FileNode> rename({required String id, required String newName});

  /// Moves the node identified by [id] to [newParentId].
  Future<FileNode> move({required String id, required String newParentId});

  /// Soft-deletes (moves to Trash) the node identified by [id].
  Future<void> softDelete(String id);

  /// Returns all soft-deleted nodes for the current user.
  Future<List<FileNode>> listTrash();

  /// Restores the trashed node identified by [id].
  Future<FileNode> restore(String id);

  /// Permanently destroys the node identified by [id].
  ///
  /// This action is irreversible.
  Future<void> permanentDelete(String id);
}
