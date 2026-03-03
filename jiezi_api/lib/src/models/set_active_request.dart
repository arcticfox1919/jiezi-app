// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'set_active_request.g.dart';

/// Payload for `PATCH /admin/users/{id}/status` — suspend or reactivate.
@JsonSerializable()
class SetActiveRequest {
  const SetActiveRequest({
    required this.isActive,
  });
  
  factory SetActiveRequest.fromJson(Map<String, Object?> json) => _$SetActiveRequestFromJson(json);
  
  @JsonKey(name: 'is_active')
  final bool isActive;

  Map<String, Object?> toJson() => _$SetActiveRequestToJson(this);
}
