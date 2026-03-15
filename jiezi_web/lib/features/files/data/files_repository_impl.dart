import 'package:jiezi_api/jiezi_api.dart';

import '../../../core/error/api_response_exception.dart';
import '../../../core/error/app_error.dart';
import '../domain/repositories/i_files_repository.dart';

/// [IFilesRepository] backed entirely by the generated [FilesClient].
///
/// All operations delegate to [FilesClient]; no raw HTTP calls are required.
class FilesRepositoryImpl implements IFilesRepository {
  const FilesRepositoryImpl({required FilesClient filesClient})
    : _files = filesClient;

  final FilesClient _files;

  // ── IFilesRepository ───────────────────────────────────────────────────────

  @override
  Future<List<FileNode>> listRoots() async {
    try {
      return await _files.listRoots();
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<FileNode> createRoot() async {
    try {
      return await _files.createRoot();
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<List<FileNode>> listChildren(String parentId) async {
    try {
      return await _files.listChildren(id: parentId);
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<FileNode> createDirectory({
    required String name,
    required String parentId,
  }) async {
    try {
      return await _files.createDirectory(
        body: CreateDirectoryBody(name: name, parentId: parentId),
      );
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<FileNode> rename({required String id, required String newName}) async {
    try {
      return await _files.rename(
        id: id,
        body: RenameBody(newName: newName),
      );
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<FileNode> move({
    required String id,
    required String newParentId,
  }) async {
    try {
      return await _files.moveNode(
        id: id,
        body: MoveBody(newParentId: newParentId),
      );
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> softDelete(String id) async {
    try {
      await _files.softDelete(id: id);
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<List<FileNode>> listTrash() async {
    try {
      return await _files.listTrash();
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<FileNode> restore(String id) async {
    try {
      return await _files.restore(id: id);
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> permanentDelete(String id) async {
    try {
      await _files.permanentDelete(id: id);
    } on Exception catch (e) {
      throw _map(e);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  AppError _map(Exception e) {
    if (e is ApiResponseException) {
      if (e.statusCode == 401) return const UnauthorizedError();
      return ServerError(
        statusCode: e.statusCode,
        errorCode: e.errorCode,
        message: e.message,
      );
    }
    final msg = e.toString();
    if (msg.toLowerCase().contains('socket') ||
        msg.toLowerCase().contains('connection refused') ||
        msg.toLowerCase().contains('network is unreachable')) {
      return const NetworkError();
    }
    return UnknownError(message: msg);
  }
}
