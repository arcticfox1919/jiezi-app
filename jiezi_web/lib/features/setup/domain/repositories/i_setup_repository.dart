import '../models/setup_form_data.dart';
import '../models/setup_status.dart';

/// Contract that the setup data layer must fulfil.
///
/// By depending on this interface the presentation layer is fully decoupled
/// from the HTTP transport and can be tested with an in-memory fake.
abstract interface class ISetupRepository {
  /// Fetches whether the server still requires first-run configuration.
  Future<SetupStatus> checkStatus();

  /// Submits the first-run setup form.
  ///
  /// Throws an [AppError] subclass on failure (network / server error).
  Future<void> completeSetup(SetupFormData data);
}
