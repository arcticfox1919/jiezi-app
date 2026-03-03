// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'file_metadata.g.dart';

/// Extended, optional metadata attached to a file node.
@JsonSerializable()
class FileMetadata {
  const FileMetadata({
    this.extra,
    this.hasThumbnail,
    this.isIndexed,
    this.tags,
  });
  
  factory FileMetadata.fromJson(Map<String, Object?> json) => _$FileMetadataFromJson(json);
  
  /// Arbitrary key-value pairs sourced from upload headers or EXIF data.
  final Map<String, dynamic>? extra;

  /// Whether a thumbnail has been generated for this file.
  @JsonKey(name: 'has_thumbnail')
  final bool? hasThumbnail;

  /// Whether the file content has been submitted to the search index.
  @JsonKey(name: 'is_indexed')
  final bool? isIndexed;

  /// User-defined tags for filtering and organisation.
  final List<String>? tags;

  Map<String, Object?> toJson() => _$FileMetadataToJson(this);
}
