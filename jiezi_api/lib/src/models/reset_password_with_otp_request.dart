// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reset_password_with_otp_request.g.dart';

/// Payload for `POST /auth/reset-password` — reset password using an OTP code.
@JsonSerializable()
class ResetPasswordWithOtpRequest {
  const ResetPasswordWithOtpRequest({
    required this.code,
    required this.email,
    required this.newPassword,
  });
  
  factory ResetPasswordWithOtpRequest.fromJson(Map<String, Object?> json) => _$ResetPasswordWithOtpRequestFromJson(json);
  
  /// The 6-digit OTP that was emailed via `POST /auth/forgot-password`.
  final String code;
  final String email;
  @JsonKey(name: 'new_password')
  final String newPassword;

  Map<String, Object?> toJson() => _$ResetPasswordWithOtpRequestToJson(this);
}
