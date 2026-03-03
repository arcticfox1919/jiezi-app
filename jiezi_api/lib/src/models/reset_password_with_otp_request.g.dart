// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_with_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordWithOtpRequest _$ResetPasswordWithOtpRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordWithOtpRequest(
  code: json['code'] as String,
  email: json['email'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$ResetPasswordWithOtpRequestToJson(
  ResetPasswordWithOtpRequest instance,
) => <String, dynamic>{
  'code': instance.code,
  'email': instance.email,
  'new_password': instance.newPassword,
};
