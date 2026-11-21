import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/shop_strings.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../auth/session_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _name;
  final _form = GlobalKey<FormState>();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(sessionProvider).user?.name;
    _name = TextEditingController(text: initial);
    // Shows the server's copy of the profile (`GET /me`).
    Future.microtask(() async {
      await ref.read(sessionProvider.notifier).refreshProfile();
      final fresh = ref.read(sessionProvider).user?.name;
      if (mounted && fresh != null && _name.text == (initial ?? '')) {
        _name.text = fresh;
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider.notifier).updateName(_name.text);
      if (mounted) showToast(context, ShopStrings.profileSaved);
    } on DomainRejection catch (error) {
      if (mounted) showToast(context, error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final user = session.user;
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.profile)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsetsDirectional.only(bottom: 24),
          children: [
            if (session.sample) ...[
              const MockBanner(),
              const SizedBox(height: 12),
            ] else
              const SizedBox(height: 12),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DooryTextField(
                    label: ShopStrings.fullName,
                    controller: _name,
                    validator: (value) =>
                        (value == null || value.trim().length < 2)
                        ? ShopStrings.nameInvalid
                        : null,
                  ),
                  const SizedBox(height: 16),
                  InfoRow(
                    label: ShopStrings.phone,
                    value: user == null ? '' : formatPhone(user.phone),
                    strong: true,
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => showNotWired(
                        context,
                        feature: ShopStrings.changePhoneFeature,
                      ),
                      child: const Text(ShopStrings.changePhoneNumber),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DooryPrimaryButton(
                    label: ShopStrings.save,
                    busy: _busy,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
            SectionCard(
              title: ShopStrings.security,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.password_outlined),
                    title: const Text(ShopStrings.setPassword),
                    onTap: () => showNotWired(
                      context,
                      feature: ShopStrings.setPasswordFeature,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.devices_outlined),
                    title: const Text(ShopStrings.sessions),
                    onTap: () => showNotWired(
                      context,
                      feature: ShopStrings.sessionsFeature,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.download_outlined),
                    title: const Text(ShopStrings.requestMyData),
                    onTap: () => showNotWired(
                      context,
                      feature: ShopStrings.dataRequestFeature,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.delete_forever_outlined,
                      color: Color(0xFFBB0000),
                    ),
                    title: const Text(ShopStrings.deleteAccount),
                    onTap: () => showNotWired(
                      context,
                      feature: ShopStrings.deleteAccountFeature,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
