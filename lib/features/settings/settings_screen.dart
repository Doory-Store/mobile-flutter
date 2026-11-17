import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/favorites/favorites_controller.dart';
import '../../data/models/commerce_models.dart';
import '../account/account_providers.dart';
import '../account/local_preferences.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final controller = ref.read(notificationPrefsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.settings)),
      body: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          const MockBanner(),
          const SizedBox(height: 12),
          SectionCard(
            title: ShopStrings.orderNotifications,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 8, 8),
            child: prefs.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => const Text(DooryStrings.unavailable),
              data: (value) => Column(
                children: [
                  _Switch(
                    label: ShopStrings.inApp,
                    value: value.operationalInApp,
                    onChanged: (on) =>
                        controller.save(value.copyWith(operationalInApp: on)),
                  ),
                  _Switch(
                    label: ShopStrings.whatsapp,
                    value: value.operationalWhatsapp,
                    onChanged: (on) => controller.save(
                      value.copyWith(operationalWhatsapp: on),
                    ),
                  ),
                  _Switch(
                    label: ShopStrings.email,
                    value: value.operationalEmail,
                    onChanged: (on) =>
                        controller.save(value.copyWith(operationalEmail: on)),
                  ),
                ],
              ),
            ),
          ),
          SectionCard(
            title: ShopStrings.offersNotifications,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 8, 8),
            child: prefs.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => const Text(DooryStrings.unavailable),
              data: (NotificationPreferences value) => Column(
                children: [
                  _Switch(
                    label: ShopStrings.whatsapp,
                    value: value.marketingWhatsapp,
                    onChanged: (on) =>
                        controller.save(value.copyWith(marketingWhatsapp: on)),
                  ),
                  _Switch(
                    label: ShopStrings.email,
                    value: value.marketingEmail,
                    onChanged: (on) =>
                        controller.save(value.copyWith(marketingEmail: on)),
                  ),
                ],
              ),
            ),
          ),
          SectionCard(
            title: ShopStrings.general,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_city_outlined),
                  title: const Text(ShopStrings.city),
                  subtitle: const Text('حمص'),
                  onTap: () => showToast(context, ShopStrings.onlyHoms),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language),
                  title: const Text(ShopStrings.language),
                  subtitle: const Text('العربية'),
                  onTap: () => showToast(context, ShopStrings.onlyArabic),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: const Text(ShopStrings.clearRecentSearches),
                  onTap: () async {
                    await ref
                        .read(sharedPreferencesProvider)
                        .remove('doory.mock.$recentSearchesKey.v1');
                    if (context.mounted) {
                      showToast(context, ShopStrings.recentCleared);
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.wifi_tethering),
                  title: const Text(DooryStrings.apiStatus),
                  onTap: () => context.push('/account/status'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.policy_outlined),
                  title: const Text(ShopStrings.privacyPolicy),
                  onTap: () =>
                      showNotWired(context, feature: ShopStrings.pagesFeature),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: const Text(ShopStrings.terms),
                  onTap: () =>
                      showNotWired(context, feature: ShopStrings.pagesFeature),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              ShopStrings.versionLabel('0.2.0'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}
