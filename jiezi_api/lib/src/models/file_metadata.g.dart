// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMetadata _$FileMetadataFromJson(Map<String, dynamic> json) => FileMetadata(
  extra: json['extra'] as Map<String, dynamic>?,
  hasThumbnail: json['has_thumbnail'] as bool?,
  isIndexed: json['is_indexed'] as bool?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$FileMetadataToJson(FileMetadata instance) =>
    <String, dynamic>{
      'extra': instance.extra,
      'has_thumbnail': instance.hasThumbnail,
      'is_indexed': instance.isIndexed,
      'tags': instance.tags,
    };
