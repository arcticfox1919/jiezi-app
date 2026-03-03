// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'move_body.g.dart';

/// Body for `POST /files/{id}/move`.
@JsonSerializable()
class MoveBody {
  const MoveBody({
    required this.newParentId,
  });
  
  factory MoveBody.fromJson(Map<String, Object?> json) => _$MoveBodyFromJson(json);
  
  @JsonKey(name: 'new_parent_id')
  final String newParentId;

  Map<String, Object?> toJson() => _$MoveBodyToJson(this);
}
