// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  createdAt: DateTime.parse(json['created_at'] as String),
  email: json['email'] as String,
  emailVerified: json['email_verified'] as bool,
  id: json['id'] as String,
  isActive: json['is_active'] as bool,
  role: Role.fromJson(json['role'] as String),
  storageUsed: (json['storage_used'] as num).toInt(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  username: json['username'] as String,
  avatarUrl: json['avatar_url'] as String?,
  displayName: json['display_name'] as String?,
  storageQuota: (json['storage_quota'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'avatar_url': instance.avatarUrl,
  'created_at': instance.createdAt.toIso8601String(),
  'display_name': instance.displayName,
  'email': instance.email,
  'email_verified': instance.emailVerified,
  'id': instance.id,
  'is_active': instance.isActive,
  'role': _$RoleEnumMap[instance.role]!,
  'storage_quota': instance.storageQuota,
  'storage_used': instance.storageUsed,
  'updated_at': instance.updatedAt.toIso8601String(),
  'username': instance.username,
};

const _$RoleEnumMap = {
  Role.owner: 'owner',
  Role.admin: 'admin',
  Role.member: 'member',
  Role.guest: 'guest',
  Role.$unknown: r'$unknown',
};
