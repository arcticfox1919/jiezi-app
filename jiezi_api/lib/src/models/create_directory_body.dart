// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_directory_body.g.dart';

/// Body for `POST /files/directory`.
@JsonSerializable()
class CreateDirectoryBody {
  const CreateDirectoryBody({
    required this.name,
    required this.parentId,
  });
  
  factory CreateDirectoryBody.fromJson(Map<String, Object?> json) => _$CreateDirectoryBodyFromJson(json);
  
  /// Name of the new directory.
  final String name;

  /// ID of the parent directory.
  @JsonKey(name: 'parent_id')
  final String parentId;

  Map<String, Object?> toJson() => _$CreateDirectoryBodyToJson(this);
}
