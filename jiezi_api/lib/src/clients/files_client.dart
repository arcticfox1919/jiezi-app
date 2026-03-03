// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';

import 'package:gio/gio.dart';

import '../models/copy_body.dart';
import '../models/create_directory_body.dart';
import '../models/file_node.dart';
import '../models/move_body.dart';
import '../models/rename_body.dart';

/// FilesClient
class FilesClient {
  /// Creates a [FilesClient] using the provided [gio] instance.
  ///
  /// [baseUrl] overrides any base URL already configured on the
  /// [Gio] instance for this client only.
  FilesClient(Gio gio, {String? baseUrl})
      : _gio = gio,
        _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  /// `POST /files/directory` — create a new subdirectory.
  Future<FileNode> createDirectory({
    required CreateDirectoryBody body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/files/directory',
      jsonBody: body.toJson(),
    );
    return FileNode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `GET /files/trash` — list all soft-deleted nodes owned by the caller.
  Future<List<FileNode>> listTrash() async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/files/trash',
    );
    return (jsonDecode(response.body) as List)
        .map((e) => FileNode.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `GET /files/{id}` — fetch a single node.
  ///
  /// [id] - File/directory node ID.
  Future<FileNode> getNode({
    required String id,
  }) async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/files/${id}',
    );
    return FileNode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `DELETE /files/{id}` — soft-delete (move to trash).
  ///
  /// [id] - Node ID.
  Future<void> softDelete({
    required String id,
  }) async {
    await _gio.delete(
      '${_baseUrl ?? ''}/api/v1/files/${id}',
    );
  }

  /// `GET /files/{id}/children?page=1&per_page=20` — list a directory's contents.
  ///
  /// [id] - Directory node ID.
  ///
  /// [page] - Page number (1-based).
  ///
  /// [perPage] - Items per page.
  Future<List<FileNode>> listChildren({
    required String id,
    int? page,
    int? perPage,
  }) async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/files/${id}/children',
      queryParameters: {
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (jsonDecode(response.body) as List)
        .map((e) => FileNode.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `POST /files/{id}/copy` — copy a node (and subtree) under a new parent.
  ///
  /// Returns the root of the copied subtree with a new ID.
  ///
  /// [id] - Node ID.
  Future<FileNode> copyNode({
    required String id,
    required CopyBody body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/files/${id}/copy',
      jsonBody: body.toJson(),
    );
    return FileNode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `POST /files/{id}/move` — move a node to a different parent.
  ///
  /// [id] - Node ID.
  Future<FileNode> moveNode({
    required String id,
    required MoveBody body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/files/${id}/move',
      jsonBody: body.toJson(),
    );
    return FileNode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `PUT /files/{id}/name` — rename a node.
  ///
  /// [id] - Node ID.
  Future<FileNode> rename({
    required String id,
    required RenameBody body,
  }) async {
    final response = await _gio.put(
      '${_baseUrl ?? ''}/api/v1/files/${id}/name',
      jsonBody: body.toJson(),
    );
    return FileNode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `DELETE /files/{id}/permanent` — permanently destroy a node.
  ///
  /// Irreversible.  The node and all its descendants are removed from the.
  /// database.  Content deduplication means storage chunks are only freed.
  /// by a separate garbage-collection pass.
  ///
  /// [id] - Node ID.
  Future<void> permanentDelete({
    required String id,
  }) async {
    await _gio.delete(
      '${_baseUrl ?? ''}/api/v1/files/${id}/permanent',
    );
  }

  /// `POST /files/{id}/restore` — restore from trash.
  ///
  /// [id] - Node ID.
  Future<FileNode> restore({
    required String id,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/files/${id}/restore',
    );
    return FileNode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
