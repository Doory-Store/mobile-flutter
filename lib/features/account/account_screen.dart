import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../auth/session_controller.dart';
import 'account_providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final unread = ref.watch(unreadNotificationsProvider);
    final user = session.user;

    void needsLogin(String route) {
      if (user == null) {
        context.push('/login?next=$route');
      } else {
        context.push(route);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.tabAccount)),
      body: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          _Header(signedIn: user != null, sample: session.sample),
          const SizedBox(height: 12),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.receipt_long_outlined,
                  label: ShopStrings.myOrders,
                  onTap: () => needsLogin('/orders'),
                ),
                _MenuTile(
                  icon: Icons.location_on_outlined,
                  label: ShopStrings.myAddresses,
                  onTap: () => needsLogin('/addresses'),
                ),
                _MenuTile(
                  icon: Icons.favorite_border,
                  label: DooryStrings.tabFavorites,
                  onTap: () => context.go('/favorites'),
                ),
                _MenuTile(
                  icon: Icons.notifications_none,
                  label: ShopStrings.notifications,
                  badge: unread,
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),
          ),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.person_outline,
                  label: ShopStrings.profile,
                  onTap: () => needsLogin('/profile'),
                ),
                _MenuTile(
                  icon: Icons.settings_outlined,
                  label: ShopStrings.settings,
                  onTap: () => context.push('/settings'),
                ),
                _MenuTile(
                  icon: Icons.support_agent_outlined,
                  label: ShopStrings.helpSupport,
                  onTap: () => context.push('/support'),
                ),
                _MenuTile(
                  icon: Icons.wifi_tethering,
                  label: DooryStrings.apiStatus,
                  onTap: () => context.push('/account/status'),
                ),
                _MenuTile(
                  icon: Icons.info_outline,
                  label: DooryStrings.aboutTitle,
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: DooryStrings.appName,
                    applicationVersion: '0.2.0',
                    children: const [Text(DooryStrings.aboutBody)],
                  ),
                ),
              ],
            ),
          ),
          if (user != null)
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: DooryOutlineButton(
                label: ShopStrings.logout,
                icon: Icons.logout,
                onPressed: () async {
                  final ok = await confirmAction(
                    context,
                    title: ShopStrings.logoutConfirm,
                    confirmLabel: ShopStrings.logout,
                  );
                  if (!ok) return;
                  await ref.read(sessionProvider.notifier).signOut();
                  if (context.mounted) {
                    showToast(context, ShopStrings.loggedOut);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.signedIn, required this.sample});

  final bool signedIn;
  final bool sample;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    final user = ref.watch(sessionProvider).user;
    return Container(
      color: tokens.primarySubtle,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: DooryColors.primaryStrong,
            child: user == null
                ? const Icon(Icons.person, color: DooryColors.textOnStrong)
                : Text(
                    user.name.isEmpty ? '؟' : user.name.characters.first,
                    style: DooryTypography.section(context)
                        .copyWith(color: DooryColors.textOnStrong),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user == null
                      ? ShopStrings.welcomeGuest
                      : ShopStrings.welcomeUser(user.name),
                  style: DooryTypography.section(context),
                ),
                const SizedBox(height: 2),
                Text(
                  user == null
                      ? ShopStrings.guestBody
                      : formatPhone(user.phone),
                  style: DooryTypography.label(context),
                ),
                if (user != null && sample) ...[
                  const SizedBox(height: 6),
                  const DemoLabel(),
                ],
              ],
            ),
          ),
          if (user == null)
            FilledButton(
              onPressed: () => context.push('/login'),
              child: const Text(ShopStrings.login),
            ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: DooryColors.primaryStrong),
      title: Text(label, style: DooryTypography.body(context)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge > 0)
            Badge(
              label: Text('$badge'),
              backgroundColor: DooryColors.primaryStrong,
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_left),
        ],
      ),
      onTap: onTap,
    );
  }
}
