import 'package:dio/dio.dart';
import 'package:doory_mobile/core/auth/auth_providers.dart';
import 'package:doory_mobile/core/auth/credential_vault.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/network/api_transport.dart';
import 'package:doory_mobile/core/network/auth_interceptor.dart';
import 'package:doory_mobile/core/network/log_interceptor.dart';
import 'package:doory_mobile/core/network/redaction.dart';
import 'package:doory_mobile/data/models/commerce_models.dart';
import 'package:doory_mobile/data/repositories/commerce/commerce_contracts.dart';
import 'package:doory_mobile/data/repositories/commerce/live_auth_repository.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/auth/session_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/stub_adapter.dart';

const _config = AppConfig(
  baseUrl: 'https://doory.elogyc.com/api/v1',
  timeout: Duration(seconds: 2),
  flavor: AppFlavor.dev,
);

const _phone = '+963944123456';
const _token = '7|abcdefghijklmnopqrstuvwxyz0123456789';

const _user = {'id': 42, 'phone': _phone, 'name': 'زبون'};

/// Dio wired like production (header → auth → log → error mapping), talking
/// to [adapter].
({DioApiTransport transport, StubAdapter adapter, List<int> revoked}) _harness(
  StubReply Function(RequestOptions options) reply, {
  String? token = _token,
  AppConfig config = _config,
}) {
  final adapter = StubAdapter(reply);
  final revoked = <int>[];
  final dio = buildDio(
    config,
    interceptors: [
      AuthInterceptor(
        apiUri: config.apiUri,
        allowInsecureHttp: config.allowInsecureHttp,
        readToken: () => token,
        onUnauthorized: () => revoked.add(1),
      ),
    ],
  )..httpClientAdapter = adapter;
  return (
    transport: DioApiTransport(config, dio: dio),
    adapter: adapter,
    revoked: revoked,
  );
}

