import 'package:material_ui/material_ui.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/widgets/bottom_tab_bar.dart';
import '../../core/widgets/doory_app_bar.dart';
import '../../core/widgets/doory_wordmark.dart';
import '../../core/widgets/screen_states.dart';

/// Placeholder root until the screen for [tab] is built in a later phase.
class TabRootScreen extends StatelessWidget {
  const TabRootScreen({required this.tab, super.key});

  final DooryTab tab;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: _bar(context),
      body: EmptyState(
        icon: _icon,
        title: _label,
        message: DooryStrings.sectionReady,
      ),
    );
  }

  PreferredSizeWidget _bar(BuildContext context) {
    if (tab == DooryTab.home) {
      return const _HomeBar();
    }
    return DooryAppBar(title: _label, showBack: false);
  }

  String get _label {
    return switch (tab) {
      DooryTab.home => DooryStrings.tabHome,
      DooryTab.categories => DooryStrings.tabCategories,
      DooryTab.favorites => DooryStrings.tabFavorites,
      DooryTab.cart => DooryStrings.tabCart,
      DooryTab.account => DooryStrings.tabAccount,
    };
  }

  IconData get _icon {
    return switch (tab) {
      DooryTab.home => Icons.home_outlined,
      DooryTab.categories => Icons.grid_view_outlined,
      DooryTab.favorites => Icons.favorite_border,
      DooryTab.cart => Icons.shopping_cart_outlined,
      DooryTab.account => Icons.person_outline,
    };
  }
}

class _HomeBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeBar();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 0,
      child: const DooryStatusInset(
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: DooryWordmark(),
            ),
          ),
        ),
      ),
    );
  }
}
