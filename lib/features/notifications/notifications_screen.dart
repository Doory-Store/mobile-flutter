import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/date_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../account/account_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(ShopStrings.notifications),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () =>
                  ref.read(notificationsProvider.notifier).markAllRead(),
              child: const Text(ShopStrings.markAllRead),
            ),
          IconButton(
            tooltip: ShopStrings.notificationSettings,
            icon: const Icon(Icons.tune),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: async.when(
        loading: () => const ListSkeleton(height: 72),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailable,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(notificationsProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyState(
                icon: Icons.notifications_off_outlined,
                title: ShopStrings.noNotifications,
                body: ShopStrings.noNotificationsBody,
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(notificationsProvider.future),
                child: ListView.separated(
                  itemCount: items.length + 1,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == 0) return const MockBanner();
                    return _NotificationTile(item: items[index - 1]);
                  },
                ),
              ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.item});

  final AppNotification item;

  IconData get _icon {
    if (item.eventKey.contains('delivery')) {
      return Icons.local_shipping_outlined;
    }
    if (item.eventKey.contains('payment')) return Icons.payments_outlined;
    if (item.eventKey.contains('delivered')) return Icons.check_circle_outline;
    if (item.eventKey.startsWith('product')) return Icons.inventory_2_outlined;
    return Icons.notifications_none;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    return Material(
      color: item.isRead ? DooryColors.surface : tokens.primarySubtle,
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        leading: CircleAvatar(
          backgroundColor: DooryColors.surface,
          child: Icon(_icon, color: DooryColors.primaryStrong),
        ),
        title: Text(
          item.title,
          style: item.isRead
              ? DooryTypography.label(context)
              : DooryTypography.labelStrong(context),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.body, style: DooryTypography.label(context)),
            const SizedBox(height: 2),
            Text(
              formatRelative(item.createdAt),
              style: DooryTypography.cardMeta(context),
            ),
          ],
        ),
        trailing: item.isRead
            ? null
            : const Icon(
                Icons.circle,
                size: 10,
                color: DooryColors.primaryStrong,
              ),
        onTap: () {
          ref.read(notificationsProvider.notifier).markRead(item.id);
          final order = item.orderPublicId;
          if (order != null) context.push('/orders/$order');
        },
      ),
    );
  }
}
