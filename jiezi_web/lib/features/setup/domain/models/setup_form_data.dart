/// Immutable value object that carries the data the user fills in during the
/// first-run setup wizard.
///
/// Intentionally kept separate from [SetupCompleteRequest] (the wire type)
/// so that the domain layer stays independent of the jiezi_api package.
class SetupFormData {
  const SetupFormData({
    required this.siteName,
    required this.adminUsername,
    required this.adminEmail,
    required this.adminPassword,
    this.siteDescription,
    this.adminDisplayName,
    this.registrationEnabled = false,
    this.maxUploadSizeMb,
  });

  final String siteName;
  final String? siteDescription;
  final String adminUsername;
  final String adminEmail;
  final String adminPassword;
  final String? adminDisplayName;
  final bool registrationEnabled;
  final int? maxUploadSizeMb;

  @override
  String toString() => 'SetupFormData(site=$siteName, admin=$adminUsername)';
}
