import 'package:jiezi_api/jiezi_api.dart';

/// Represents the current authentication state of the application.
class AuthState {
  const AuthState._({
    required this.isLoggedIn,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  /// Unauthenticated (no valid session).
  const AuthState.unauthenticated() : this._(isLoggedIn: false);

  /// Authenticated with a [TokenPair] and the current [User] profile.
  const AuthState.authenticated({
    required User user,
    required String accessToken,
    required String refreshToken,
  }) : this._(
         isLoggedIn: true,
         user: user,
         accessToken: accessToken,
         refreshToken: refreshToken,
       );

  final bool isLoggedIn;

  /// Non-null when [isLoggedIn] is `true`.
  final User? user;

  /// Non-null when [isLoggedIn] is `true`.
  final String? accessToken;

  /// Non-null when [isLoggedIn] is `true`.
  final String? refreshToken;
}
