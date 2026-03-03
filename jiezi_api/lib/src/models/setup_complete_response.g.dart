// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_complete_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetupCompleteResponse _$SetupCompleteResponseFromJson(
  Map<String, dynamic> json,
) => SetupCompleteResponse(
  message: json['message'] as String,
  success: json['success'] as bool,
);

Map<String, dynamic> _$SetupCompleteResponseToJson(
  SetupCompleteResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'success': instance.success,
};
