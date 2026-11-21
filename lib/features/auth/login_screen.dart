import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../../data/repositories/commerce/commerce_providers.dart';
import 'session_controller.dart';

/// Seconds between two code requests on this screen. The server's own
/// window (3 codes per phone per 15 minutes) is reported back through
/// `X-RateLimit-Remaining` and `Retry-After`, and always wins.
const otpResendCooldown = 60;

/// Phone → one-time code, or phone + password. With the sample auth
/// repository the code is shown on screen and the session is a labelled demo.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({this.next, super.key});

  final String? next;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _phoneForm = GlobalKey<FormState>();
  OtpChallenge? _challenge;
  bool _passwordMode = false;
  bool _showPassword = false;
  bool _busy = false;
  String? _error;
  int _resendIn = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() => _resendIn = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _resendIn = _resendIn > 0 ? _resendIn - 1 : 0);
      if (_resendIn == 0) timer.cancel();
    });
  }

  void _fail(DomainRejection error) {
    if (!mounted) return;
    setState(() => _error = error.message);
    if (error is RateLimitedRejection) {
      final wait = error.retryAfter?.inSeconds ?? otpResendCooldown;
      if (wait > _resendIn) _startTimer(wait);
    }
  }

  Future<void> _requestCode() async {
    if (_challenge == null && !(_phoneForm.currentState?.validate() ?? false)) {
      return;
    }
    final phone = _challenge?.phone ?? normalizeSyrianMobile(_phone.text)!;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestOtp(phone);
      if (!mounted) return;
      setState(() {
        _challenge = challenge;
        _code.clear();
      });
      _startTimer(otpResendCooldown);
    } on DomainRejection catch (error) {
      _fail(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final challenge = _challenge;
    if (challenge == null || _busy) return;
    if (_code.text.trim().length != 6) {
      setState(() => _error = ShopStrings.otpLength);
      return;
    }
    await _complete(
      () => ref
          .read(authRepositoryProvider)
          .verifyOtp(challenge.phone, _code.text),
    );
  }

  Future<void> _passwordLogin() async {
    if (!(_phoneForm.currentState?.validate() ?? false)) return;
    final phone = normalizeSyrianMobile(_phone.text)!;
    await _complete(
      () => ref
          .read(authRepositoryProvider)
          .loginWithPassword(phone, _password.text),
    );
  }

  Future<void> _complete(Future<BuyerSession> Function() call) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final session = await call();
      await ref.read(sessionProvider.notifier).signIn(session);
      _password.clear();
      _code.clear();
      unawaited(ref.read(sessionProvider.notifier).refreshProfile());
      if (!mounted) return;
      showToast(context, ShopStrings.signedIn(session.user.name));
      final next = widget.next;
      if (next != null && next.startsWith('/') && !next.startsWith('//')) {
        context.pushReplacement(next);
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.go('/account');
      }
    } on DomainRejection catch (error) {
      _fail(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _togglePasswordMode() {
    setState(() {
      _passwordMode = !_passwordMode;
      _challenge = null;
      _error = null;
      _code.clear();
      _password.clear();
    });
  }

  String? _validatePhone(String? value) =>
      normalizeSyrianMobile(value ?? '') == null
      ? ShopStrings.phoneInvalid
      : null;

  @override
  Widget build(BuildContext context) {
    final challenge = _challenge;
    final session = ref.watch(sessionProvider);
    final sample = ref.watch(authRepositoryProvider).isSample;
    final title = _passwordMode
        ? ShopStrings.loginPasswordTitle
        : challenge == null
        ? ShopStrings.loginTitle
        : ShopStrings.otpTitle;
    final body = _passwordMode
        ? ShopStrings.loginPasswordBody
        : challenge == null
        ? ShopStrings.loginBody
        : ShopStrings.otpBody(formatPhone(challenge.phone));
    // The server's pre-delivery test code appears in debug and sample
    // builds only. Release builds wait for the real SMS / WhatsApp message.
    final testCode = (sample || !kReleaseMode)
        ? challenge?.simulationCode
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.login)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          if (sample) ...[
            const MockBanner(message: ShopStrings.loginMockNote),
            const SizedBox(height: 16),
          ],
          if (session.expired && !sample) ...[
            _Notice(text: ShopStrings.sessionExpiredNote),
            const SizedBox(height: 16),
          ],
          Icon(
            _passwordMode ? Icons.lock_outline : Icons.phone_iphone,
            size: 56,
            color: DooryColors.primaryStrong,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: DooryTypography.page(context),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: DooryTypography.body(context),
          ),
          const SizedBox(height: 24),
          if (challenge == null)
            Form(
              key: _phoneForm,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DooryTextField(
                      key: const ValueKey('login-phone'),
                      label: ShopStrings.phone,
                      controller: _phone,
                      hint: '09XX XXX XXX',
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      autofocus: true,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      prefix: const Icon(Icons.phone_outlined),
                      validator: _validatePhone,
                    ),
                    if (_passwordMode) ...[
                      const SizedBox(height: 12),
                      DooryTextField(
                        key: const ValueKey('login-password'),
                        label: ShopStrings.passwordLabel,
                        controller: _password,
                        obscureText: !_showPassword,
                        textDirection: TextDirection.ltr,
                        autofillHints: const [AutofillHints.password],
                        prefix: const Icon(Icons.lock_outline),
                        suffix: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                        validator: (value) => (value ?? '').isEmpty
                            ? ShopStrings.passwordRequired
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            )
          else ...[
            TextField(
              key: const ValueKey('login-code'),
              controller: _code,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              maxLength: 6,
              autofillHints: const [AutofillHints.oneTimeCode],
              enableSuggestions: false,
              autocorrect: false,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: DooryTypography.page(context).copyWith(letterSpacing: 12),
              onChanged: (value) {
                if (value.length == 6) _verify();
              },
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••••',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ShopStrings.otpValidFor(challenge.expiresIn),
              textAlign: TextAlign.center,
              style: DooryTypography.cardMeta(context),
            ),
            if (challenge.remainingSends != null) ...[
              const SizedBox(height: 4),
              Text(
                ShopStrings.remainingSends(challenge.remainingSends!),
                textAlign: TextAlign.center,
                style: DooryTypography.cardMeta(context),
              ),
            ],
            if (testCode != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DemoLabel(),
                  const SizedBox(width: 8),
                  Text(
                    sample
                        ? ShopStrings.simulationCode(testCode)
                        : '${ShopStrings.serverTestCode}: $testCode',
                    style: DooryTypography.label(context),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _resendIn > 0 || _busy ? null : _requestCode,
                  child: Text(
                    _resendIn > 0
                        ? ShopStrings.resendIn(_resendIn)
                        : ShopStrings.resend,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _challenge = null;
                    _code.clear();
                    _error = null;
                  }),
                  child: const Text(ShopStrings.changePhone),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () =>
                  showNotWired(context, feature: ShopStrings.whatsappChannel),
              icon: const Icon(Icons.chat_outlined),
              label: const Text(ShopStrings.sendViaWhatsapp),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              key: const ValueKey('login-error'),
              textAlign: TextAlign.center,
              style: DooryTypography.label(context)
                  .copyWith(color: DooryColors.danger),
            ),
          ],
          const SizedBox(height: 16),
          DooryPrimaryButton(
            label: _passwordMode
                ? ShopStrings.signInAction
                : challenge == null
                ? (_resendIn > 0
                      ? ShopStrings.resendIn(_resendIn)
                      : ShopStrings.sendCode)
                : ShopStrings.verify,
            busy: _busy,
            onPressed: _passwordMode
                ? _passwordLogin
                : challenge == null
                ? (_resendIn > 0 ? null : _requestCode)
                : _verify,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _busy ? null : _togglePasswordMode,
            child: Text(
              _passwordMode
                  ? ShopStrings.loginWithOtp
                  : ShopStrings.loginWithPassword,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ShopStrings.termsNote,
            textAlign: TextAlign.center,
            style: DooryTypography.cardMeta(context),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: DooryColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_clock_outlined, color: DooryColors.danger),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: DooryTypography.label(context))),
        ],
      ),
    );
  }
}
