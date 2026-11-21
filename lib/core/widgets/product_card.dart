import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites/favorites_controller.dart';
import '../../data/models/catalog_models.dart';
import '../format/price_format.dart';
import '../l10n/doory_strings.dart';
import '../routing/nav.dart';
import '../theme/doory_colors.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'chrome.dart';
import 'price_text.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({required this.product, this.width, super.key});

  final ProductCardModel product;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final saved = ref
        .watch(favoritesProvider)
        .any((item) => item.id == product.id);
    final label = productSemantics(
      name: product.name,
      storeName: product.storeName,
      priceSyp: product.priceSyp,
      priceIsEstimate: product.priceIsEstimate,
      available: product.available,
      canPurchase: product.canPurchase,
      rating: product.averageRating,
    );

    final card = Material(
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        side: BorderSide(color: scheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: ColoredBox(
                  color: scheme.surface,
                  child: _Photo(url: product.photoUrl, name: product.name),
                ),
              ),
              PositionedDirectional(
                top: 4,
                end: 4,
                child: _FavoriteButton(product: product, saved: saved),
              ),
            ],
          ),
          Expanded(
            child: Semantics(
              button: true,
              label: label,
              child: InkWell(
                onTap: () => pushProduct(context, product.ref),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.storeName != null)
                          Text(
                            product.storeName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DooryTypography.cardBrand(context),
                          ),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: DooryTypography.cardTitle(context),
                        ),
                        const SizedBox(height: 4),
                        PriceText(
                          amount: product.priceSyp,
                          estimate: product.priceIsEstimate,
                        ),
                        if (!product.available)
                          Text(
                            DooryStrings.soldOut,
                            style: DooryTypography.cardMeta(
                              context,
                              color: tokens.danger,
                            ),
                          )
                        else if (!product.canPurchase)
                          Text(
                            DooryStrings.cannotPurchase,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: DooryTypography.cardMeta(
                              context,
                              color: tokens.danger,
                            ),
                          ),
                        if (product.averageRating != null) ...[
                          const SizedBox(height: 4),
                          _Rating(
                            value: product.averageRating!,
                            count: product.reviewsCount,
                          ),
                        ],
                        if (product.sample) ...[
                          const SizedBox(height: 6),
                          const DemoLabel(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (width == null) return card;
    return SizedBox(width: width, child: card);
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.url, required this.name});

  final String? url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    if (url == null) {
      return Center(child: Icon(Icons.image_outlined, color: muted, size: 32));
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 200),
      memCacheWidth: 480,
      placeholder: (context, _) => const SkeletonBox(height: double.infinity),
      errorWidget: (context, _, _) =>
          Center(child: Icon(Icons.image_outlined, color: muted, size: 32)),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.product, required this.saved});

  final ProductCardModel product;
  final bool saved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shadowColor: DooryColors.shadowFavorite,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: saved ? DooryStrings.removeFavorite : DooryStrings.addFavorite,
        onPressed: () => ref.read(favoritesProvider.notifier).toggle(product),
        icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
        color: saved
            ? tokens.danger
            : Theme.of(context).colorScheme.onSurfaceVariant,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          minimumSize: const Size(44, 44),
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.value, required this.count});

  final double value;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final filled = value.round().clamp(0, 5);
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < filled ? Icons.star : Icons.star_border,
            size: 14,
            color: i < filled
                ? tokens.rating
                : Theme.of(context).colorScheme.outline,
          ),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Text('$count', style: DooryTypography.cardMeta(context)),
        ],
      ],
    );
  }
}
