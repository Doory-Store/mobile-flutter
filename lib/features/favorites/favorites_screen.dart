import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/favorites/favorites_controller.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../cart/cart_controller.dart';
import '../listing/catalog_widgets.dart';
import '../shell/tab_signal.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _addAll() async {
    final items = [
      for (final item in ref.read(favoritesProvider))
        if (item.available && item.canPurchase && item.priceSyp != null) item,
    ];
    if (items.isEmpty) {
      showToast(context, ShopStrings.nothingPurchasable);
      return;
    }
    final cart = ref.read(cartProvider.notifier);
    for (final item in items) {
      await cart.add(CartLineDraft(product: item, quantity: 1));
    }
    if (!mounted) return;
    showToast(
      context,
      ShopStrings.addedManyToCart(items.length),
      actionLabel: ShopStrings.viewCart,
      onAction: () => context.go('/cart'),
    );
  }

  Future<void> _clear() async {
    final ok = await confirmAction(
      context,
      title: ShopStrings.clearFavoritesConfirm,
      confirmLabel: ShopStrings.clearAll,
      destructive: true,
    );
    if (!ok) return;
    final controller = ref.read(favoritesProvider.notifier);
    for (final item in [...ref.read(favoritesProvider)]) {
      await controller.toggle(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabReselectProvider, (previous, next) {
      if (next.tab != 2 || !_scroll.hasClients) return;
      _scroll.jumpTo(0);
    });
    final items = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(DooryStrings.tabFavorites),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: ShopStrings.clearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _clear,
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              title: ShopStrings.favoritesEmptyTitle,
              body: DooryStrings.favoritesBody,
              actionLabel: DooryStrings.browseCategories,
              onAction: () => context.go('/categories'),
            )
          : CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      12,
                      16,
                      8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DooryStrings.productCount(items.length),
                                style: DooryTypography.labelStrong(context),
                              ),
                              Text(
                                DooryStrings.favoritesLocalNote,
                                style: DooryTypography.cardMeta(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _addAll,
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text(ShopStrings.addAllToCart),
                        ),
                      ],
                    ),
                  ),
                ),
                ProductGridSliver(items: items),
              ],
            ),
    );
  }
}
