// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

/// Payload for the user registration endpoint.
@JsonSerializable()
class RegisterRequest {
  const RegisterRequest({
    required this.email,
    required this.password,
    required this.username,
    this.displayName,
    this.emailOtp,
  });
  
  factory RegisterRequest.fromJson(Map<String, Object?> json) => _$RegisterRequestFromJson(json);
  
  /// Optional friendly name shown in the UI.
  @JsonKey(name: 'display_name')
  final String? displayName;
  final String email;

  /// OTP code sent to `email` via `POST /auth/send-register-otp`.
  ///
  /// Required when `email.verification_required = true` in config;.
  /// ignored (and may be absent) otherwise.
  @JsonKey(name: 'email_otp')
  final String? emailOtp;
  final String password;
  final String username;

  Map<String, Object?> toJson() => _$RegisterRequestToJson(this);
}
