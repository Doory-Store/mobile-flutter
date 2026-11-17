import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../../data/repositories/commerce/commerce_providers.dart';
import 'session_controller.dart';

/// Phone → one-time code. With the sample auth repository the code is shown
/// on screen and the resulting session is a labelled demo session.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({this.next, super.key});

  final String? next;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _phoneForm = GlobalKey<FormState>();
  OtpChallenge? _challenge;
  bool _busy = false;
  String? _error;
  int _resendIn = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendIn = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _resendIn = _resendIn > 0 ? _resendIn - 1 : 0);
      if (_resendIn == 0) timer.cancel();
    });
  }

  Future<void> _requestCode() async {
    if (!(_phoneForm.currentState?.validate() ?? false)) return;
    final phone = normalizeSyrianMobile(_phone.text)!;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestOtp(phone);
      if (!mounted) return;
      setState(() => _challenge = challenge);
      _startTimer();
    } on DomainRejection catch (error) {
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final challenge = _challenge;
    if (challenge == null) return;
    if (_code.text.trim().length != 6) {
      setState(() => _error = ShopStrings.otpLength);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .verifyOtp(challenge.phone, _code.text);
      await ref.read(sessionProvider.notifier).signIn(session);
      if (!mounted) return;
      showToast(context, ShopStrings.signedIn(session.user.name));
      final next = widget.next;
      if (next != null && next.startsWith('/')) {
        context.pushReplacement(next);
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.go('/account');
      }
    } on DomainRejection catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = _challenge;
    final sample = ref.watch(authRepositoryProvider).isSample;
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.login)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          if (sample) ...[
            const MockBanner(message: ShopStrings.loginMockNote),
            const SizedBox(height: 16),
          ],
          const Icon(
            Icons.phone_iphone,
            size: 56,
            color: DooryColors.primaryStrong,
          ),
          const SizedBox(height: 12),
          Text(
            challenge == null ? ShopStrings.loginTitle : ShopStrings.otpTitle,
            textAlign: TextAlign.center,
            style: DooryTypography.page(context),
          ),
          const SizedBox(height: 8),
          Text(
            challenge == null
                ? ShopStrings.loginBody
                : ShopStrings.otpBody(formatPhone(challenge.phone)),
            textAlign: TextAlign.center,
            style: DooryTypography.body(context),
          ),
          const SizedBox(height: 24),
          if (challenge == null)
            Form(
              key: _phoneForm,
              child: DooryTextField(
                label: ShopStrings.phone,
                controller: _phone,
                hint: '09XX XXX XXX',
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                autofocus: true,
                prefix: const Icon(Icons.phone_outlined),
                validator: (value) => normalizeSyrianMobile(value ?? '') == null
                    ? ShopStrings.phoneInvalid
                    : null,
              ),
            )
          else ...[
            TextField(
              controller: _code,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              maxLength: 6,
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
            if (challenge.simulationCode != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DemoLabel(),
                  const SizedBox(width: 8),
                  Text(
                    ShopStrings.simulationCode(challenge.simulationCode!),
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
              textAlign: TextAlign.center,
              style: DooryTypography.label(context)
                  .copyWith(color: DooryColors.danger),
            ),
          ],
          const SizedBox(height: 16),
          DooryPrimaryButton(
            label: challenge == null
                ? ShopStrings.sendCode
                : ShopStrings.verify,
            busy: _busy,
            onPressed: challenge == null ? _requestCode : _verify,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                showNotWired(context, feature: ShopStrings.passwordLogin),
            child: const Text(ShopStrings.loginWithPassword),
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
