// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  credential: json['credential'] as String,
  password: json['password'] as String,
  deviceLabel: json['device_label'] as String?,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'credential': instance.credential,
      'device_label': instance.deviceLabel,
      'password': instance.password,
    };
