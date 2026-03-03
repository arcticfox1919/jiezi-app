import 'package:jiezi_api/jiezi_api.dart';

import '../../../core/error/app_error.dart';
import '../domain/models/setup_form_data.dart';
import '../domain/models/setup_status.dart';
import '../domain/repositories/i_setup_repository.dart';

/// [ISetupRepository] implementation that delegates to [SetupClient].
class SetupRepositoryImpl implements ISetupRepository {
  const SetupRepositoryImpl(this._client);

  final SetupClient _client;

  @override
  Future<SetupStatus> checkStatus() async {
    try {
      final response = await _client.status();
      return SetupStatus(
        setupRequired: response.setupRequired,
        serverVersion: response.version,
      );
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> completeSetup(SetupFormData data) async {
    try {
      await _client.complete(
        body: SetupCompleteRequest(
          siteName: data.siteName,
          siteDescription: data.siteDescription,
          adminUsername: data.adminUsername,
          adminEmail: data.adminEmail,
          adminPassword: data.adminPassword,
          adminDisplayName: data.adminDisplayName,
          registrationEnabled: data.registrationEnabled,
          maxUploadSizeMb: data.maxUploadSizeMb,
        ),
      );
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Converts a raw exception from the HTTP layer into an [AppError] variant.
  AppError _mapException(Exception e) {
    final msg = e.toString();

    // gio throws an exception whose message contains the status code.
    final codeMatch = RegExp(r'(\d{3})').firstMatch(msg);
    if (codeMatch != null) {
      final code = int.tryParse(codeMatch.group(1) ?? '') ?? 0;
      return ServerError(statusCode: code, message: _friendlyMessage(code));
    }

    if (msg.toLowerCase().contains('socket') ||
        msg.toLowerCase().contains('connection')) {
      return const NetworkError();
    }

    return UnknownError(message: msg);
  }

  String _friendlyMessage(int statusCode) => switch (statusCode) {
    400 => 'Invalid request — please check your input.',
    409 => 'Setup has already been completed.',
    500 => 'Server error — please try again later.',
    _ => 'Request failed with status $statusCode.',
  };
}
