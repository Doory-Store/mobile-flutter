import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites/favorites_controller.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_providers.dart';

class SessionState {
  const SessionState({this.user, this.sample = true});

  final BuyerUser? user;
  final bool sample;

  bool get signedIn => user != null;
}

/// The signed-in buyer. With the sample auth repository the session is a
/// labelled demo session kept on the device.
class SessionController extends Notifier<SessionState> {
  static const storageKey = 'doory.mock.session.v1';

  @override
  SessionState build() {
    final sample = ref.watch(authRepositoryProvider).isSample;
    final raw = ref.watch(sharedPreferencesProvider).getString(storageKey);
    if (raw == null) return SessionState(sample: sample);
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return SessionState(
          user: BuyerUser.fromJson(Map<String, dynamic>.from(decoded)),
          sample: sample,
        );
      }
    } catch (_) {}
    return SessionState(sample: sample);
  }

  Future<void> signIn(BuyerSession session) async {
    state = SessionState(user: session.user, sample: state.sample);
    await _persist();
  }

  Future<void> updateName(String name) async {
    final user = await ref.read(authRepositoryProvider).updateName(name);
    final current = state.user;
    state = SessionState(
      user: current == null ? user : current.copyWith(name: user.name),
      sample: state.sample,
    );
    await _persist();
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).logout();
    state = SessionState(sample: state.sample);
    await ref.read(sharedPreferencesProvider).remove(storageKey);
  }

  Future<void> _persist() async {
    final user = state.user;
    if (user == null) return;
    await ref
        .read(sharedPreferencesProvider)
        .setString(storageKey, jsonEncode(user.toJson()));
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

/// Syrian mobile numbers: 09XXXXXXXX, 9XXXXXXXX, or +9639XXXXXXXX.
/// Returns the E.164 form (+9639…) or null when the input is not a mobile.
String? normalizeSyrianMobile(String input) {
  final digits = input.replaceAll(RegExp(r'[\s\-()]'), '');
  final western = digits.replaceAllMapped(
    RegExp('[٠-٩]'),
    (match) => '${match.group(0)!.codeUnitAt(0) - 0x0660}',
  );
  final patterns = <RegExp, int>{
    RegExp(r'^\+9639\d{8}$'): 4,
    RegExp(r'^009639\d{8}$'): 5,
    RegExp(r'^9639\d{8}$'): 3,
    RegExp(r'^09\d{8}$'): 1,
    RegExp(r'^9\d{8}$'): 0,
  };
  for (final entry in patterns.entries) {
    if (entry.key.hasMatch(western)) {
      return '+963${western.substring(entry.value)}';
    }
  }
  return null;
}

/// «+963 944 111 222» for display.
String formatPhone(String e164) {
  if (!e164.startsWith('+963') || e164.length != 13) return e164;
  final rest = e164.substring(4);
  return '\u2066+963 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6)}\u2069';
}
