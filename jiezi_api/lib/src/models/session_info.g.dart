// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) => SessionInfo(
  expiresAt: DateTime.parse(json['expires_at'] as String),
  family: json['family'] as String,
  sessionStarted: DateTime.parse(json['session_started'] as String),
  deviceLabel: json['device_label'] as String?,
);

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'device_label': instance.deviceLabel,
      'expires_at': instance.expiresAt.toIso8601String(),
      'family': instance.family,
      'session_started': instance.sessionStarted.toIso8601String(),
    };
