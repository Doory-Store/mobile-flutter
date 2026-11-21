import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/branch_keys.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../data/favorites/favorites_controller.dart';
import '../cart/cart_controller.dart';
import 'tab_signal.dart';

class DooryShell extends ConsumerWidget {
  const DooryShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

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
    final favoritesCount = ref.watch(favoritesProvider).length;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: DooryColors.surface,
          border: Border(top: BorderSide(color: DooryColors.border)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => _select(ref, index),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: DooryStrings.tabHome,
            ),
            const NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: DooryStrings.tabCategories,
            ),
            NavigationDestination(
              icon: _Counted(
                count: favoritesCount,
                quiet: true,
                child: const Icon(Icons.favorite_border),
              ),
              selectedIcon: _Counted(
                count: favoritesCount,
                quiet: true,
                child: const Icon(Icons.favorite),
              ),
              label: DooryStrings.tabFavorites,
            ),
            NavigationDestination(
              icon: _Counted(
                count: cartCount,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: _Counted(
                count: cartCount,
                child: const Icon(Icons.shopping_cart),
              ),
              label: DooryStrings.tabCart,
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: DooryStrings.tabAccount,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab icon with a count badge. [quiet] badges use a dot instead of a number.
class _Counted extends StatelessWidget {
  const _Counted({
    required this.count,
    required this.child,
    this.quiet = false,
  });

  final int count;
  final Widget child;
  final bool quiet;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child;
    if (quiet) {
      return Badge(
        smallSize: 8,
        backgroundColor: DooryColors.primaryStrong,
        child: child,
      );
    }
    return Badge(
      label: Text(count > 99 ? '99+' : '$count'),
      backgroundColor: DooryColors.primaryStrong,
      textColor: DooryColors.textOnStrong,
      child: child,
    );
  }
}
