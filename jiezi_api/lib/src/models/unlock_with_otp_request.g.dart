// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlock_with_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnlockWithOtpRequest _$UnlockWithOtpRequestFromJson(
  Map<String, dynamic> json,
) => UnlockWithOtpRequest(
  code: json['code'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UnlockWithOtpRequestToJson(
  UnlockWithOtpRequest instance,
) => <String, dynamic>{'code': instance.code, 'email': instance.email};
