//! Compile-time environment constants injected via
//! `--dart-define-from-file=dart-defines.local.json` (development) or
//! `--dart-define=KEY=value` (CI / production builds).
//!
//! All [dart-define] keys are declared here and nowhere else.
//! Import this file wherever a compile-time constant is needed.

/// Root URL of the Jiezi Cloud API server (no trailing slash).
///
/// Example: `http://127.0.0.1:8080`
const String kApiBaseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: '');

/// Whether new-user registration requires email OTP verification.
///
/// When `true` the registration form shows the verification-code field
/// up-front so the user completes sign-up in a single submission.
/// Set to match the server-side `email.verification_required` config value.
const bool kEmailOtp = bool.fromEnvironment('EMAIL_OTP');
