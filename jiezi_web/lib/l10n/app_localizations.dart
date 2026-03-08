import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Jiezi Cloud'**
  String get appName;

  /// No description provided for @adminConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Console'**
  String get adminConsoleTitle;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Jiezi Cloud Setup'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure your server before you start'**
  String get setupSubtitle;

  /// No description provided for @setupOnceNote.
  ///
  /// In en, this message translates to:
  /// **'This page is only accessible once. After setup, it will no longer be available.'**
  String get setupOnceNote;

  /// No description provided for @setupCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Setup complete! Redirecting…'**
  String get setupCompleteMessage;

  /// No description provided for @siteSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Settings'**
  String get siteSettingsTitle;

  /// No description provided for @siteNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Site Name'**
  String get siteNameLabel;

  /// No description provided for @siteNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Jiezi Cloud'**
  String get siteNameHint;

  /// No description provided for @siteDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Site Description'**
  String get siteDescriptionLabel;

  /// No description provided for @siteDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional tagline'**
  String get siteDescriptionHint;

  /// No description provided for @adminAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Super-Admin Account'**
  String get adminAccountTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get usernameHint;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameFormat.
  ///
  /// In en, this message translates to:
  /// **'3–50 chars: letters, numbers, _ or -'**
  String get usernameFormat;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get displayNameLabel;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'System Administrator'**
  String get displayNameHint;

  /// No description provided for @displayNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Shown in the UI; different from your login username'**
  String get displayNameHelper;

  /// No description provided for @displayNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Optional. The name shown throughout the UI — used wherever your identity is displayed. If left blank it defaults to your username.'**
  String get displayNameTooltip;

  /// No description provided for @usernameTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is your login credential — you will use it to sign in. 3–50 characters. Allowed: letters (a-z, A-Z), digits (0-9), underscore (_), hyphen (-). Cannot be changed after setup.'**
  String get usernameTooltip;

  /// No description provided for @passwordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters. Use a mix of letters, numbers and symbols for a stronger password.'**
  String get passwordTooltip;

  /// No description provided for @adminAccountNote.
  ///
  /// In en, this message translates to:
  /// **'You are creating the super-admin account. This account has full control over the server and cannot be deleted.'**
  String get adminAccountNote;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'admin@example.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordHint;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @advancedOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Options'**
  String get advancedOptionsTitle;

  /// No description provided for @maxUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Upload Size (MB)'**
  String get maxUploadLabel;

  /// No description provided for @publicRegistrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Public Registration'**
  String get publicRegistrationLabel;

  /// No description provided for @publicRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow visitors to create their own accounts'**
  String get publicRegistrationSubtitle;

  /// No description provided for @completeSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetupButton;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmail;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @cannotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach server'**
  String get cannotReachServer;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @stepSiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get stepSiteLabel;

  /// No description provided for @stepAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get stepAccountLabel;

  /// No description provided for @stepAdvancedLabel.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get stepAdvancedLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
