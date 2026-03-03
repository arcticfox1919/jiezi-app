// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'setup_complete_request.g.dart';

/// Request body for `POST /setup/complete`.
///
/// All fields are validated server-side.  Passwords are never stored in plain.
/// text; they are hashed with Argon2id before persistence.
@JsonSerializable()
class SetupCompleteRequest {
  const SetupCompleteRequest({
    required this.adminEmail,
    required this.adminPassword,
    required this.adminUsername,
    required this.siteName,
    this.adminDisplayName,
    this.maxUploadSizeMb,
    this.registrationEnabled,
    this.siteDescription,
  });
  
  factory SetupCompleteRequest.fromJson(Map<String, Object?> json) => _$SetupCompleteRequestFromJson(json);
  
  /// Optional display name shown in the UI (e.g. "System Administrator").
  @JsonKey(name: 'admin_display_name')
  final String? adminDisplayName;

  /// Email address for the super-admin account.
  @JsonKey(name: 'admin_email')
  final String adminEmail;

  /// Password for the super-admin account (minimum 8 characters).
  @JsonKey(name: 'admin_password')
  final String adminPassword;

  /// Login username for the super-admin account (3-50 chars, alphanumeric/-/_).
  @JsonKey(name: 'admin_username')
  final String adminUsername;

  /// Maximum upload size in megabytes.
  @JsonKey(name: 'max_upload_size_mb')
  final int? maxUploadSizeMb;

  /// Allow unauthenticated visitors to register new accounts.
  /// Set to `false` for invite-only or enterprise deployments.
  @JsonKey(name: 'registration_enabled')
  final bool? registrationEnabled;

  /// Optional short description / tagline for the site.
  @JsonKey(name: 'site_description')
  final String? siteDescription;

  /// Human-readable site name shown in the web UI and emails.
  @JsonKey(name: 'site_name')
  final String siteName;

  Map<String, Object?> toJson() => _$SetupCompleteRequestToJson(this);
}
