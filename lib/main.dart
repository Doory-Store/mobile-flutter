import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/auth/auth_providers.dart';
import 'core/auth/credential_vault.dart';
import 'core/config/app_config.dart';
import 'data/favorites/favorites_controller.dart';
import 'features/auth/session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  // Sessions from earlier builds sat in shared_preferences; credentials now
  // live only in secure storage.
  await preferences.remove(SessionController.legacyStorageKey);

  final config = AppConfig.fromEnvironment();
  final vault = CredentialVault(SecureTokenStore());
  await vault.load(sample: config.authMode == AuthMode.mock);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        credentialVaultProvider.overrideWithValue(vault),
      ],
      child: const DooryApp(),
    ),
  );
}
