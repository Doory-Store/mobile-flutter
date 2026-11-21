import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/auth/credential_vault.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../../data/repositories/commerce/commerce_providers.dart';

export '../../core/format/syrian_phone.dart'
    show formatPhone, normalizeSyrianMobile;

class SessionState {
  const SessionState({this.user, this.sample = true, this.expired = false});

  final BuyerUser? user;
  final bool sample;

  /// The server revoked the token (401). The sign-in screen explains why.
  final bool expired;

  bool get signedIn => user != null;
}

/// The signed-in buyer. The token and profile live in [CredentialVault]
/// (secure storage); this notifier mirrors them for the UI.
class SessionController extends Notifier<SessionState> {
  /// Where builds before secure storage kept the demo session. `main()`
  /// deletes it on start.
  static const legacyStorageKey = 'doory.mock.session.v1';

  CredentialVault get _vault => ref.read(credentialVaultProvider);

  @override
  SessionState build() {
    final sample = ref.watch(authRepositoryProvider).isSample;
    ref.listen<int>(sessionRevokedProvider, (previous, next) {
      if (next != previous) _expire();
    });
    final stored = ref.watch(credentialVaultProvider).current;
    if (stored == null || stored.sample != sample) {
      return SessionState(sample: sample);
    }
    return SessionState(user: stored.user, sample: sample);
  }

  Future<void> signIn(BuyerSession session) async {
    await _vault.save(
      StoredSession(
        token: session.token,
        user: session.user,
        sample: state.sample,
      ),
    );
    state = SessionState(user: session.user, sample: state.sample);
  }

  /// Pulls the profile from `GET /me`. A revoked token surfaces as a 401,
  /// which the auth interceptor turns into a sign-out.
  Future<void> refreshProfile() async {
    if (!state.signedIn) return;
    try {
      final user = await ref.read(authRepositoryProvider).me();
      if (!state.signedIn) return;
      await _vault.updateUser(user);
      state = SessionState(user: user, sample: state.sample);
    } on DomainRejection {
      // Offline or throttled: keep the stored profile.
    }
  }

  Future<void> updateName(String name) async {
    final user = await ref.read(authRepositoryProvider).updateName(name);
    final current = state.user;
    final next = current == null
        ? user
        : BuyerUser(
            id: user.id == 0 ? current.id : user.id,
            phone: user.phone.isEmpty ? current.phone : user.phone,
            name: user.name,
          );
    await _vault.updateUser(next);
    state = SessionState(user: next, sample: state.sample);
  }

  /// Revokes the token on the server, then wipes it from the device. The
  /// local wipe happens even when the server cannot be reached.
  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // The device forgets the token regardless.
    } finally {
      await _vault.clear();
      state = SessionState(sample: state.sample);
    }
  }

  void _expire() {
    _vault.clear();
    if (state.signedIn) {
      state = SessionState(sample: state.sample, expired: true);
    }
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);
