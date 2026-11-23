import 'package:material_ui/material_ui.dart';

import '../format/price_format.dart';
import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'chrome.dart';
import 'doory_badge.dart';
import 'doory_image.dart';
import 'favorite_button.dart';
import 'price_block.dart';
import 'rating_row.dart';

/// Column card. Width comes from the parent; on a 411 dp screen that is 193.5.
class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({
    required this.ref,
    required this.name,
    this.brand,
    this.image,
    this.priceSyp,
    this.compareAtSyp,
    this.estimate = false,
    this.rating,
    this.ratingCount,
    this.colorCount,
    this.available = true,
    this.canPurchase = true,
    this.favorite = false,
    this.sample = false,
    this.onTap,
    this.onFavorite,
    this.textPadding = 8,
    super.key,
  });

  final String ref;
  final String name;
  final String? brand;
  final String? image;
  final int? priceSyp;
  final int? compareAtSyp;
  final bool estimate;
  final double? rating;
  final int? ratingCount;
  final int? colorCount;
  final bool available;
  final bool canPurchase;
  final bool favorite;
  final bool sample;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final double textPadding;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final label = productSemantics(
      name: name,
      storeName: brand,
      priceSyp: priceSyp,
      priceIsEstimate: estimate,
      available: available,
      canPurchase: canPurchase,
      rating: rating,
    );
    final semantics = sample ? '$label، ${DooryStrings.demo}' : label;
    final showColors = (colorCount ?? 0) > 1;
    return Stack(
      children: [
        Material(
          color: scheme.surface,
          child: InkWell(
            onTap: onTap,
            splashColor: tokens.primarySubtle,
            highlightColor: tokens.primarySubtle,
            child: Semantics(
              button: true,
              label: semantics,
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Opacity(
                          opacity: available ? 1 : 0.5,
                          child: DooryImage(source: image),
                        ),
                        if (!available)
                          PositionedDirectional(
                            bottom: 8,
                            start: 8,
                            child: DooryBadge(
                              label: DooryStrings.soldOut,
                              tone: DooryBadgeTone.danger,
                            ),
                          ),
                        if (showColors)
                          PositionedDirectional(
                            bottom: 0,
                            end: 0,
                            child: ColorCountBadge(count: colorCount!),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.all(textPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                if (brand != null && brand!.isNotEmpty) ...[
                                  TextSpan(
                                    text: brand,
                                    style: DooryTypography.cardBrand(context),
                                  ),
                                  const TextSpan(text: ' '),
                                ],
                                TextSpan(
                                  text: name,
                                  style: DooryTypography.cardTitle(context),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (rating != null) ...[
                            const SizedBox(height: 4),
                            RatingRow(rating: rating, count: ratingCount),
                          ],
                          if (priceSyp != null) ...[
                            const SizedBox(height: 4),
                            PriceBlock(
                              priceSyp: priceSyp,
                              compareAtSyp: compareAtSyp,
                              estimate: estimate,
                            ),
                          ],
                          if (!available)
                            Text(
                              DooryStrings.soldOut,
                              style: DooryTypography.captionStrong(context)
                                  .copyWith(color: tokens.danger),
                            )
                          else if (!canPurchase)
                            Text(
                              DooryStrings.cannotPurchase,
                              style: DooryTypography.captionStrong(context)
                                  .copyWith(color: tokens.danger),
                            ),
                          if (sample) ...[
                            const SizedBox(height: 6),
                            const DemoLabel(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 4,
          end: 4,
          child: FavoriteButton(
            selected: favorite,
            enabled: onFavorite != null,
            onPressed: onFavorite ?? () {},
          ),
        ),
      ],
    );
  }
}

/// Horizontal-rail card. Width is fixed at 137 dp.
class ProductCardRail extends StatelessWidget {
  const ProductCardRail({
    required this.ref,
    required this.name,
    this.brand,
    this.image,
    this.priceSyp,
    this.compareAtSyp,
    this.estimate = false,
    this.rating,
    this.ratingCount,
    this.colorCount,
    this.available = true,
    this.canPurchase = true,
    this.favorite = false,
    this.sample = false,
    this.onTap,
    this.onFavorite,
    super.key,
  });

  final String ref;
  final String name;
  final String? brand;
  final String? image;
  final int? priceSyp;
  final int? compareAtSyp;
  final bool estimate;
  final double? rating;
  final int? ratingCount;
  final int? colorCount;
  final bool available;
  final bool canPurchase;
  final bool favorite;
  final bool sample;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 137,
      child: ProductCardVertical(
        ref: ref,
        name: name,
        brand: brand,
        image: image,
        priceSyp: priceSyp,
        compareAtSyp: compareAtSyp,
        estimate: estimate,
        rating: rating,
        ratingCount: ratingCount,
        colorCount: colorCount,
        available: available,
        canPurchase: canPurchase,
        favorite: favorite,
        sample: sample,
        onTap: onTap,
        onFavorite: onFavorite,
        textPadding: 6,
      ),
    );
  }
}
