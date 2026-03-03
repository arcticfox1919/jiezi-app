// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_directory_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDirectoryBody _$CreateDirectoryBodyFromJson(Map<String, dynamic> json) =>
    CreateDirectoryBody(
      name: json['name'] as String,
      parentId: json['parent_id'] as String,
    );

Map<String, dynamic> _$CreateDirectoryBodyToJson(
  CreateDirectoryBody instance,
) => <String, dynamic>{'name': instance.name, 'parent_id': instance.parentId};
