// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_own_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeOwnPasswordRequest _$ChangeOwnPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangeOwnPasswordRequest(
  newPassword: json['new_password'] as String,
  oldPassword: json['old_password'] as String,
  emailOtp: json['email_otp'] as String?,
);

Map<String, dynamic> _$ChangeOwnPasswordRequestToJson(
  ChangeOwnPasswordRequest instance,
) => <String, dynamic>{
  'email_otp': instance.emailOtp,
  'new_password': instance.newPassword,
  'old_password': instance.oldPassword,
};
