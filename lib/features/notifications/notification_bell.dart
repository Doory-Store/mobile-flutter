import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../account/account_providers.dart';

/// App-bar bell with the unread count.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsProvider);
    return IconButton(
      tooltip: ShopStrings.notifications,
      onPressed: () => context.push('/notifications'),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text('$unread'),
        backgroundColor: DooryColors.primaryStrong,
        child: const Icon(Icons.notifications_none),
      ),
    );
  }
}
