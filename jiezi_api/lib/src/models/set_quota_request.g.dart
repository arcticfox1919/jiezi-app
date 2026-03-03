// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_quota_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetQuotaRequest _$SetQuotaRequestFromJson(Map<String, dynamic> json) =>
    SetQuotaRequest(storageQuota: (json['storage_quota'] as num?)?.toInt());

Map<String, dynamic> _$SetQuotaRequestToJson(SetQuotaRequest instance) =>
    <String, dynamic>{'storage_quota': instance.storageQuota};
