// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileNode _$FileNodeFromJson(Map<String, dynamic> json) => FileNode(
  createdAt: DateTime.parse(json['created_at'] as String),
  id: json['id'] as String,
  metadata: FileMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  name: json['name'] as String,
  nodeType: NodeType.fromJson(json['node_type'] as String),
  ownerId: json['owner_id'] as String,
  size: (json['size'] as num).toInt(),
  spaceId: json['space_id'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  contentHash: json['content_hash'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  mimeType: json['mime_type'] as String?,
  parentId: json['parent_id'] as String?,
);

Map<String, dynamic> _$FileNodeToJson(FileNode instance) => <String, dynamic>{
  'content_hash': instance.contentHash,
  'created_at': instance.createdAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'id': instance.id,
  'metadata': instance.metadata,
  'mime_type': instance.mimeType,
  'name': instance.name,
  'node_type': _$NodeTypeEnumMap[instance.nodeType]!,
  'owner_id': instance.ownerId,
  'parent_id': instance.parentId,
  'size': instance.size,
  'space_id': instance.spaceId,
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$NodeTypeEnumMap = {
  NodeType.file: 'file',
  NodeType.directory: 'directory',
  NodeType.symlink: 'symlink',
  NodeType.$unknown: r'$unknown',
};
