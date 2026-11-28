import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites/favorites_controller.dart';
import '../../data/models/catalog_models.dart';
import '../format/price_format.dart';
import '../l10n/card_strings.dart';
import '../l10n/doory_strings.dart';
import '../routing/nav.dart';
import '../theme/doory_colors.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'chrome.dart';

/// Fixed proportions of [ProductCard], measured from the Trendyol captures
/// (`trendyol-ref/screens/13-listing`, `02-home-scroll1`; 1080×2400 px):
///
/// - Listing: two cards per row, each 0.471 of the screen width, 0.02 gaps and
///   margins, card height ≈ 0.45 of the screen height.
/// - Home shelf: each card ≈ 0.33 of the screen width with a 0.02 gap, so
///   2.7–2.8 cards are visible and the next one is cut off; card height
///   ≈ 0.79 of the shelf width with a 2:3 photo.
///
/// The photo is 2:3, matching Trendyol's listing cards (`13-listing`).
abstract final class ProductCardMetrics {
  /// Photo width ÷ height (Trendyol listing).
  static const imageAspect = 2 / 3;

  /// Largest text scale the card honours; its rows are fixed-height lines.
  static const maxTextScale = 1.3;

  static double scaleOf(BuildContext context) =>
      MediaQuery.textScalerOf(context)
          .scale(1)
          .clamp(1.0, maxTextScale)
          .toDouble();

  /// Height of the text block under the photo. Fixed paddings and gaps are
  /// 16 (6 top + 4 bottom + three 2 gaps); the rows scale with the text:
  /// title 2×16 + rating 14 + tag 14 + price 18 = 78.
  /// That is 94 at 1× text scale. The categories listing adds a 14 dp
  /// favorites row and one 2 dp gap (110 at 1×).
  static double textBlockHeight(
    double textScale, {
    bool showFavorites = false,
  }) {
    final gaps = showFavorites ? 18.0 : 16.0;
    final rows = showFavorites ? 92.0 : 78.0;
    return gaps + rows * textScale;
  }

  /// Space between cards and around a shelf or grid (Trendyol: 0.02 × width).
  static const gap = 8.0;

  /// Shelf card width as a share of the shelf width.
  static const shelfWidthFactor = 0.335;

  /// Horizontal text padding (start + end) of the details block.
  static const textPaddingX = 8.0;

  /// Shelf card width. At 1	imes text this is [shelfWidthFactor] of the shelf
  /// (about 2.75 cards visible). At a larger text scale the card grows just
  /// enough that the badge and the full current price still fit; the struck
  /// old price yields.
  static double shelfCardWidth(double shelfWidth, double textScale) {
    final preferred = (shelfWidth * shelfWidthFactor)
        .clamp(112.0, 176.0)
        .toDouble();
    if (textScale <= 1.0) return preferred;
    // Badge (~32) + gap (3) + a 6-digit SYP price with currency (~80) at 1	imes.
    final minWidth = textPaddingX + 115 * textScale;
    final maxWidth = shelfWidth - gap < 112 ? 112.0 : shelfWidth - gap;
    if (preferred >= minWidth) return preferred;
    return minWidth.clamp(112.0, maxWidth).toDouble();
  }

  static double cardHeight(
    double width,
    double textScale, {
    bool showFavorites = false,
  }) =>
      width / imageAspect +
      textBlockHeight(textScale, showFavorites: showFavorites);
}

/// One 14 dp line of the text block, scaled with the text.
double _row(BuildContext context) => 14 * ProductCardMetrics.scaleOf(context);

/// Trendyol-style product card. Information order follows Doory's web card:
/// image → seller + title → (listing: favorites count) → rating → net-discount tag → price.
///
/// Pieces the server does not send yet are drawn in
/// [DooryColors.backendMissing] so they stand out in review
/// (see BACKEND_HOOKS.md → Product card).
class ProductCard extends ConsumerWidget {
  const ProductCard({
    required this.product,
    this.width,
    this.showFavorites = false,
    super.key,
  });

  final ProductCardModel product;
  final double? width;

