// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';

import 'package:gio/gio.dart';

import '../models/setup_complete_request.dart';
import '../models/setup_complete_response.dart';
import '../models/setup_status_response.dart';

/// SetupClient
class SetupClient {
  /// Creates a [SetupClient] using the provided [gio] instance.
  ///
  /// [baseUrl] overrides any base URL already configured on the
  /// [Gio] instance for this client only.
  SetupClient(Gio gio, {String? baseUrl})
      : _gio = gio,
        _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  /// `POST /api/v1/setup/complete`.
  ///
  /// Performs the first-run setup:.
  /// 1. Validates the request body.
  /// 2. Creates the Owner account via [`AuthService::bootstrap_owner`].
  /// 3. Persists site settings to the `system_settings` table.
  /// 4. Marks setup as complete (DB + in-memory atomic flag).
  ///
  /// Returns `409 Conflict` if setup has already been completed.
  Future<SetupCompleteResponse> complete({
    required SetupCompleteRequest body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/setup/complete',
      jsonBody: body.toJson(),
    );
    return SetupCompleteResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `GET /api/v1/setup/status`.
  ///
  /// Returns whether the server still needs to be configured.
  /// Safe to call anonymously; returns no sensitive information.
  Future<SetupStatusResponse> status() async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/setup/status',
    );
    return SetupStatusResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
