// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request.g.dart';

/// Payload for updating one's own profile (display name, avatar).
///
/// Each field is doubly-wrapped in `Option` so the client can distinguish.
/// "omit this field" (`None`) from "clear this field" (`Some(None)`).
@JsonSerializable()
class UpdateProfileRequest {
  const UpdateProfileRequest({
    this.avatarUrl,
    this.displayName,
  });
  
  factory UpdateProfileRequest.fromJson(Map<String, Object?> json) => _$UpdateProfileRequestFromJson(json);
  
  /// Pass `Some(Some("https://…"))` to set, `Some(None)` to clear.
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// Pass `Some(Some("Alice"))` to set, `Some(None)` to clear.
  @JsonKey(name: 'display_name')
  final String? displayName;

  Map<String, Object?> toJson() => _$UpdateProfileRequestToJson(this);
}