  /// Categories listing only: a favorites count under the title.
  final bool showFavorites;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final saved = ref
        .watch(favoritesProvider)
        .any((item) => item.id == product.id);

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
          _ImageWell(product: product, saved: saved),
          Expanded(
            child: Semantics(
              button: true,
              label: _semantics(product),
              child: InkWell(
                onTap: () => pushProduct(context, product.ref, card: product),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(4, 6, 4, 4),
                  child: ExcludeSemantics(
                    child: MediaQuery.withClampedTextScaling(
                      maxScaleFactor: ProductCardMetrics.maxTextScale,
                      child: _Details(
                        product: product,
                        showFavorites: showFavorites,
                      ),
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

String _semantics(ProductCardModel product) {
  final base = productSemantics(
    name: product.name,
    storeName: product.sellerLabel,
    priceSyp: product.priceSyp,
    priceIsEstimate: product.priceIsEstimate,
    available: product.available,
    canPurchase: product.canPurchase,
    rating: product.averageRating,
  );
  if (!product.hasDiscount) return base;
  return '$base، ${CardStrings.instead(formatSyp(product.compareAtSyp!), product.discountPercent!)}';
}

/// Card text sizes: Trendyol's listing text is ≈ 12 sp on a 390 dp screen.
TextStyle _meta(BuildContext context, {Color? color}) =>
    DooryTypography.cardMeta(
      context,
      color: color,
    ).copyWith(fontSize: 11, height: 14 / 11);

TextStyle _title(BuildContext context, {bool bold = false}) =>
    (bold
            ? DooryTypography.cardBrand(context)
            : DooryTypography.cardTitle(context))
        .copyWith(fontSize: 12, height: 16 / 12);

class _ImageWell extends StatelessWidget {
  const _ImageWell({required this.product, required this.saved});

  final ProductCardModel product;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: ProductCardMetrics.imageAspect,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            // BACKEND: AVAILABLE `photo` (card.webp) on every card payload.
            child: _Photo(url: product.photoUrl, name: product.name),
          ),
        ),
        PositionedDirectional(
          top: 0,
          end: 0,
          child: _FavoriteButton(product: product, saved: saved),
        ),
        if (product.sample)
          const PositionedDirectional(top: 6, start: 6, child: DemoLabel()),
        if (product.badgeLabels.isNotEmpty)
          PositionedDirectional(
            bottom: 4,
            start: 4,
            // BACKEND: AVAILABLE `badges[].label` (GET /products, /home latest).
            child: _ImageBadge(label: product.badgeLabels.first),
          ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product, this.showFavorites = false});

  final ProductCardModel product;
  final bool showFavorites;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final rating = product.averageRating;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleLine(product: product),
        if (showFavorites) ...[
          const SizedBox(height: 2),
          _FavoritesCountLine(product: product),
        ],
        const SizedBox(height: 2),
        // Sold-out / unpurchasable takes the rating row so the block height
        // stays fixed after the views line was removed.
        if (!product.available)
          _StatusLine(text: DooryStrings.soldOut, color: tokens.danger)
        else if (!product.canPurchase)
          _StatusLine(text: DooryStrings.cannotPurchase, color: tokens.danger)
        else if (rating != null)
          _RatingRow(value: rating, count: product.reviewsCount)
        else
          SizedBox(height: _row(context)),
        const SizedBox(height: 2),
        const _NetDiscountLine(),
        const Spacer(),
        _PriceRow(product: product),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _row(context),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _meta(context, color: color),
      ),
    );
  }
}

/// «دار المونة ✓ زيت زيتون، 1 لتر» — seller in bold, then the title, 2 lines.
class _TitleLine extends StatelessWidget {
  const _TitleLine({required this.product});

  final ProductCardModel product;

  @override
  Widget build(BuildContext context) {
    // BACKEND: AVAILABLE `brand_name` + `brand_verified`; `store_name` fallback.
    final seller = product.sellerLabel;
    final verified = product.brandName != null && product.brandVerified;
    return Text.rich(
      TextSpan(
        style: _title(context),
        children: [
          if (seller != null) ...[
            TextSpan(text: seller, style: _title(context, bold: true)),
            if (verified)
              WidgetSpan(
                alignment: PlaceholderAlignment.aboveBaseline,
                baseline: TextBaseline.alphabetic,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 2),
                  child: Icon(
                    Icons.verified,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary,
                    semanticLabel: CardStrings.verified,
                  ),
                ),
              ),
            const TextSpan(text: ' '),
          ],
          // BACKEND: AVAILABLE `name`.
          TextSpan(text: product.name, style: _title(context)),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// «4.5 ★★★★☆ (4) 📷».
class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.value, required this.count});

  final double value;
  final int count;

