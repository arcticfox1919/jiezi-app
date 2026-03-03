// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'change_own_password_request.g.dart';

/// Payload for `POST /auth/me/password` — change own password.
@JsonSerializable()
class ChangeOwnPasswordRequest {
  const ChangeOwnPasswordRequest({
    required this.newPassword,
    required this.oldPassword,
    this.emailOtp,
  });
  
  factory ChangeOwnPasswordRequest.fromJson(Map<String, Object?> json) => _$ChangeOwnPasswordRequestFromJson(json);
  
  /// 6-digit OTP sent to the account email.  Required when.
  /// `email_verification_required` is enabled in config.
  @JsonKey(name: 'email_otp')
  final String? emailOtp;

  /// The desired new password (minimum 8 characters).
  @JsonKey(name: 'new_password')
  final String newPassword;

  /// The caller's current password (verified before accepting the change).
  @JsonKey(name: 'old_password')
  final String oldPassword;

  Map<String, Object?> toJson() => _$ChangeOwnPasswordRequestToJson(this);
}
