// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'token_pair.g.dart';

/// A short-lived access token paired with a longer-lived refresh token.
/// Returned after a successful login or token refresh.
@JsonSerializable()
class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });
  
  factory TokenPair.fromJson(Map<String, Object?> json) => _$TokenPairFromJson(json);
  
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Seconds until `access_token` expires.
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, Object?> toJson() => _$TokenPairToJson(this);
}
