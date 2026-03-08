/// Named route paths used across the application.
///
/// Using constants prevents hard-coded strings scattered across widgets.
abstract final class Routes {
  /// Splash / loading screen shown while the app resolves its initial state.
  ///
  /// This is the [GoRouter.initialLocation].  The redirect guard immediately
  /// forwards users to [setup], [login], or [dashboard] once async providers
  /// are ready, so this page is only visible for a brief moment.
  static const splash = '/';

  /// First-run setup wizard shown when the server has not been configured yet.
  static const setup = '/setup';

  /// Login page.
  static const login = '/login';

  /// Registration page for new accounts.
  static const register = '/register';

  /// Root of the authenticated admin dashboard.
  static const dashboard = '/dashboard';
}
