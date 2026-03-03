// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'file_id.dart';
import 'file_metadata.dart';
import 'node_type.dart';
import 'space_id.dart';
import 'user_id.dart';

part 'file_node.g.dart';

/// A node in the virtual file system — either a file or a directory.
///
/// File content is stored separately by the storage backend; this struct.
/// holds only the metadata that lives in the database.
@JsonSerializable()
class FileNode {
  const FileNode({
    required this.createdAt,
    required this.id,
    required this.metadata,
    required this.name,
    required this.nodeType,
    required this.ownerId,
    required this.size,
    required this.spaceId,
    required this.updatedAt,
    this.contentHash,
    this.deletedAt,
    this.mimeType,
    this.parentId,
  });
  
  factory FileNode.fromJson(Map<String, Object?> json) => _$FileNodeFromJson(json);
  
  /// SHA-256 hex digest of the full file content.
  @JsonKey(name: 'content_hash')
  final String? contentHash;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Set when the node has been soft-deleted (moved to trash).
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  final FileId id;
  final FileMetadata metadata;

  /// MIME type detected at upload time (e.g. `"image/jpeg"`).
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  final String name;
  @JsonKey(name: 'node_type')
  final NodeType nodeType;
  @JsonKey(name: 'owner_id')
  final UserId ownerId;

  /// `None` only for the root node of a space.
  @JsonKey(name: 'parent_id')
  final FileId? parentId;

  /// File size in bytes.  Zero for directories.
  final int size;
  @JsonKey(name: 'space_id')
  final SpaceId spaceId;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$FileNodeToJson(this);
}
