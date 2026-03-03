/// Domain-level representation of the server's setup state.
///
/// Mirrors [SetupStatusResponse] from the API layer but lives in the domain
/// so that nothing above the repository boundary depends on jiezi_api.
class SetupStatus {
  const SetupStatus({required this.setupRequired, required this.serverVersion});

  /// When `true` the server has not been initialised and the setup wizard
  /// must be completed before the app can be used.
  final bool setupRequired;

  /// Server version string, e.g. `"0.1.0"`.
  final String serverVersion;

  @override
  String toString() => 'SetupStatus(required=$setupRequired, v=$serverVersion)';
}
