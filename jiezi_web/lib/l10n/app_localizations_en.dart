// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Jiezi Cloud';

  @override
  String get adminConsoleTitle => 'Admin Console';

  @override
  String get setupTitle => 'Jiezi Cloud Setup';

  @override
  String get setupSubtitle => 'Configure your server before you start';

  @override
  String get setupOnceNote =>
      'This page is only accessible once. After setup, it will no longer be available.';

  @override
  String get setupCompleteMessage => 'Setup complete! Redirecting…';

  @override
  String get siteSettingsTitle => 'Site Settings';

  @override
  String get siteNameLabel => 'Site Name';

  @override
  String get siteNameHint => 'e.g. Jiezi Cloud';

  @override
  String get siteDescriptionLabel => 'Site Description';

  @override
  String get siteDescriptionHint => 'Optional tagline';

  @override
  String get adminAccountTitle => 'Super-Admin Account';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'admin';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameFormat => '3–50 chars: letters, numbers, _ or -';

  @override
  String get displayNameLabel => 'Nickname';

  @override
  String get displayNameHint => 'System Administrator';

  @override
  String get displayNameHelper =>
      'Shown in the UI; different from your login username';

  @override
  String get displayNameTooltip =>
      'Optional. The name shown throughout the UI — used wherever your identity is displayed. If left blank it defaults to your username.';

  @override
  String get usernameTooltip =>
      'This is your login credential — you will use it to sign in. 3–50 characters. Allowed: letters (a-z, A-Z), digits (0-9), underscore (_), hyphen (-). Cannot be changed after setup.';

  @override
  String get passwordTooltip =>
      'Minimum 8 characters. Use a mix of letters, numbers and symbols for a stronger password.';

  @override
  String get adminAccountNote =>
      'You are creating the super-admin account. This account has full control over the server and cannot be deleted.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'admin@example.com';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Minimum 8 characters';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get advancedOptionsTitle => 'Advanced Options';

  @override
  String get maxUploadLabel => 'Max Upload Size (MB)';

  @override
  String get publicRegistrationLabel => 'Public Registration';

  @override
  String get publicRegistrationSubtitle =>
      'Allow visitors to create their own accounts';

  @override
  String get completeSetupButton => 'Complete Setup';

  @override
  String get usernameOrEmail => 'Username or Email';

  @override
  String get fieldRequired => 'Required';

  @override
  String get signInButton => 'Sign In';

  @override
  String get cannotReachServer => 'Cannot reach server';

  @override
  String get retryButton => 'Retry';

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  @override
  String get stepSiteLabel => 'Site';

  @override
  String get stepAccountLabel => 'Account';

  @override
  String get stepAdvancedLabel => 'Advanced';
}
