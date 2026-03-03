// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'rename_body.g.dart';

/// Body for `PUT /files/{id}/name`.
@JsonSerializable()
class RenameBody {
  const RenameBody({
    required this.newName,
  });
  
  factory RenameBody.fromJson(Map<String, Object?> json) => _$RenameBodyFromJson(json);
  
  @JsonKey(name: 'new_name')
  final String newName;

  Map<String, Object?> toJson() => _$RenameBodyToJson(this);
}
