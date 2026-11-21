import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'credential_vault.dart';

/// The buyer credential. `main()` overrides this with a vault backed by
/// [SecureTokenStore] and already loaded; the default keeps everything in
/// memory, which is what tests want.
final credentialVaultProvider = Provider<CredentialVault>(
  (ref) => CredentialVault(MemoryTokenStore()),
);

/// Bumped by the auth interceptor when the API answers 401 to a request that
/// carried the token. The session listens and signs the buyer out.
final sessionRevokedProvider = StateProvider<int>((ref) => 0);
