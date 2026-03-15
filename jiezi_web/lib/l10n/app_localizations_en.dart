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
  String get displayNameLabel => 'Display Name';

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
  String get emailTooltip =>
      'Used for account recovery and (when enabled) email verification. Never shared publicly.';

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

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerButton => 'Create Account';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get registerLink => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signInLink => 'Sign in';

  @override
  String get otpLabel => 'Verification Code';

  @override
  String get otpHint => '6-digit code';

  @override
  String get sendCodeButton => 'Send Code';

  @override
  String get codeSentMessage =>
      'A verification code has been sent to your email.';

  @override
  String get otpRequiredMessage =>
      'Email verification is required. Enter the code sent to your inbox.';

  @override
  String get registrationDisabledError =>
      'Registration is currently disabled by the administrator.';

  @override
  String get accountExistsError =>
      'An account with this username or email already exists.';

  @override
  String get registerSuccessMessage => 'Account created! Signing you in…';

  @override
  String get filesNav => 'Files';

  @override
  String get trashNav => 'Trash';

  @override
  String get newFolderTitle => 'New Folder';

  @override
  String get folderNameLabel => 'Folder name';

  @override
  String get renameTitle => 'Rename';

  @override
  String get newNameLabel => 'New name';

  @override
  String get deleteAction => 'Delete';

  @override
  String get restoreAction => 'Restore';

  @override
  String get deleteForeverAction => 'Delete Forever';

  @override
  String get uploadAction => 'Upload';

  @override
  String get dropFilesHint => 'Drop files here to upload';

  @override
  String get downloadAction => 'Download';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get createButton => 'Create';

  @override
  String get renameButton => 'Rename';

  @override
  String get deleteConfirmTitle => 'Move to Trash?';

  @override
  String get deleteConfirmBody => 'You can restore this item from the Trash.';

  @override
  String get permanentDeleteConfirmTitle => 'Delete Forever?';

  @override
  String get permanentDeleteConfirmBody => 'This action cannot be undone.';

  @override
  String get emptyFolderMessage => 'This folder is empty.';

  @override
  String get emptyTrashMessage => 'Trash is empty.';

  @override
  String get profileNav => 'Profile';

  @override
  String get storageTitle => 'Storage';

  @override
  String storageUsedOf(String used, String total) {
    return '$used of $total';
  }

  @override
  String storageUsedNoQuota(String used) {
    return '$used used';
  }

  @override
  String get accountTitle => 'Account';

  @override
  String get roleLabel => 'Role';

  @override
  String get joinedLabel => 'Joined';

  @override
  String get maxUploadSubtitle =>
      'Web browser only — native client has no size restriction';
}
