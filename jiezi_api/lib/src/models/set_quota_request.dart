// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'set_quota_request.g.dart';

/// Payload for `PATCH /admin/users/{id}/quota` — set storage quota.
@JsonSerializable()
class SetQuotaRequest {
  const SetQuotaRequest({
    this.storageQuota,
  });
  
  factory SetQuotaRequest.fromJson(Map<String, Object?> json) => _$SetQuotaRequestFromJson(json);
  
  /// Storage maximum in bytes.  `null` means unlimited.
  @JsonKey(name: 'storage_quota')
  final int? storageQuota;

  Map<String, Object?> toJson() => _$SetQuotaRequestToJson(this);
}