  @override
  Widget build(BuildContext context) {
    final meta = _meta(context, color: Theme.of(context).colorScheme.onSurface);
    return SizedBox(
      height: _row(context),
      child: Row(
        children: [
          // BACKEND: AVAILABLE `average_rating`.
          Flexible(
            child: Text(
              value.toStringAsFixed(1),
              style: meta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 2),
          _Stars(value: value),
          if (count > 0) ...[
            const SizedBox(width: 2),
            // BACKEND: AVAILABLE `reviews_count`.
            Flexible(
              child: Text(
                CardStrings.reviewCount(count),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _meta(context),
              ),
            ),
          ],
          const SizedBox(width: 3),
          // BACKEND: MISSING photo-review flag/count per product (reviews carry
          // no buyer photos; `product_image_url` is the catalog photo).
          const Icon(
            Icons.photo_camera_outlined,
            size: 12,
            color: DooryColors.backendMissing,
            semanticLabel: CardStrings.photoReviews,
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final filled = DooryTokens.of(context).rating;
    final empty = Theme.of(context).colorScheme.outline;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          SizedBox.square(
            dimension: 10,
            child: Stack(
              children: [
                Icon(Icons.star, size: 10, color: empty),
                ClipRect(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: (value - i).clamp(0.0, 1.0),
                    child: Icon(Icons.star, size: 10, color: filled),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Heart + count, above the price. Hidden when the server sends 0.
class _FavoritesCountLine extends StatelessWidget {
  const _FavoritesCountLine({required this.product});

  final ProductCardModel product;

  static const countKey = ValueKey<String>('card-favorites-count');

  @override
  Widget build(BuildContext context) {
    final real = product.favoritesCount;
    final height = _row(context);
    // Zero hides the heart and count but keeps the 14 dp slot so every
    // listing card stays the same height.
    if (real == 0) {
      return SizedBox(key: countKey, height: height);
    }
    // BACKEND: MISSING `favorites_count` on GET /products, /home, /search
    // (only `is_favorited` is returned). Sample 1247 is shown in red.
    final count = real ?? CardStrings.sampleListingFavoritesCount;
    final color = real == null
        ? DooryColors.backendMissing
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      key: countKey,
      height: height,
      child: Row(
        children: [
          Icon(Icons.favorite, size: 12, color: color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              formatCompactCount(count),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _meta(
                context,
                color: color,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// «خصم صافٍ» — the web card's tag line, without a percent (the badge
/// on the price row already shows it).
class _NetDiscountLine extends StatelessWidget {
  const _NetDiscountLine();

  @override
  Widget build(BuildContext context) {
    // BACKEND: MISSING per-card promo / net-discount tag text.
    return SizedBox(
      height: _row(context),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 12,
            color: DooryColors.backendMissing,
          ),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              CardStrings.netDiscountPlaceholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _meta(context, color: DooryColors.backendMissing),
            ),
          ),
        ],
      ),
    );
  }
}

/// RTL reading order: «-20%» badge, then «54,000 ل.س», then ~~67,500~~.
class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final ProductCardModel product;

  @override
  Widget build(BuildContext context) {
    final amount = product.priceSyp;
    final priceHeight = 18 * ProductCardMetrics.scaleOf(context);
    if (amount == null) return SizedBox(height: priceHeight);
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final priceStyle = DooryTypography.cardPrice(context).copyWith(
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w700,
      color: DooryColors.cardPrice,
    );
    return SizedBox(
      height: priceHeight,
      child: Row(
        children: [
          if (product.hasDiscount) ...[
            // BACKEND: AVAILABLE `discount_percent`. First in RTL, so it sits
            // at the inline start (right).
            DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.primarySubtle,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 3),
                child: Text(
                  CardStrings.discountBadge(product.discountPercent!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _meta(context, color: scheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 3),
          ],
          // BACKEND: AVAILABLE `price_syp` (+ `price_is_estimate`).
          // The current price always shows in full; the struck old price
          // yields if the row is tight.
          Text(formatSyp(amount), maxLines: 1, style: priceStyle),
          if (product.hasDiscount) ...[
            const SizedBox(width: 3),
            // BACKEND: AVAILABLE `compare_at_syp` (digits only, as on the web
            // card; the currency is on the current price).
            Flexible(
              child: Text(
                formatSypDigits(product.compareAtSyp!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _meta(context, color: DooryColors.textSecondary)
                    .copyWith(
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: DooryColors.textSecondary,
                    ),
              ),
            ),
          ],
          if (product.priceIsEstimate) ...[
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                DooryStrings.estimate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _meta(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 5,
          vertical: 1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DooryTypography.shortcut(context)
              .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
    );
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
      return Center(child: Icon(Icons.image_outlined, color: muted, size: 28));
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 200),
      memCacheWidth: 360,
      placeholder: (context, _) => const SkeletonBox(height: double.infinity),
      errorWidget: (context, _, _) =>
          Center(child: Icon(Icons.image_outlined, color: muted, size: 28)),
    );
  }
}

/// Heart on a white circle at the image's inline end (Trendyol). 44 dp target.
class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.product, required this.saved});

  final ProductCardModel product;
  final bool saved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    // BACKEND: AVAILABLE `is_favorited` + POST/DELETE /favorites (auth).
    // Not wired: favorites stay on the device until auth lands.
    return IconButton(
      tooltip: saved ? DooryStrings.removeFavorite : DooryStrings.addFavorite,
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(product),
      icon: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: DooryColors.shadowFavorite, blurRadius: 3),
          ],
        ),
        child: SizedBox.square(
          dimension: 26,
          child: Icon(
            saved ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: saved ? tokens.danger : scheme.onSurfaceVariant,
          ),
        ),
      ),
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
