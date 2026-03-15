// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetupStatusResponse _$SetupStatusResponseFromJson(Map<String, dynamic> json) =>
    SetupStatusResponse(
      setupRequired: json['setup_required'] as bool,
      version: json['version'] as String,
      registrationEnabled: json['registration_enabled'] as bool? ?? false,
    );

Map<String, dynamic> _$SetupStatusResponseToJson(
  SetupStatusResponse instance,
) => <String, dynamic>{
  'setup_required': instance.setupRequired,
  'version': instance.version,
  'registration_enabled': instance.registrationEnabled,
};
