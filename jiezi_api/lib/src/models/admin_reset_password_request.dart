// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_reset_password_request.g.dart';

/// Payload for `POST /admin/users/{id}/reset-password` — admin force-reset.
@JsonSerializable()
class AdminResetPasswordRequest {
  const AdminResetPasswordRequest({
    required this.newPassword,
  });
  
  factory AdminResetPasswordRequest.fromJson(Map<String, Object?> json) => _$AdminResetPasswordRequestFromJson(json);
  
  /// The new password to assign.  Minimum 8 characters.
  @JsonKey(name: 'new_password')
  final String newPassword;

  Map<String, Object?> toJson() => _$AdminResetPasswordRequestToJson(this);
}
