// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'setup_status_response.g.dart';

/// Response body for `GET /setup/status`.
@JsonSerializable()
class SetupStatusResponse {
  const SetupStatusResponse({
    required this.setupRequired,
    required this.version,
  });
  
  factory SetupStatusResponse.fromJson(Map<String, Object?> json) => _$SetupStatusResponseFromJson(json);
  
  /// When `true` the server requires setup before it can be used.
  @JsonKey(name: 'setup_required')
  final bool setupRequired;

  /// Jiezi Cloud server version string.
  final String version;

  Map<String, Object?> toJson() => _$SetupStatusResponseToJson(this);
}
