// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'session_info.g.dart';

/// Represents a single active login session visible to the user.
///
/// Identified by its `family` UUID, which stays constant across all.
/// refresh-token rotations within the same login session.
@JsonSerializable()
class SessionInfo {
  const SessionInfo({
    required this.expiresAt,
    required this.family,
    required this.sessionStarted,
    this.deviceLabel,
  });
  
  factory SessionInfo.fromJson(Map<String, Object?> json) => _$SessionInfoFromJson(json);
  
  /// Human-readable label supplied by the client at login time.
  @JsonKey(name: 'device_label')
  final String? deviceLabel;

  /// When the active refresh token in this session expires.
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  /// Stable identifier for this session (JWT rotation family UUID).
  final String family;

  /// When the session was first created (i.e., when the user logged in).
  @JsonKey(name: 'session_started')
  final DateTime sessionStarted;

  Map<String, Object?> toJson() => _$SessionInfoToJson(this);
}
