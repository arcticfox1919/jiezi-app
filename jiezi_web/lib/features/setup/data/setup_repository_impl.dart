import 'package:jiezi_api/jiezi_api.dart';

import '../../../core/error/api_response_exception.dart';
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
        registrationEnabled: response.registrationEnabled,
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
    if (e is ApiResponseException) {
      return ServerError(
        statusCode: e.statusCode,
        errorCode: e.errorCode,
        message: e.message,
      );
    }
    final msg = e.toString();
    if (msg.toLowerCase().contains('socket') ||
        msg.toLowerCase().contains('connection refused') ||
        msg.toLowerCase().contains('network is unreachable')) {
      return const NetworkError();
    }
    return UnknownError(message: msg);
  }
}
