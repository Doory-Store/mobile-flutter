import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/branch_keys.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../cart/cart_controller.dart';
import 'tab_signal.dart';

/// True for product pages (`/p/:ref` under any tab). Like Trendyol, the
/// product page hides the tab bar so its sticky add-to-cart bar sits at the
/// bottom.
bool hidesTabBar(String path) => RegExp(r'(^|/)p/[^/]+/?$').hasMatch(path);

class DooryShell extends ConsumerWidget {
  const DooryShell({
    required this.navigationShell,
    this.location = '/',
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  /// Current path, used to hide the bar on product pages.
  final String location;

  void _select(WidgetRef ref, int index) {
    if (index == navigationShell.currentIndex) {
      final navigator = branchNavigatorKeys[index].currentState;
      if (navigator != null && navigator.canPop()) {
        navigationShell.goBranch(index, initialLocation: true);
      } else {
        ref.read(tabReselectProvider.notifier).ping(index);
      }
    } else {
      navigationShell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: hidesTabBar(location)
          ? null
          : DecoratedBox(
              decoration: const BoxDecoration(
                color: DooryColors.surface,
                border: Border(top: BorderSide(color: DooryColors.border)),
              ),
              // Trendyol's tab bar: outlined grey icons, the active tab turns
              // orange with a filled icon and a bold label, no indicator pill.
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  height: 62,
                  elevation: 0,
                  backgroundColor: DooryColors.surface,
                  surfaceTintColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  labelPadding: const EdgeInsetsDirectional.only(top: 2),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return DooryTypography.navLabel(
                      selected
                          ? DooryColors.primary
                          : DooryColors.textSecondary,
                    ).copyWith(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    );
                  }),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return IconThemeData(
                      color: selected
                          ? DooryColors.primary
                          : DooryColors.textSecondary,
                      size: 26,
                    );
                  }),
                ),
                child: NavigationBar(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) => _select(ref, index),
                  destinations: [
                    const NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: DooryStrings.tabHome,
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: DooryStrings.tabCategories,
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.favorite_border_rounded),
                      selectedIcon: Icon(Icons.favorite_rounded),
                      label: DooryStrings.tabFavorites,
                    ),
                    NavigationDestination(
                      icon: _CartBadge(
                        count: cartCount,
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                      selectedIcon: _CartBadge(
                        count: cartCount,
                        child: const Icon(Icons.shopping_cart_rounded),
                      ),
                      label: DooryStrings.tabCart,
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: DooryStrings.tabAccount,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Orange count bubble on the cart icon, as on Trendyol's «سلة مشترياتي».
/// BACKEND: AVAILABLE GET /carts/{public_id} (count comes from the local mock cart today)
class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child;
    return Badge(
      label: Text(count > 99 ? '99+' : '$count'),
      backgroundColor: DooryColors.primary,
      textColor: DooryColors.textOnStrong,
      offset: const Offset(-6, -4),
      child: child,
    );
  }
}
