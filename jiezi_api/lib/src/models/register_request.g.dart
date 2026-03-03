// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      emailOtp: json['email_otp'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'email': instance.email,
      'email_otp': instance.emailOtp,
      'password': instance.password,
      'username': instance.username,
    };
