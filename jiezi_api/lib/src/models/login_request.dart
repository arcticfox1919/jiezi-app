// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// Payload for the user login endpoint.
@JsonSerializable()
class LoginRequest {
  const LoginRequest({
    required this.credential,
    required this.password,
    this.deviceLabel,
  });
  
  factory LoginRequest.fromJson(Map<String, Object?> json) => _$LoginRequestFromJson(json);
  
  /// Either a username or an email address.
  final String credential;

  /// Optional human-readable label for the device initiating the login.
  /// Shown in the active sessions list so users can identify and revoke.
  /// specific devices (e.g. "iPhone 15", "Home PC — Firefox").
  @JsonKey(name: 'device_label')
  final String? deviceLabel;
  final String password;

  Map<String, Object?> toJson() => _$LoginRequestToJson(this);
}
