import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/di/core_providers.dart';
import 'core/storage/hive_kv_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive.  On Web this configures IndexedDB; on native it uses
  // the app-documents directory via path_provider (bundled with hive_flutter).
  await Hive.initFlutter();

  // Pre-open all boxes at startup so their providers resolve synchronously
  // and the first frame never shows a loading state for persistent data.
  final authBox = await HiveKvStore.open(HiveBoxNames.auth);

  runApp(
    ProviderScope(
      overrides: [
        // Inject the pre-opened box so [authBoxProvider] resolves synchronously.
        // This is the only place aware of the concrete Hive backend; all other
        // layers depend only on [KvStore] / [TokenStore].
        authBoxProvider.overrideWith((_) async => authBox),
      ],
      child: const App(),
    ),
  );
}
