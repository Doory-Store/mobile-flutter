import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/shop_strings.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../cart/cart_controller.dart';
import 'pdp_sheets.dart';

/// The option the shopper has effectively chosen: the one at [selectedId], or
/// the only option, or none (several options and nothing picked yet).
ProductOptionModel? effectiveOption(
  ProductDetailModel product,
  int? selectedId,
) {
  if (product.options.isEmpty) return null;
  for (final option in product.options) {
    if (option.id == selectedId) return option;
  }
  return product.options.length == 1 ? product.options.first : null;
}

/// Adds one unit of [product] to the cart, exactly as the product page does:
/// several options open the option sheet first, then a toast offers «عرض
/// السلة». [onOptionPicked] reports the option chosen in the sheet.
Future<void> addProductToCart(
  BuildContext context,
  WidgetRef ref,
  ProductDetailModel product, {
  int? selectedId,
  ValueChanged<int>? onOptionPicked,
}) async {
  var option = effectiveOption(product, selectedId);
  if (product.options.length > 1 && option == null) {
    final picked = await showPdpVariantSheet(
      context,
      product: product,
      selectedId: selectedId,
    );
    if (picked == null || !context.mounted) return;
    onOptionPicked?.call(picked);
    option = effectiveOption(product, picked);
  }
  // BACKEND: AVAILABLE POST /carts, POST /carts/{public_id}/lines (cart is a local mock today)
  await ref
      .read(cartProvider.notifier)
      .add(
        CartLineDraft(
          product: product.toCard(),
          quantity: 1,
          optionId: option?.id,
          optionLabel: option?.label,
          storeId: product.storeId,
        ),
      );
  if (!context.mounted) return;
  showToast(
    context,
    ShopStrings.addedToCart(1),
    actionLabel: ShopStrings.viewCart,
    onAction: () => context.go('/cart'),
  );
}
