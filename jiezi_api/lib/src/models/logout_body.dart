// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'logout_body.g.dart';

@JsonSerializable()
class LogoutBody {
  const LogoutBody({
    required this.refreshToken,
  });
  
  factory LogoutBody.fromJson(Map<String, Object?> json) => _$LogoutBodyFromJson(json);
  
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, Object?> toJson() => _$LogoutBodyToJson(this);
}
