// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'role.dart';

part 'change_role_request.g.dart';

/// Payload for `PATCH /admin/users/{id}/role` — change a user's system role.
@JsonSerializable()
class ChangeRoleRequest {
  const ChangeRoleRequest({
    required this.newRole,
  });
  
  factory ChangeRoleRequest.fromJson(Map<String, Object?> json) => _$ChangeRoleRequestFromJson(json);
  
  @JsonKey(name: 'new_role')
  final Role newRole;

  Map<String, Object?> toJson() => _$ChangeRoleRequestToJson(this);
}
