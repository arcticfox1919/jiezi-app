// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_role_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeRoleRequest _$ChangeRoleRequestFromJson(Map<String, dynamic> json) =>
    ChangeRoleRequest(newRole: Role.fromJson(json['new_role'] as String));

Map<String, dynamic> _$ChangeRoleRequestToJson(ChangeRoleRequest instance) =>
    <String, dynamic>{'new_role': _$RoleEnumMap[instance.newRole]!};

const _$RoleEnumMap = {
  Role.owner: 'owner',
  Role.admin: 'admin',
  Role.member: 'member',
  Role.guest: 'guest',
  Role.$unknown: r'$unknown',
};
