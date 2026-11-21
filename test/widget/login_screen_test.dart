import 'package:doory_mobile/core/l10n/shop_strings.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/data/models/commerce_models.dart';
import 'package:doory_mobile/data/repositories/commerce/commerce_contracts.dart';
import 'package:doory_mobile/data/repositories/commerce/commerce_providers.dart';
import 'package:doory_mobile/data/repositories/commerce/live_auth_repository.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/features/auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Live-shaped repository whose answers the test scripts.
class _ScriptedAuth implements AuthRepository {
  _ScriptedAuth({this.onRequest, this.onVerify});

  final Future<OtpChallenge> Function(String phone)? onRequest;
  final Future<BuyerSession> Function(String phone, String code)? onVerify;
  final List<String> requested = [];

  @override
  bool get isSample => false;

  @override
  Future<OtpChallenge> requestOtp(String phone) {
    requested.add(phone);
    return onRequest!(phone);
  }

  @override
  Future<BuyerSession> verifyOtp(String phone, String code) =>
      onVerify!(phone, code);

  @override
  Future<BuyerSession> loginWithPassword(String phone, String password) =>
      throw const DomainRejection(AuthErrors.credentials);

  @override
  Future<BuyerUser> me() => throw UnimplementedError();

  @override
  Future<BuyerUser> updateName(String name) => throw UnimplementedError();

  @override
  Future<void> logout() async {}
}

Future<void> _pump(WidgetTester tester, AuthRepository repo) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        theme: dooryTheme(),
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: LoginScreen(),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('the phone is normalised before it reaches the API', (
    tester,
  ) async {
    final repo = _ScriptedAuth(
      onRequest: (phone) async =>
          OtpChallenge(phone: phone, expiresIn: 300, remainingSends: 2),
    );
    await _pump(tester, repo);
    await tester.enterText(
      find.byKey(const ValueKey('login-phone')),
      '٠٩٤٤ ١٢٣ ٤٥٦',
    );
    await tester.tap(find.text(ShopStrings.sendCode));
    await tester.pump();
    expect(repo.requested, ['+963944123456']);
    expect(find.text(ShopStrings.otpTitle), findsOneWidget);
    expect(find.text(ShopStrings.remainingSends(2)), findsOneWidget);
    expect(find.text(ShopStrings.resendIn(otpResendCooldown)), findsOneWidget);
    await tester.pump(const Duration(seconds: otpResendCooldown));
  });

  testWidgets('a 429 shows the wait and locks the send button', (tester) async {
    final repo = _ScriptedAuth(
      onRequest: (_) async => throw RateLimitedRejection(
        AuthErrors.throttled(const Duration(seconds: 600)),
        retryAfter: const Duration(seconds: 600),
      ),
    );
    await _pump(tester, repo);
    await tester.enterText(
      find.byKey(const ValueKey('login-phone')),
      '0944123456',
    );
    await tester.tap(find.text(ShopStrings.sendCode));
    await tester.pump();
    expect(
      find.text(AuthErrors.throttled(const Duration(seconds: 600))),
      findsOneWidget,
    );
    expect(find.text(ShopStrings.resendIn(600)), findsOneWidget);
    await tester.tap(find.text(ShopStrings.resendIn(600)));
    await tester.pump();
    expect(repo.requested, hasLength(1));
    await tester.pump(const Duration(seconds: 600));
  });

  testWidgets('a wrong code shows the Arabic error', (tester) async {
    final repo = _ScriptedAuth(
      onRequest: (phone) async => OtpChallenge(phone: phone, expiresIn: 300),
      onVerify: (_, _) async =>
          throw const DomainRejection(AuthErrors.codeInvalid),
    );
    await _pump(tester, repo);
    await tester.enterText(
      find.byKey(const ValueKey('login-phone')),
      '0944123456',
    );
    await tester.tap(find.text(ShopStrings.sendCode));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('login-code')), '000000');
    await tester.pump();
    expect(find.text(AuthErrors.codeInvalid), findsOneWidget);
    await tester.pump(const Duration(seconds: otpResendCooldown));
  });
}
