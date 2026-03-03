// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'setup_complete_response.g.dart';

/// Response body for a successful `POST /setup/complete`.
@JsonSerializable()
class SetupCompleteResponse {
  const SetupCompleteResponse({
    required this.message,
    required this.success,
  });
  
  factory SetupCompleteResponse.fromJson(Map<String, Object?> json) => _$SetupCompleteResponseFromJson(json);
  
  final String message;
  final bool success;

  Map<String, Object?> toJson() => _$SetupCompleteResponseToJson(this);
}
