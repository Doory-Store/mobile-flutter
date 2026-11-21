import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/models/commerce_models.dart';

/// Key-value store for credentials. Production uses [SecureTokenStore];
/// tests and the offline demo use [MemoryTokenStore].
abstract interface class TokenStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Android Keystore (RSA-OAEP wrapped AES-GCM) and the iOS Keychain with
/// `first_unlock_this_device`: the token is readable after the first unlock
/// following a reboot, never leaves the device in a backup, and never
/// migrates to another phone.
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
            mOptions: MacOsOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class MemoryTokenStore implements TokenStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

/// A signed-in buyer as kept on the device.
class StoredSession {
  const StoredSession({
    required this.token,
    required this.user,
    required this.sample,
  });

  final String token;
  final BuyerUser user;

  /// True for the offline demo session; a demo token is never sent to the API.
  final bool sample;

  StoredSession withUser(BuyerUser next) =>
      StoredSession(token: token, user: next, sample: sample);

  @override
  String toString() => 'StoredSession(user: ${user.id}, sample: $sample)';
}

/// Owns the buyer credential: the bearer token plus the profile snapshot
/// (phone and name are personal data, so they live in secure storage too).
///
/// [load] runs once before the first frame; afterwards [current] is read
/// synchronously by the session and by the auth interceptor.
class CredentialVault {
  CredentialVault(this._store);

  static const tokenKey = 'doory.auth.token';
  static const userKey = 'doory.auth.user';
  static const modeKey = 'doory.auth.mode';

  final TokenStore _store;
  StoredSession? _current;

  StoredSession? get current => _current;

  /// Bearer token for the live API; null for guests and demo sessions.
  String? get liveToken {
    final session = _current;
    if (session == null || session.sample) return null;
    return session.token;
  }

  /// Reads the stored session. A session written by the other auth mode
  /// (demo vs live) or an unreadable one is wiped.
  Future<StoredSession?> load({required bool sample}) async {
    try {
      final token = await _store.read(tokenKey);
      final rawUser = await _store.read(userKey);
      final mode = await _store.read(modeKey);
      if (token == null || token.isEmpty || rawUser == null) {
        _current = null;
        return null;
      }
      final storedSample = mode == 'mock';
      if (storedSample != sample) {
        await clear();
        return null;
      }
      final decoded = jsonDecode(rawUser);
      if (decoded is! Map) {
        await clear();
        return null;
      }
      _current = StoredSession(
        token: token,
        user: BuyerUser.fromJson(Map<String, dynamic>.from(decoded)),
        sample: sample,
      );
      return _current;
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> save(StoredSession session) async {
    _current = session;
    await _store.write(tokenKey, session.token);
    await _store.write(userKey, jsonEncode(session.user.toJson()));
    await _store.write(modeKey, session.sample ? 'mock' : 'live');
  }

  Future<void> updateUser(BuyerUser user) async {
    final session = _current;
    if (session == null) return;
    _current = session.withUser(user);
    await _store.write(userKey, jsonEncode(user.toJson()));
  }

  /// Forgets the session in memory first, so no request issued after this
  /// call can pick up the old token, then wipes secure storage.
  Future<void> clear() async {
    _current = null;
    for (final key in const [tokenKey, userKey, modeKey]) {
      try {
        await _store.delete(key);
      } catch (_) {}
    }
  }
}
