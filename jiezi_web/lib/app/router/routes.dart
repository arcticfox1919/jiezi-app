/// Named route paths used across the application.
///
/// Using constants prevents hard-coded strings scattered across widgets.
abstract final class Routes {
  /// First-run setup wizard shown when the server has not been configured yet.
  static const setup = '/setup';

  /// Login page.
  static const login = '/login';

  /// Root of the authenticated admin dashboard.
  static const dashboard = '/dashboard';
}
