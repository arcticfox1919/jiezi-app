// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';

import 'package:gio/gio.dart';

import '../models/change_own_password_request.dart';
import '../models/login_request.dart';
import '../models/logout_body.dart';
import '../models/refresh_body.dart';
import '../models/register_request.dart';
import '../models/reset_password_with_otp_request.dart';
import '../models/send_otp_request.dart';
import '../models/session_info.dart';
import '../models/token_pair.dart';
import '../models/unlock_with_otp_request.dart';
import '../models/update_profile_request.dart';
import '../models/user.dart';

/// AuthClient
class AuthClient {
  /// Creates a [AuthClient] using the provided [gio] instance.
  ///
  /// [baseUrl] overrides any base URL already configured on the
  /// [Gio] instance for this client only.
  AuthClient(Gio gio, {String? baseUrl})
      : _gio = gio,
        _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  /// `POST /auth/forgot-password` — email a password-reset OTP.
  ///
  /// Always returns `204 No Content` (even if the email is not registered).
  /// to prevent email enumeration.
  Future<void> forgotPassword({
    required SendOtpRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/forgot-password',
      jsonBody: body.toJson(),
    );
  }

  /// `POST /auth/login` — authenticate with credentials.
  ///
  /// Returns `200 OK` with a [`TokenPair`] on success.
  Future<TokenPair> login({
    required LoginRequest body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/login',
      jsonBody: body.toJson(),
    );
    return TokenPair.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `POST /auth/logout` — revoke a refresh token (log out a device).
  Future<void> logout({
    required LogoutBody body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/logout',
      jsonBody: body.toJson(),
    );
  }

  /// `GET /auth/me` — return the current user's full profile.
  Future<User> me() async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/auth/me',
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `PATCH /auth/me` — update the current user's display name and / or avatar.
  ///
  /// Only the fields present in the request body are updated.  Omit a field.
  /// entirely to leave it unchanged; set it to `null` to clear it.
  Future<User> updateMe({
    required UpdateProfileRequest body,
  }) async {
    final response = await _gio.patch(
      '${_baseUrl ?? ''}/api/v1/auth/me',
      jsonBody: body.toJson(),
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `POST /auth/me/password` — change the current user's own password.
  ///
  /// Requires the caller to supply their **current** password in `old_password`.
  /// For admin-initiated forced resets see `POST /admin/users/{id}/reset-password`.
  Future<void> changePassword({
    required ChangeOwnPasswordRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/me/password',
      jsonBody: body.toJson(),
    );
  }

  /// `POST /auth/me/send-change-password-otp` — send OTP to own email before changing password.
  ///
  /// No-op (204) when email verification is disabled in config.
  Future<void> sendChangePasswordOtp() async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/me/send-change-password-otp',
    );
  }

  /// `POST /auth/refresh` — exchange a refresh token for a new pair (rotation).
  Future<TokenPair> refresh({
    required RefreshBody body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/refresh',
      jsonBody: body.toJson(),
    );
    return TokenPair.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `POST /auth/register` — create a new account.
  ///
  /// Returns `201 Created` with the [`User`] object on success.
  Future<User> register({
    required RegisterRequest body,
  }) async {
    final response = await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/register',
      jsonBody: body.toJson(),
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// `POST /auth/reset-password` — set a new password using the OTP.
  ///
  /// Returns `204 No Content` on success.
  Future<void> resetPassword({
    required ResetPasswordWithOtpRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/reset-password',
      jsonBody: body.toJson(),
    );
  }

  /// `POST /auth/send-register-otp` — email a 6-digit code before registration.
  ///
  /// The client should call this before `POST /auth/register` when.
  /// `email.verification_required = true`.  Returns `204 No Content`.
  Future<void> sendRegisterOtp({
    required SendOtpRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/send-register-otp',
      jsonBody: body.toJson(),
    );
  }

  /// `POST /auth/send-unlock-otp` — email an unlock OTP for a locked account.
  ///
  /// Returns `204 No Content` always (prevents enumeration).
  Future<void> sendUnlockOtp({
    required SendOtpRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/send-unlock-otp',
      jsonBody: body.toJson(),
    );
  }

  /// `GET /auth/sessions` — list all active sessions for the current user.
  Future<List<SessionInfo>> listSessions() async {
    final response = await _gio.get(
      '${_baseUrl ?? ''}/api/v1/auth/sessions',
    );
    return (jsonDecode(response.body) as List)
        .map((e) => SessionInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `DELETE /auth/sessions/{family}` — revoke a single device session.
  ///
  /// [family] - Session family UUID to revoke.
  Future<void> revokeSession({
    required String family,
  }) async {
    await _gio.delete(
      '${_baseUrl ?? ''}/api/v1/auth/sessions/${family}',
    );
  }

  /// `POST /auth/unlock-account` — clear the lockout using the OTP.
  ///
  /// Returns `204 No Content` on success.
  Future<void> unlockAccount({
    required UnlockWithOtpRequest body,
  }) async {
    await _gio.post(
      '${_baseUrl ?? ''}/api/v1/auth/unlock-account',
      jsonBody: body.toJson(),
    );
  }
}
