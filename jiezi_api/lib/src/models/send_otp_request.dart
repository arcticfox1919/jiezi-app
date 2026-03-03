// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'send_otp_request.g.dart';

/// Payload for `POST /auth/send-register-otp` — request an OTP for registration.
@JsonSerializable()
class SendOtpRequest {
  const SendOtpRequest({
    required this.email,
  });
  
  factory SendOtpRequest.fromJson(Map<String, Object?> json) => _$SendOtpRequestFromJson(json);
  
  /// The email address to send the OTP to.
  final String email;

  Map<String, Object?> toJson() => _$SendOtpRequestToJson(this);
}
