// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'role.dart';
import 'user_id.dart';

part 'user.g.dart';

/// Core user entity.
@JsonSerializable()
class User {
  const User({
    required this.createdAt,
    required this.email,
    required this.emailVerified,
    required this.id,
    required this.isActive,
    required this.role,
    required this.storageUsed,
    required this.updatedAt,
    required this.username,
    this.avatarUrl,
    this.displayName,
    this.storageQuota,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  /// Optional URL to the user's avatar image.
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Optional display name shown in the UI.
  @JsonKey(name: 'display_name')
  final String? displayName;
  final String email;

  /// Whether the user has verified their email address via OTP.
  ///
  /// When `email.verification_required = true` in config, users must supply.
  /// the correct OTP code during registration before the account is confirmed.
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  final UserId id;

  /// Whether the account is active (not suspended).
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// System-level role.
  final Role role;

  /// Maximum storage this user may consume across all their spaces,.
  /// in bytes.  `None` means unlimited.
  @JsonKey(name: 'storage_quota')
  final int? storageQuota;

  /// Running total of bytes consumed.
  @JsonKey(name: 'storage_used')
  final int storageUsed;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String username;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
