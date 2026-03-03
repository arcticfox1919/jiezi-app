// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'refresh_body.g.dart';

@JsonSerializable()
class RefreshBody {
  const RefreshBody({
    required this.refreshToken,
  });
  
  factory RefreshBody.fromJson(Map<String, Object?> json) => _$RefreshBodyFromJson(json);
  
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, Object?> toJson() => _$RefreshBodyToJson(this);
}
