// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_complete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetupCompleteRequest _$SetupCompleteRequestFromJson(
  Map<String, dynamic> json,
) => SetupCompleteRequest(
  adminEmail: json['admin_email'] as String,
  adminPassword: json['admin_password'] as String,
  adminUsername: json['admin_username'] as String,
  siteName: json['site_name'] as String,
  adminDisplayName: json['admin_display_name'] as String?,
  maxUploadSizeMb: (json['max_upload_size_mb'] as num?)?.toInt(),
  registrationEnabled: json['registration_enabled'] as bool?,
  siteDescription: json['site_description'] as String?,
);

Map<String, dynamic> _$SetupCompleteRequestToJson(
  SetupCompleteRequest instance,
) => <String, dynamic>{
  'admin_display_name': instance.adminDisplayName,
  'admin_email': instance.adminEmail,
  'admin_password': instance.adminPassword,
  'admin_username': instance.adminUsername,
  'max_upload_size_mb': instance.maxUploadSizeMb,
  'registration_enabled': instance.registrationEnabled,
  'site_description': instance.siteDescription,
  'site_name': instance.siteName,
};
