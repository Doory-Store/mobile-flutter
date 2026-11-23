import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/branch_keys.dart';
import '../../core/widgets/bottom_tab_bar.dart';
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
    final current = DooryTab.values[navigationShell.currentIndex];
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomTabBar(
        current: current,
        cartCount: cartCount,
        onSelect: (tab) => _select(ref, tab.index),
      ),
    );
  }
}
