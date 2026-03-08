import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/setup/presentation/pages/setup_page.dart';
import '../../features/setup/presentation/providers/setup_providers.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

part 'app_router.g.dart';

// ────────────────────────────────────────────────────────────────────────────
// Router notifier
// ────────────────────────────────────────────────────────────────────────────

/// Bridges Riverpod state changes into go_router refreshes.
///
/// Implements [Listenable] so that [GoRouter.refreshListenable] can drive
/// redirects whenever auth or setup state changes.
@Riverpod(keepAlive: true)
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;

  @override
  void build() {
    // Watch both setup and auth providers so any state change triggers a
    // router refresh (redirect re-evaluation).
    ref.listen(setupStatusProvider, (_, _) => _routerListener?.call());
    ref.listen(authStateProvider, (_, _) => _routerListener?.call());
  }

  // ── Listenable ────────────────────────────────────────────────────────────

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) {
    if (_routerListener == listener) _routerListener = null;
  }

  // ── Redirect logic ────────────────────────────────────────────────────────

  /// Called by go_router on every navigation event when [GoRouter.redirect] is
  /// wired to this notifier.
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final setupAsync = ref.read(setupStatusProvider);
    final authAsync = ref.read(authStateProvider);

    final onSplash = state.matchedLocation == Routes.splash;

    // ── Still loading: hold the user on the splash screen ─────────────────
    if (setupAsync.isLoading || authAsync.isLoading) {
      return onSplash ? null : Routes.splash;
    }

    // ── Setup status error: stay on splash and let the user retry ──────────
    if (setupAsync.hasError) {
      return onSplash ? null : Routes.splash;
    }

    final setupRequired = setupAsync.value?.setupRequired ?? false;

    // ── Setup guard ───────────────────────────────────────────────────────
    if (setupRequired) {
      return state.matchedLocation == Routes.setup ? null : Routes.setup;
    }

    // ── Auth guard ────────────────────────────────────────────────────────
    final isLoggedIn = authAsync.value?.isLoggedIn ?? false;

    final onAuthPage = state.matchedLocation == Routes.login;
    final onRegisterPage = state.matchedLocation == Routes.register;

    if (!isLoggedIn) {
      return (onAuthPage || onRegisterPage) ? null : Routes.login;
    } else if (onSplash ||
        onAuthPage ||
        onRegisterPage ||
        state.matchedLocation == Routes.setup) {
      return Routes.dashboard;
    }

    return null; // No redirect needed.
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Router provider
// ────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final notifier = ref.watch(routerProvider.notifier);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.setup,
        name: 'setup',
        builder: (_, _) => const SetupPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (_, _) => const RegisterPage(),
      ),
      GoRoute(
        path: Routes.dashboard,
        name: 'dashboard',
        builder: (_, _) => const DashboardPage(),
      ),
    ],
  );
}
