import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiezi_web/l10n/app_localizations.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../files/presentation/widgets/file_browser.dart';
import '../../../files/presentation/widgets/trash_browser.dart';
import 'profile_page.dart';

/// Root dashboard shell with [NavigationRail] sidebar.
///
/// The two top-level destinations are:
/// - 0 — Files   → [FileBrowser]
/// - 1 — Trash   → [TrashBrowser]
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authAsync = ref.watch(authStateProvider);

    final destinations = [
      NavigationRailDestination(
        icon: const Icon(Icons.folder_outlined),
        selectedIcon: const Icon(Icons.folder),
        label: Text(l10n.filesNav),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.delete_outline),
        selectedIcon: const Icon(Icons.delete),
        label: Text(l10n.trashNav),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(l10n.profileNav),
      ),
    ];

    final username = authAsync.asData?.value.user?.username ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jiezi Cloud'),
        actions: [
          if (username.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(child: Text(username)),
            ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            labelType: NavigationRailLabelType.all,
            destinations: destinations,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [FileBrowser(), TrashBrowser(), ProfilePage()],
            ),
          ),
        ],
      ),
    );
  }
}
