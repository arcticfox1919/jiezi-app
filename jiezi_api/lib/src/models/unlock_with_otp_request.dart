// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'unlock_with_otp_request.g.dart';

/// Payload for `POST /auth/unlock-account` — unlock a locked account using OTP.
@JsonSerializable()
class UnlockWithOtpRequest {
  const UnlockWithOtpRequest({
    required this.code,
    required this.email,
  });
  
  factory UnlockWithOtpRequest.fromJson(Map<String, Object?> json) => _$UnlockWithOtpRequestFromJson(json);
  
  /// The 6-digit OTP that was emailed via `POST /auth/send-unlock-otp`.
  final String code;
  final String email;

  Map<String, Object?> toJson() => _$UnlockWithOtpRequestToJson(this);
}
