import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/card_strings.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/favorites/favorites_controller.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../product/add_to_cart.dart';
import 'browsing_history.dart';

/// A browsing-history row after Trendyol's capture: image at the start, the
/// seller with trash and heart, a one-line title, the rating, the price block,
/// and «إضافة إلى السلة» at the end.
///
/// [currentPriceSyp] is set only when the price-drop filter found a lower
/// current price: the viewed price is then shown struck, with a computed badge.
// BACKEND: MISSING coupon line («تم تطبيق الكوبون») and «العروض المميزة» ribbon
// (no per-card coupon or promo on the server; not shown)
class HistoryRowCard extends ConsumerStatefulWidget {
  const HistoryRowCard({
    required this.entry,
    required this.onDelete,
    this.currentPriceSyp,
    super.key,
  });

  final HistoryEntry entry;
  final int? currentPriceSyp;
  final VoidCallback onDelete;

  @override
  ConsumerState<HistoryRowCard> createState() => _HistoryRowCardState();
}

class _HistoryRowCardState extends ConsumerState<HistoryRowCard> {
  bool _busy = false;

  ProductCardModel get _card => widget.entry.card;

  Future<void> _toggleFavorite(bool saved) async {
    // BACKEND: AVAILABLE POST /favorites, DELETE /favorites/{product_id} (auth; favorites stay on device for now)
    await ref.read(favoritesProvider.notifier).toggle(_card);
    if (!mounted) return;
    showToast(
      context,
      saved ? ShopStrings.removedFromFavorites : ShopStrings.addedToFavorites,
    );
  }

  Future<void> _add() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final result = await ref.read(productProvider(_card.id).future);
      if (!mounted) return;
      final product = switch (result) {
        RepoOk<ProductDetailModel>(:final data) => data,
        RepoUnavailable<ProductDetailModel>(:final sample) => sample,
        _ => null,
      };
      if (product == null || !product.available || !product.canPurchase) {
        showToast(context, DooryStrings.unavailableProduct);
        return;
      }
      await addProductToCart(context, ref, product);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref
        .watch(favoritesProvider)
        .any((item) => item.id == _card.id);
    const body = TextStyle(
      fontFamily: 'Cairo',
      fontSize: 14,
      color: DooryColors.textPrimary,
    );
    final muted12 = body.copyWith(
      fontSize: 12,
      color: DooryColors.textSecondary,
    );

    // Price block: the live card's struck price, or the viewed price when a
    // drop was found.
    var price = widget.currentPriceSyp ?? _card.priceSyp;
    int? struck;
    int? percent;
    final viewed = widget.entry.viewedPriceSyp;
    if (widget.currentPriceSyp != null && viewed != null) {
      struck = viewed;
      percent = (((viewed - widget.currentPriceSyp!) * 100) / viewed).round();
    } else if (_card.hasDiscount) {
      struck = _card.compareAtSyp;
      percent = _card.discountPercent;
    }
    if (price != null && price <= 0) price = null;
    final buyable = _card.available && _card.canPurchase;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: DooryColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: DooryColors.shadowCard,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => pushProduct(context, _card.ref, card: _card),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    key: const ValueKey('history-row-image'),
                    width: 82,
                    height: 116,
                    child: _card.photoUrl == null
                        ? const _NoPhoto()
                        : CachedNetworkImage(
                            imageUrl: _card.photoUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: 246,
                            placeholder: (context, _) =>
                                const SkeletonBox(height: double.infinity),
                            errorWidget: (context, _, _) => const _NoPhoto(),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _card.sellerLabel ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: body.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _RowIcon(
                              key: const ValueKey('history-row-favorite'),
                              tooltip: SearchStrings.favorite,
                              icon: saved
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: saved
                                  ? DooryColors.primary
                                  : DooryColors.textSecondary,
                              onPressed: () => _toggleFavorite(saved),
                            ),
                            const SizedBox(width: 12),
                            _RowIcon(
                              key: const ValueKey('history-row-delete'),
                              tooltip: SearchStrings.rowDelete,
                              icon: Icons.delete_outline,
                              color: DooryColors.textSecondary,
                              onPressed: widget.onDelete,
                            ),
                          ],
                        ),
                        Text(
                          _card.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: body.copyWith(
                            color: DooryColors.textSecondary,
                          ),
                        ),
                        if (_card.averageRating != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                CardStrings.reviewCount(_card.reviewsCount),
                                style: muted12,
                              ),
                              const SizedBox(width: 4),
                              _StarRow(value: _card.averageRating!),
                              const SizedBox(width: 4),
                              Text(
                                _card.averageRating!.toStringAsFixed(1),
                                style: muted12,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 6,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      if (struck != null &&
                                          percent != null &&
                                          percent > 0)
                                        Container(
                                          key: const ValueKey(
                                            'history-row-badge',
                                          ),
                                          padding:
                                              const EdgeInsetsDirectional.symmetric(
                                                horizontal: 4,
                                                vertical: 1,
                                              ),
                                          decoration: BoxDecoration(
                                            color: DooryColors.primarySubtle,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            CardStrings.discountBadge(percent),
                                            style: muted12.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: DooryColors.primary,
                                            ),
                                          ),
                                        ),
                                      if (price != null)
                                        Text(
                                          formatSyp(price),
                                          key: const ValueKey(
                                            'history-row-price',
                                          ),
                                          style: body.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: DooryColors.cardPrice,
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (struck != null &&
                                      percent != null &&
                                      percent > 0)
                                    Text(
                                      formatSypDigits(struck),
                                      key: const ValueKey('history-row-struck'),
                                      style: muted12.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            DooryColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (buyable)
                              OutlinedButton(
                                key: const ValueKey('history-row-add'),
                                onPressed: _busy ? null : _add,
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(113, 33),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                        horizontal: 8,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  side: const BorderSide(
                                    color: DooryColors.primary,
                                    width: 1.5,
                                  ),
                                  foregroundColor: DooryColors.primary,
                                ),
                                child: _busy
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        DooryStrings.addToCart,
                                        maxLines: 1,
                                        style: body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: DooryColors.primary,
                                        ),
                                      ),
                              )
                            else
                              Text(
                                SearchStrings.rowUnavailable,
                                key: const ValueKey('history-row-unavailable'),
                                style: muted12.copyWith(
                                  color: DooryColors.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RowIcon extends StatelessWidget {
  const _RowIcon({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      iconSize: 22,
      onPressed: onPressed,
      icon: Icon(icon, color: color),
    );
  }
}

class _NoPhoto extends StatelessWidget {
  const _NoPhoto();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: DooryColors.surfaceSubtle,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: DooryColors.textMuted,
          size: 28,
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            value >= i
                ? Icons.star
                : (value >= i - 0.5 ? Icons.star_half : Icons.star_border),
            size: 12,
            color: DooryColors.rating,
          ),
      ],
    );
  }
}