void main() {
  group('Phone normalisation mirrors the backend PhoneNormalizer', () {
    test('accepts every common spelling', () {
      for (final input in [
        '0944123456',
        '0944 123 456',
        '0944-123-456',
        '(0944) 123456',
        '944123456',
        '963944123456',
        '+963944123456',
        '+963 944 123 456',
        '00963944123456',
        '٠٩٤٤١٢٣٤٥٦',
        '۰۹۴۴۱۲۳۴۵۶',
      ]) {
        expect(normalizeSyrianMobile(input), _phone, reason: input);
      }
    });

    test('rejects landlines, short numbers and other countries', () {
      for (final input in [
        '',
        '12345',
        '0311234567',
        '+9631123456',
        '+966512345678',
        '094412345',
        '09441234567',
        '+9630944123456',
      ]) {
        expect(normalizeSyrianMobile(input), isNull, reason: input);
      }
    });
  });

  group('Redaction', () {
    test('masks secret headers case-insensitively', () {
      final out = redactHeaders({
        'Authorization': 'Bearer $_token',
        'cookie': 'x=1',
        'Accept': 'application/json',
      });
      expect(out['Authorization'], redactedMark);
      expect(out['cookie'], redactedMark);
      expect(out['Accept'], 'application/json');
    });

    test('masks tokens, codes, passwords and phones in bodies', () {
      final out = redactBody({
        'phone': _phone,
        'code': '754297',
        'password': 'hunter22',
        'token': _token,
        'user': {'id': 1, 'phone': _phone, 'name': 'زبون'},
        'note': 'call 0944123456 please',
      }).toString();
      expect(out, isNot(contains('754297')));
      expect(out, isNot(contains('hunter22')));
      expect(out, isNot(contains(_token)));
      expect(out, isNot(contains('944123456')));
      expect(out, contains('زبون'));
    });

    test('masks phones and bearer tokens in free text and URLs', () {
      expect(redactText('Bearer $_token'), isNot(contains(_token)));
      final url = redactUri(
        Uri.parse('https://x.test/api/v1/search?q=زيت&phone=0944123456'),
      );
      expect(url, isNot(contains('0944123456')));
      expect(url, contains('q='));
    });

    test('the debug log interceptor never prints secrets', () async {
      final lines = <String>[];
      final adapter = StubAdapter(
        (_) => const StubReply(200, {'token': _token, 'user': _user}),
      );
      final dio = Dio(BaseOptions(baseUrl: _config.baseUrl))
        ..httpClientAdapter = adapter
        ..interceptors.add(RedactingLogInterceptor(sink: lines.add));
      await dio.post<dynamic>(
        '/auth/otp/verify',
        data: {'phone': _phone, 'code': '754297', 'purpose': 'login'},
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );
      final log = lines.join('\n');
      expect(log, contains('/auth/otp/verify'));
      expect(log, isNot(contains(_token)));
      expect(log, isNot(contains('754297')));
      expect(log, isNot(contains('944123456')));
    });
  });

  group('AuthInterceptor', () {
    test('attaches the bearer token to API requests only', () async {
      final h = _harness((_) => const StubReply(200, {'ok': true}));
      await h.transport.get('/home');
      await h.transport.dio.get<dynamic>(
        'https://cdn.example.com/storage/a.webp',
      );
      await h.transport.dio.get<dynamic>(
        'https://doory.elogyc.com.evil.test/api/v1/me',
      );
      await h.transport.dio.get<dynamic>(
        'https://doory.elogyc.com/storage/categories/1/card.webp',
      );
      await h.transport.dio.get<dynamic>('http://doory.elogyc.com/api/v1/me');
      final auth = [
        for (final r in h.adapter.requests) r.headers['Authorization'],
      ];
      expect(auth.first, 'Bearer $_token');
      expect(auth.skip(1), everyElement(isNull));
      expect(h.adapter.requests.first.followRedirects, isFalse);
    });

    test('strips a hand-set Authorization header from foreign hosts', () async {
      final h = _harness((_) => const StubReply(200, {}));
      await h.transport.dio.get<dynamic>(
        'https://images.example.com/x.png',
        options: Options(headers: {'Authorization': 'Bearer leaked'}),
      );
      expect(h.adapter.requests.single.headers['Authorization'], isNull);
    });

    test('guests send no Authorization header', () async {
      final h = _harness((_) => const StubReply(200, {}), token: null);
      await h.transport.get('/home');
      expect(h.adapter.requests.single.headers['Authorization'], isNull);
    });

    test('http API URLs get the token only when insecure http is allowed', () {
      final strict = AuthInterceptor(
        apiUri: Uri.parse('http://10.0.2.2:8000/api/v1'),
        readToken: () => _token,
        onUnauthorized: () {},
      );
      final dev = AuthInterceptor(
        apiUri: Uri.parse('http://10.0.2.2:8000/api/v1'),
        readToken: () => _token,
        onUnauthorized: () {},
        allowInsecureHttp: true,
      );
      final uri = Uri.parse('http://10.0.2.2:8000/api/v1/me');
      expect(strict.isApiRequest(uri), isFalse);
      expect(dev.isApiRequest(uri), isTrue);
      expect(
        dev.isApiRequest(Uri.parse('http://10.0.2.2:9000/api/v1/me')),
        isFalse,
      );
    });

    test('a 401 on an authenticated call revokes the session', () async {
      final h = _harness((_) => const StubReply(401, {'message': 'x'}));
      await expectLater(h.transport.send('GET', '/me'), throwsA(anything));
      expect(h.revoked, hasLength(1));
    });

    test('a 401 without a token does not touch the session', () async {
      final h = _harness(
        (_) => const StubReply(401, {'message': 'x'}),
        token: null,
      );
      await expectLater(h.transport.send('GET', '/me'), throwsA(anything));
      expect(h.revoked, isEmpty);
    });
  });

  group('Release builds', () {
    test('accept only https base URLs', () {
      expect(
        AppConfig.resolveBaseUrl(
          'http://doory.elogyc.com/api/v1',
          release: true,
        ),
        '',
      );
      expect(
        AppConfig.resolveBaseUrl(
          'https://doory.elogyc.com/api/v1/',
          release: true,
        ),
        'https://doory.elogyc.com/api/v1',
      );
      expect(
        AppConfig.resolveBaseUrl('http://10.0.2.2:8000/api/v1', release: false),
        'http://10.0.2.2:8000/api/v1',
      );
      expect(AppConfig.resolveBaseUrl('ftp://x/api', release: false), '');
    });
  });

  group('LiveAuthRepository', () {
    test('requestOtp posts the login purpose and reads the quota', () async {
      final h = _harness(
        (_) => const StubReply(
          202,
          {'expires_in': 300, 'simulation_code': '754297'},
          {'x-ratelimit-remaining': '2'},
        ),
        token: null,
      );
      final challenge = await LiveAuthRepository(h.transport)
          .requestOtp(_phone);
      final request = h.adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/api/v1/auth/otp');
      expect(request.data, {'phone': _phone, 'purpose': 'login'});
      expect(challenge.expiresIn, 300);
      expect(challenge.simulationCode, '754297');
      expect(challenge.remainingSends, 2);
    });

    test('verifyOtp returns the token and user', () async {
      final h = _harness(
        (_) => const StubReply(200, {
          'token': _token,
          'token_type': 'Bearer',
          'user': _user,
        }),
        token: null,
      );
      final session = await LiveAuthRepository(h.transport)
          .verifyOtp(_phone, ' 754297 ');
      expect(h.adapter.requests.single.data, {
        'phone': _phone,
        'code': '754297',
        'purpose': 'login',
      });
      expect(session.token, _token);
      expect(session.user.id, 42);
      expect(session.user.name, 'زبون');
    });

    Future<DomainRejection> rejection(
      StubReply reply,
      Future<Object?> Function(LiveAuthRepository repo) call,
    ) async {
      final h = _harness((_) => reply, token: null);
      try {
        await call(LiveAuthRepository(h.transport));
      } on DomainRejection catch (error) {
        return error;
      }
      fail('expected a DomainRejection');
    }

    test('wrong and expired codes read as Arabic', () async {
      final wrong = await rejection(
        const StubReply(422, {
          'message': 'البيانات غير صالحة',
          'errors': {
            'code': ['الرمز غير صحيح'],
          },
        }),
        (repo) => repo.verifyOtp(_phone, '000000'),
      );
      expect(wrong.message, AuthErrors.codeInvalid);
      final expired = await rejection(
        const StubReply(422, {
          'message': 'البيانات غير صالحة',
          'errors': {
            'code': ['انتهت صلاحية الرمز'],
          },
        }),
        (repo) => repo.verifyOtp(_phone, '000000'),
      );
      expect(expired.message, AuthErrors.codeExpired);
    });

    test('English validation copy is replaced', () async {
      final error = await rejection(
        const StubReply(422, {
          'message': 'البيانات غير صالحة',
          'errors': {
            'phone': ['The phone field is required.'],
          },
        }),
        (repo) => repo.requestOtp(''),
      );
      expect(error.message, AuthErrors.phoneInvalid);
    });

    test('429 carries Retry-After', () async {
      final error = await rejection(
        const StubReply(
          429,
          {'message': 'Too Many Attempts.'},
          {'retry-after': '754'},
        ),
        (repo) => repo.requestOtp(_phone),
      );
      expect(error, isA<RateLimitedRejection>());
      expect(
        (error as RateLimitedRejection).retryAfter,
        const Duration(seconds: 754),
      );
      expect(error.message, contains('12:34'));
    });

    test('blocked phones keep the server message', () async {
      final error = await rejection(
        const StubReply(403, {'message': 'هذا الرقم محظور'}),
        (repo) => repo.requestOtp(_phone),
      );
      expect(error.message, 'هذا الرقم محظور');
    });

    test('bad password reads as wrong credentials (422 or 401)', () async {
      final unprocessable = await rejection(
        const StubReply(422, {
          'message': 'البيانات غير صالحة',
          'errors': {
            'credentials': ['invalid'],
          },
        }),
        (repo) => repo.loginWithPassword(_phone, 'x'),
      );
      expect(unprocessable.message, AuthErrors.credentials);
      final unauthorized = await rejection(
        const StubReply(401, {'message': 'Unauthenticated.'}),
        (repo) => repo.loginWithPassword(_phone, 'x'),
      );
      expect(unauthorized.message, AuthErrors.credentials);
    });

    test('me accepts bare and data-wrapped bodies', () async {
      for (final body in [
        {
          ..._user,
          'email': null,
          'roles': ['buyer'],
        },
        {'data': _user},
      ]) {
        final h = _harness((_) => StubReply(200, body));
        final user = await LiveAuthRepository(h.transport).me();
        expect(user.id, 42);
        expect(
          h.adapter.requests.single.headers['Authorization'],
          'Bearer $_token',
        );
      }
    });

    test('logout tolerates an already revoked token', () async {
      final h = _harness((_) => const StubReply(401, {'message': 'x'}));
      await LiveAuthRepository(h.transport).logout();
      expect(h.adapter.requests.single.uri.path, '/api/v1/auth/logout');
    });

    test('network failures read as Arabic', () async {
      final adapter = StubAdapter(
        (options) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        ),
      );
      final dio = buildDio(_config)..httpClientAdapter = adapter;
      final repo = LiveAuthRepository(DioApiTransport(_config, dio: dio));
      await expectLater(
        repo.requestOtp(_phone),
        throwsA(
          isA<DomainRejection>().having(
            (e) => e.message,
            'message',
            AuthErrors.network,
          ),
        ),
      );
    });
  });

  group('CredentialVault', () {
    test('round-trips through the store and wipes on clear', () async {
      final store = MemoryTokenStore();
      final vault = CredentialVault(store);
      await vault.save(
        const StoredSession(
          token: _token,
          user: BuyerUser(id: 42, phone: _phone, name: 'زبون'),
          sample: false,
        ),
      );
      final again = CredentialVault(store);
      final loaded = await again.load(sample: false);
      expect(loaded?.token, _token);
      expect(again.liveToken, _token);
      await again.clear();
      expect(store.values, isEmpty);
      expect(again.liveToken, isNull);
    });

    test('a demo session is never offered to the API', () async {
      final vault = CredentialVault(MemoryTokenStore());
      await vault.save(
        const StoredSession(
          token: 'mock-token',
          user: BuyerUser(id: 1, phone: _phone, name: 'x'),
          sample: true,
        ),
      );
      expect(vault.liveToken, isNull);
    });

    test('a session from the other auth mode is wiped on load', () async {
      final store = MemoryTokenStore();
      await CredentialVault(store).save(
        const StoredSession(
          token: 'mock-token',
          user: BuyerUser(id: 1, phone: _phone, name: 'x'),
          sample: true,
        ),
      );
      final vault = CredentialVault(store);
      expect(await vault.load(sample: false), isNull);
      expect(store.values, isEmpty);
    });

    test('toString never prints the token', () {
      const session = StoredSession(
        token: _token,
        user: BuyerUser(id: 1, phone: _phone, name: 'x'),
        sample: false,
      );
      expect('$session', isNot(contains(_token)));
      expect('$session', isNot(contains('944123456')));
    });
  });

  group('Session', () {
    ProviderContainer container(StubAdapter adapter, CredentialVault vault) {
      return ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(_config),
          credentialVaultProvider.overrideWithValue(vault),
          apiTransportProvider.overrideWith((ref) {
            final dio = buildDio(
              _config,
              interceptors: [
                AuthInterceptor(
                  apiUri: _config.apiUri,
                  readToken: () => ref.read(credentialVaultProvider).liveToken,
                  onUnauthorized: () {
                    ref.read(credentialVaultProvider).clear();
                    ref.read(sessionRevokedProvider.notifier).state++;
                  },
                ),
              ],
            )..httpClientAdapter = adapter;
            return DioApiTransport(_config, dio: dio);
          }),
        ],
      );
    }

    test('sign-in stores the token; sign-out revokes and wipes it', () async {
      final adapter = StubAdapter((_) => const StubReply(204));
      final store = MemoryTokenStore();
      final vault = CredentialVault(store);
      final c = container(adapter, vault);
      addTearDown(c.dispose);
      expect(c.read(sessionProvider).sample, isFalse);
      await c
          .read(sessionProvider.notifier)
          .signIn(
            const BuyerSession(
              token: _token,
              user: BuyerUser(id: 42, phone: _phone, name: 'زبون'),
            ),
          );
      expect(c.read(sessionProvider).signedIn, isTrue);
      expect(store.values[CredentialVault.tokenKey], _token);

      await c.read(sessionProvider.notifier).signOut();
      expect(c.read(sessionProvider).signedIn, isFalse);
      expect(store.values, isEmpty);
      final logout = adapter.requests.single;
      expect(logout.uri.path, '/api/v1/auth/logout');
      expect(logout.headers['Authorization'], 'Bearer $_token');
    });

    test('a 401 from /me signs the buyer out and flags expiry', () async {
      final adapter = StubAdapter(
        (_) => const StubReply(401, {'message': 'x'}),
      );
      final store = MemoryTokenStore();
      final vault = CredentialVault(store);
      await vault.save(
        const StoredSession(
          token: _token,
          user: BuyerUser(id: 42, phone: _phone, name: 'زبون'),
          sample: false,
        ),
      );
      final c = container(adapter, vault);
      addTearDown(c.dispose);
      expect(c.read(sessionProvider).signedIn, isTrue);
      await c.read(sessionProvider.notifier).refreshProfile();
      final state = c.read(sessionProvider);
      expect(state.signedIn, isFalse);
      expect(state.expired, isTrue);
      expect(store.values, isEmpty);
    });

    test('sign-out wipes the device even when offline', () async {
      final adapter = StubAdapter(
        (options) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        ),
      );
      final store = MemoryTokenStore();
      final vault = CredentialVault(store);
      await vault.save(
        const StoredSession(
          token: _token,
          user: BuyerUser(id: 42, phone: _phone, name: 'زبون'),
          sample: false,
        ),
      );
      final c = container(adapter, vault);
      addTearDown(c.dispose);
      await c.read(sessionProvider.notifier).signOut();
      expect(c.read(sessionProvider).signedIn, isFalse);
      expect(store.values, isEmpty);
    });
  });
}
