// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'copy_body.g.dart';

/// Body for `POST /files/{id}/copy`.
@JsonSerializable()
class CopyBody {
  const CopyBody({
    required this.newParentId,
  });
  
  factory CopyBody.fromJson(Map<String, Object?> json) => _$CopyBodyFromJson(json);
  
  /// ID of the destination parent directory.
  @JsonKey(name: 'new_parent_id')
  final String newParentId;

  Map<String, Object?> toJson() => _$CopyBodyToJson(this);
}
