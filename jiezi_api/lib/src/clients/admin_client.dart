// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';

import 'package:gio/gio.dart';

import '../models/admin_reset_password_request.dart';
import '../models/change_role_request.dart';
import '../models/set_active_request.dart';
import '../models/set_quota_request.dart';
import '../models/user.dart';

/// AdminClient
class AdminClient {
  /// Creates a [AdminClient] using the provided [gio] instance.
  ///
  /// [baseUrl] overrides any base URL already configured on the
  /// [Gio] instance for this client only.
  AdminClient(Gio gio, {String? baseUrl})
      : _gio = gio,
        _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  /// `GET /admin/users?page=1&per_page=20`.
  ///
  /// Returns a paginated list of all users.
  /// Requires `Admin` or `Owner`.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Items per page.
  Future<List<User>> listUsers({
    int? page,
    int? perPage,
  }) async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/admin/users',
      queryParameters: {
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
      },
    );
    return (jsonDecode(response.body) as List)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `GET /admin/users/{id}`.
  ///
  /// Returns the full user record for the given ID.
  /// Requires `Admin` or `Owner`.
  ///
  /// [id] - User ID.
  Future<User> getUser({
    required String id,
  }) async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/admin/users/${id}',
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `DELETE /admin/users/{id}`.
  ///
  /// Permanently delete a user account and revoke all their sessions.
  /// Requires `Owner`.  Cannot delete the last owner account.
  ///
  /// [id] - User ID.
  Future<void> deleteUser({
    required String id,
  }) async {
    await _gio.delete(
      '${_baseUrl ?? ''}/api/v1/admin/users/${id}',
    );
  }

  /// `PATCH /admin/users/{id}/quota`.
  ///
  /// Set or clear a user's storage quota.
  /// Requires `Owner` (only the owner controls quotas).
  ///
  /// [id] - User ID.
  Future<void> setQuota({
    required String id,
    required SetQuotaRequest body,
  }) async {
    await _gio.patch(
      '${_baseUrl ?? ''}/api/v1/admin/users/${id}/quota',
      jsonBody: body.toJson(),
    );
  }

  /// `POST /admin/users/{id}/reset-password`.
  ///
  /// Force-reset a user's password without knowing their current one.
  /// Requires `Admin` or `Owner`.
  ///
  /// [id] - User ID.
  Future<void> resetPassword({
    required String id,
    required AdminResetPasswordRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/admin/users/${id}/reset-password',
      jsonBody: body.toJson(),
    );
  }

  /// `PATCH /admin/users/{id}/role`.
  ///
  /// Change the system-level role of a user.
  ///
  /// Authorization rules (enforced by the service layer):.
  /// - Owner may grant any role.
  /// - Admin may only promote/demote between `Member` and `Guest`.
  /// - Nobody may change their own role.
  ///
  /// [id] - User ID.
  Future<User> changeRole({
    required String id,
    required ChangeRoleRequest body,
  }) async {
    final response = await _gio.patch(
      '${_baseUrl ?? ''}/api/v1/admin/users/${id}/role',
      jsonBody: body.toJson(),
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `PATCH /admin/users/{id}/status`.
  ///
  /// Suspend (`is_active: false`) or reactivate (`is_active: true`) a user.
  /// Admin cannot suspend an Owner.
  ///
  /// [id] - User ID.
  Future<void> setStatus({
    required String id,
    required SetActiveRequest body,
  }) async {
    await _gio.patch(
      '${_baseUrl ?? ''}/api/v1/admin/users/${id}/status',
      jsonBody: body.toJson(),
    );
  }
}
