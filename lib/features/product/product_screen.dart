import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/card_strings.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/pdp_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/product_shelf.dart';
import '../../core/widgets/social_proof_ticker.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/favorites/favorites_controller.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/commerce_models.dart';
import '../search/browsing_history.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../account/account_providers.dart';
import '../account/local_preferences.dart';
import '../cart/cart_controller.dart';
import '../store/store_screen.dart';
import 'add_to_cart.dart';
import 'pdp_mock.dart';
import 'pdp_sheets.dart';
import 'pdp_shipping_alerts.dart';
import 'pdp_widgets.dart';

/// Product detail page, laid out after Trendyol's PDP (40–49 captures):
/// search top bar, tall gallery, white blocks on a grey page, in-page
/// expanders and sheets, and a sticky price + «إضافة إلى السلة» bar.
///
/// Section order: gallery, special-code strip, title (price + ticker),
/// seller, campaigns («العروض المتوفرة»), expected delivery,
/// shipping-info card (shipping, commitments, returns), options,
/// price-drop and back-in-stock alerts, features, description,
/// questions, reviews, other sellers, same-store shelf, more.
///
/// Live data: `GET /products/{id}` via [productProvider] (name, photos,
/// price, options, store, category, rating, description, share link).
/// Everything else is labelled sample content tagged `BACKEND:`.
class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({required this.ref, this.card, super.key});

  final String ref;

  /// The card the shopper tapped, when they came from a list. Browsing
  /// history keeps its struck price, discount, and brand.
  final ProductCardModel? card;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  int? _historyId;
  int? _optionId;
  bool _scrolled = false;
  String? _city;

  ProductDetailModel? _product(RepoResult<ProductDetailModel>? result) {
    return switch (result) {
      RepoOk<ProductDetailModel>(:final data) => data,
      RepoUnavailable<ProductDetailModel>(:final sample) => sample,
      _ => null,
    };
  }

  ProductOptionModel? _selected(ProductDetailModel product) {
    if (product.options.isEmpty) return null;
    for (final option in product.options) {
      if (option.id == _optionId) return option;
    }
    // A single option is chosen for the shopper, as on Trendyol.
    return product.options.length == 1 ? product.options.first : null;
  }

  Future<void> _toggleFavorite(ProductDetailModel product, bool saved) async {
    // BACKEND: AVAILABLE POST /favorites, DELETE /favorites/{product_id} (auth; favorites stay on device for now)
    await ref.read(favoritesProvider.notifier).toggle(product.toCard());
    if (mounted) {
      showToast(
        context,
        saved ? ShopStrings.removedFromFavorites : ShopStrings.addedToFavorites,
      );
    }
  }

  Future<void> _addToCart(ProductDetailModel product) {
    return addProductToCart(
      context,
      ref,
      product,
      selectedId: _optionId,
      onOptionPicked: (id) {
        if (mounted) setState(() => _optionId = id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = parseProductRef(widget.ref);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(),
        body: StatusMessage(
          title: DooryStrings.notFoundProduct,
          actionLabel: DooryStrings.browseCategories,
          onAction: () => context.go('/categories'),
        ),
      );
    }
    final async = ref.watch(productProvider(id));
    final result = async.asData?.value;
    final product = _product(result);
    if (product != null && _historyId != product.id) {
      // Saved once per opened product, after the frame (a provider cannot
      // change while building).
      // BACKEND: AVAILABLE POST /products/{id}/view (not wired; history is local)
      _historyId = product.id;
      final entry = HistoryEntry.fromDetail(product, tapped: widget.card);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(browsingHistoryProvider.notifier).record(entry);
      });
    }
    final saved =
        product != null &&
        ref.watch(favoritesProvider).any((item) => item.id == product.id);

    return Scaffold(
      backgroundColor: DooryColors.surfaceSubtle,
      appBar: _PdpTopBar(
        product: product,
        saved: saved,
        showFavorite: _scrolled && product != null,
        onFavorite: product == null
            ? null
            : () => _toggleFavorite(product, saved),
      ),
      bottomNavigationBar: product == null
          ? null
          : _StickyBuyBar(
              product: product,
              option: _selected(product),
              onAdd: () => _addToCart(product),
            ),
      body: async.when(
        loading: () => const _PdpSkeleton(),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailableProduct,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(productProvider(id)),
        ),
        data: (result) {
          void retry() => ref.invalidate(productProvider(id));
          if (result is RepoNotFound<ProductDetailModel>) {
            return StatusMessage(
              title: DooryStrings.notFoundProduct,
              actionLabel: DooryStrings.browseCategories,
              onAction: () => context.go('/categories'),
            );
          }
          if (result case RepoRejected<ProductDetailModel>(:final message)) {
            return StatusMessage(
              title: message,
              actionLabel: DooryStrings.retry,
              onAction: retry,
            );
          }
          final product = _product(result);
          if (product == null) {
            return StatusMessage(
              title: DooryStrings.unavailableProduct,
              actionLabel: DooryStrings.retry,
              onAction: retry,
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.depth == 0) {
                final past = notification.metrics.pixels > 360;
                if (past != _scrolled) setState(() => _scrolled = past);
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async => retry(),
              child: _PdpBody(
                product: product,
                saved: saved,
                selected: _selected(product),
                city: _city,
                onFavorite: () => _toggleFavorite(product, saved),
                onOption: (value) => setState(() => _optionId = value),
                onCity: (value) => setState(() => _city = value),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PdpTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const _PdpTopBar({
    required this.product,
    required this.saved,
    required this.showFavorite,
    required this.onFavorite,
  });

  final ProductDetailModel? product;
  final bool saved;
  final bool showFavorite;
  final VoidCallback? onFavorite;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    return AppBar(
      toolbarHeight: 60,
      titleSpacing: 0,
      backgroundColor: DooryColors.surface,
      surfaceTintColor: Colors.transparent,
      leading: const BackButton(),
      title: _SearchPill(onTap: () => pushSearch(context)),
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: showFavorite
              ? IconButton(
                  key: const ValueKey('pdp-bar-favorite'),
                  tooltip: saved
                      ? DooryStrings.removeFavorite
                      : DooryStrings.addFavorite,
                  onPressed: onFavorite,
                  icon: Icon(
                    saved ? Icons.favorite : Icons.favorite_border,
                    color: saved ? DooryColors.primary : null,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        IconButton(
          tooltip: PdpStrings.share,
          onPressed: product == null
              ? null
              : () => showPdpShareSheet(
                  context,
                  url: product!.shareUrl,
                  name: product!.name,
                ),
          icon: const Icon(Icons.share_outlined),
        ),
        IconButton(
          tooltip: PdpStrings.cart,
          onPressed: () => context.go('/cart'),
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text(cartCount > 99 ? '99+' : '$cartCount'),
            backgroundColor: DooryColors.primary,
            textColor: DooryColors.textOnStrong,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        ),
        const SizedBox(width: 4),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: DooryColors.border),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      button: true,
      label: PdpStrings.searchHint,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: DooryColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: DooryColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  PdpStrings.searchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DooryTypography.label(context).copyWith(color: muted),
                ),
              ),
              // BACKEND: MISSING visual (image) search endpoint
              Icon(Icons.photo_camera_outlined, size: 20, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _PdpSkeleton extends StatelessWidget {
  const _PdpSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(aspectRatio: 4 / 5, child: SkeletonBox(height: 400)),
          Padding(
            padding: EdgeInsetsDirectional.all(16),
            child: Column(
              children: [
                SkeletonBox(height: 24),
                SizedBox(height: 8),
                SkeletonBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PdpBody extends ConsumerWidget {
  const _PdpBody({
    required this.product,
    required this.saved,
    required this.selected,
    required this.city,
    required this.onFavorite,
    required this.onOption,
    required this.onCity,
  });

  final ProductDetailModel product;
  final bool saved;
  final ProductOptionModel? selected;
  final String? city;
  final VoidCallback onFavorite;
  final ValueChanged<int> onOption;
  final ValueChanged<String> onCity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = product.description;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      children: [
        _GalleryBlock(product: product, saved: saved, onFavorite: onFavorite),
        const _SpecialCodeStrip(),
        _TitleBlock(product: product),
        _SellerBlock(product: product),
        const _CampaignsBlock(),
        _DeliveryBlock(city: city, onCity: onCity),
        const PdpShippingInfoCard(),
        if (product.options.isNotEmpty)
          _OptionsBlock(
            product: product,
            selected: selected,
            onOption: onOption,
          ),
        PdpAlertsCard(productId: product.id),
        // BACKEND: AVAILABLE GET /products/{id} → buyer_attributes (returned, not mapped)
        PdpExpandable(
          title: PdpStrings.featuresTitle,
          summary: _featuresSummary(),
          trailing: const Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: DemoLabel(),
          ),
          child: const _FeaturesTable(),
        ),
        if (description != null && description.isNotEmpty)
          PdpExpandable(
            title: PdpStrings.descriptionTitle,
            initiallyExpanded: true,
            child: PdpReadMore(text: description, trimLines: 4),
          ),
        _QuestionsBlock(sellerName: product.storeName),
        _ReviewsBlock(product: product),
        const _OtherSellersBlock(),
        if (product.storeSlug != null)
          // BACKEND: AVAILABLE GET /products/{id}/recommendations → similar, related, also_viewed (not wired; same-store shelf is live)
          _SameStore(slug: product.storeSlug!, productId: product.id),
        _MoreBlock(product: product),
      ],
    );
  }

  static String _featuresSummary() {
    final shown = PdpMock.attributes.take(2).map((e) => '${e.$1}: ${e.$2}');
    final more = PdpMock.attributes.length - 2;
    return '${shown.join('، ')}${more > 0 ? ' ...+$more' : ''}';
  }
}

class _GalleryBlock extends StatelessWidget {
  const _GalleryBlock({
    required this.product,
    required this.saved,
    required this.onFavorite,
  });

  final ProductDetailModel product;
  final bool saved;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DooryColors.surface,
      child: PdpGallery(
        // Photos stay on the server URLs from GET /products/{id}.
        urls: product.photoUrls,
        name: product.name,
        overlays: [
          // BACKEND: AVAILABLE GET /products/{id} → badges[{code,label}] (returned, not mapped); green top-start chip slot, as on Trendyol
          if (product.sample)
            const PositionedDirectional(top: 12, start: 12, child: DemoLabel()),
          PositionedDirectional(
            top: 8,
            end: 8,
            child: Column(
              children: [
                PdpRoundButton(
                  tooltip: saved
                      ? DooryStrings.removeFavorite
                      : DooryStrings.addFavorite,
                  icon: saved ? Icons.favorite : Icons.favorite_border,
                  color: saved ? DooryColors.primary : null,
                  onTap: onFavorite,
                ),
                const SizedBox(height: 8),
                PdpRoundButton(
                  tooltip: PdpStrings.share,
                  icon: Icons.share_outlined,
                  onTap: () => showPdpShareSheet(
                    context,
                    url: product.shareUrl,
                    name: product.name,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialCodeStrip extends StatelessWidget {
  const _SpecialCodeStrip();

  @override
  Widget build(BuildContext context) {
    const campaign = PdpMock.specialCode;
    // BACKEND: AVAILABLE GET /products/{id} → campaign_badge (returned, not mapped); countdown end time: MISSING
    return Material(
      color: DooryColors.primary,
      child: InkWell(
        onTap: () => showPdpCampaignSheet(context, campaign),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 12, 8),
          child: Row(
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                color: DooryColors.textOnStrong,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                PdpStrings.specialCode,
                style: DooryTypography.labelStrong(context)
                    .copyWith(color: DooryColors.textOnStrong),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  PdpStrings.endsIn(campaign.endsIn!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DooryTypography.label(context)
                      .copyWith(color: DooryColors.textOnStrong),
                ),
              ),
              const Icon(Icons.chevron_left, color: DooryColors.textOnStrong),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends ConsumerWidget {
  const _TitleBlock({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = product.averageRating;
    return PdpBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.sample) ...[const DemoLabel(), const SizedBox(height: 6)],
          Semantics(
            header: true,
            child: Text.rich(
              TextSpan(
                children: [
                  // BACKEND: AVAILABLE GET /products/{id} → brand_name, brand_verified (returned, not mapped; store name shown instead)
                  if (product.storeName != null)
                    TextSpan(
                      text: '${product.storeName} ',
                      style: DooryTypography.productTitle(context)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  TextSpan(
                    text: product.name,
                    style: DooryTypography.productTitle(context),
                  ),
                ],
              ),
            ),
          ),
          if (product.categoryName != null && product.categorySlug != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 4),
              child: InkWell(
                onTap: () => pushCategory(context, product.categorySlug!),
                child: Text(
                  product.categoryName!,
                  style: DooryTypography.label(context)
                      .copyWith(color: DooryColors.primary),
                ),
              ),
            ),
          if (rating != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _openReviews(context, ref, product),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: DooryTypography.labelStrong(context),
                    ),
                    const SizedBox(width: 4),
                    StarsRow(rating: rating.round(), size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        PdpStrings.ratingsCount(product.reviewsCount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DooryTypography.label(context),
                      ),
                    ),
                    const Icon(Icons.chevron_left, size: 18),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _PdpSocialProof(product: product)),
              const SizedBox(width: 8),
              const DemoLabel(),
            ],
          ),
          if (!product.available || !product.canPurchase) ...[
            const SizedBox(height: 8),
            Text(
              !product.available
                  ? DooryStrings.soldOut
                  : DooryStrings.cannotPurchase,
              style: DooryTypography.labelStrong(context)
                  .copyWith(color: DooryColors.danger),
            ),
          ],
        ],
      ),
    );
  }
}

/// Social-proof ticker on the product page: live views, then the sample
/// favorites count. Replaces the old static «1.2K+ من التفضيلات» line.
class _PdpSocialProof extends StatelessWidget {
  const _PdpSocialProof({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = DooryTypography.label(context);
    final viewers = product.viewers;
    return SocialProofTicker(
      style: style,
      iconColor: scheme.onSurfaceVariant,
      height: 20,
      messages: [
        // BACKEND: AVAILABLE `viewer_activity {count, window_hours}`
        // on GET /products/{id}.
        if (viewers != null)
          SocialProofMessage(
            icon: Icons.visibility_outlined,
            spans: [
              const TextSpan(text: CardStrings.viewersLead),
              TextSpan(
                text: '${viewers.count}',
                style: style.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: CardStrings.viewersTail(viewers.windowHours)),
            ],
          ),
        // BACKEND: MISSING per-product favorites count (no `favorites_count`
        // on GET /products/{id}). The number is sample data.
        SocialProofMessage(
          icon: Icons.favorite_border,
          color: DooryColors.backendMissing,
          spans: [
            TextSpan(
              text: CardStrings.favoritedBy(CardStrings.sampleFavoritesCount),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> _openReviews(
  BuildContext context,
  WidgetRef ref,
  ProductDetailModel product,
) async {
  // BACKEND: AVAILABLE GET /products/{id}/reviews (reviews come from the mock engagement repository today)
  final reviews = await ref.read(productReviewsProvider(product.id).future);
  if (!context.mounted) return;
  await showPdpReviewsSheet(
    context,
    reviews: reviews,
    averageRating: product.averageRating,
    reviewsCount: product.reviewsCount,
  );
}

class _DeliveryBlock extends StatelessWidget {
  const _DeliveryBlock({required this.city, required this.onCity});

  final String? city;
  final ValueChanged<String> onCity;

  @override
  Widget build(BuildContext context) {
    return PdpBlock(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_available_outlined,
                color: DooryColors.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city == null
                          ? PdpStrings.expectedDelivery
                          : PdpStrings.deliverTo(city!),
                      style: DooryTypography.labelStrong(context),
                    ),
                    // BACKEND: MISSING delivery date estimate per product/city
                    // (`buyer_delivery_rows` has labels only).
                    Text(
                      PdpMock.expectedDelivery,
                      style: DooryTypography.label(context)
                          .copyWith(color: DooryColors.backendMissing),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: DooryColors.primary,
                  side: const BorderSide(color: DooryColors.primary),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(44, 36),
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                  ),
                ),
                onPressed: () async {
                  final picked = await showPdpCitySheet(context, city);
                  if (picked != null) onCity(picked);
                },
                icon: const Icon(Icons.location_on_outlined, size: 18),
                label: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 110),
                  child: Text(
                    city ?? PdpStrings.chooseAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: DooryColors.success,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  PdpStrings.fastDelivery,
                  style: DooryTypography.label(context),
                ),
              ),
              const DemoLabel(),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignsBlock extends StatelessWidget {
  const _CampaignsBlock();

  @override
  Widget build(BuildContext context) {
    return PdpBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    PdpStrings.campaignsTitle,
                    style: DooryTypography.section(context).copyWith(
                      fontSize: 16,
                      height: 20 / 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const DemoLabel(),
            ],
          ),
          const SizedBox(height: 8),
          // BACKEND: AVAILABLE GET /products/{id} → campaign_badge (one campaign); multiple campaigns: MISSING
          for (final campaign in PdpMock.campaigns)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8),
              child: InkWell(
                onTap: () => showPdpCampaignSheet(context, campaign),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 8, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: DooryColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: DooryColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.local_offer_outlined,
                          size: 18,
                          color: DooryColors.textOnStrong,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              campaign.title,
                              style: DooryTypography.labelStrong(context),
                            ),
                            Text(
                              campaign.endsIn != null
                                  ? PdpStrings.endsIn(campaign.endsIn!)
                                  : PdpStrings.appliedAtCheckout,
                              style: DooryTypography.cardMeta(
                                context,
                                color: DooryColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_left),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionsBlock extends StatelessWidget {
  const _OptionsBlock({
    required this.product,
    required this.selected,
    required this.onOption,
  });

  final ProductDetailModel product;
  final ProductOptionModel? selected;
  final ValueChanged<int> onOption;

  @override
  Widget build(BuildContext context) {
    final options = product.options;
    final first = selected ?? options.first;
    return PdpBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PdpHeader(
            title: PdpStrings.optionsTitle,
            trailing: Text(
              PdpStrings.optionsAvailable(options.length),
              style: DooryTypography.label(context),
            ),
          ),
          const SizedBox(height: 10),
          PdpOptionBoxes(
            options: options,
            selectedId: selected?.id,
            onSelect: onOption,
          ),
          if (options.length > 1) ...[
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final picked = await showPdpVariantSheet(
                  context,
                  product: product,
                  selectedId: selected?.id,
                );
                if (picked != null) onOption(picked);
              },
              child: Container(
                height: 48,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: DooryColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected?.label ??
                            PdpStrings.chooseOption(
                              first.label,
                              options.length - 1,
                            ),
                        style: DooryTypography.label(context),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FeaturesTable extends StatelessWidget {
  const _FeaturesTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < PdpMock.attributes.length; i++)
          Container(
            color: i.isEven ? DooryColors.surfaceSubtle : DooryColors.surface,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    PdpMock.attributes[i].$1,
                    style: DooryTypography.label(context),
                  ),
                ),
                Expanded(
                  child: Text(
                    PdpMock.attributes[i].$2,
                    style: DooryTypography.labelStrong(context),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SellerBlock extends ConsumerWidget {
  const _SellerBlock({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = product.storeName;
    final slug = product.storeSlug;
    if (name == null) return const SizedBox.shrink();
    final followKey = slug ?? '${product.storeId}';
    final following = ref
        .watch(localIdSetProvider(followedStoresKey))
        .contains(followKey);
    return PdpBlock(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: DooryColors.primarySubtle,
            child: Text(
              name.characters.first,
              style: DooryTypography.section(context)
                  .copyWith(color: DooryColors.primary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: slug == null ? null : () => pushStore(context, slug),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DooryTypography.labelStrong(context),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // BACKEND: AVAILABLE GET /products/{id} → store.average_rating (returned, not mapped)
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: DooryColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          PdpMock.sellerScore,
                          style: DooryTypography.cardMeta(
                            context,
                            color: DooryColors.textOnStrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // BACKEND: AVAILABLE GET /products/{id} → store.followers_count (returned, not mapped)
                  Text(
                    PdpStrings.followers(PdpMock.sellerFollowers),
                    style: DooryTypography.cardMeta(context),
                  ),
                ],
              ),
            ),
          ),
          // BACKEND: AVAILABLE POST/DELETE /stores/{slug}/follow (auth; follow kept on device)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: following
                  ? DooryColors.textSecondary
                  : DooryColors.primary,
              side: BorderSide(
                color: following ? DooryColors.border : DooryColors.primary,
              ),
              minimumSize: const Size(72, 36),
            ),
            onPressed: () async {
              final now = await ref
                  .read(localIdSetProvider(followedStoresKey).notifier)
                  .toggle(followKey);
              if (context.mounted) {
                showToast(
                  context,
                  now ? PdpStrings.followedOnDevice : PdpStrings.unfollowed,
                );
              }
            },
            child: Text(following ? PdpStrings.following : PdpStrings.follow),
          ),
        ],
      ),
    );
  }
}

class _QuestionsBlock extends StatelessWidget {
  const _QuestionsBlock({required this.sellerName});

  final String? sellerName;

  @override
  Widget build(BuildContext context) {
    // BACKEND: AVAILABLE GET /products/{id}/questions (not wired; sample questions)
    const questions = PdpMock.questions;
    return PdpBlock(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 14, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: PdpHeader(
              title: PdpStrings.questionsTitle,
              trailing: const DemoLabel(),
              actionLabel: PdpStrings.all(PdpMock.questionsTotal),
              onAction: () => showPdpQuestionsSheet(
                context,
                questions: questions,
                sellerName: sellerName,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              itemCount: questions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) => SingleChildScrollView(
                child: PdpQuestionCard(
                  question: questions[index],
                  sellerName: sellerName,
                  width: 280,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: () => showPdpAskSheet(context),
              icon: const Icon(Icons.help_outline),
              label: const Text(PdpStrings.askQuestion),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsBlock extends ConsumerWidget {
  const _ReviewsBlock({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // BACKEND: AVAILABLE GET /products/{id}/reviews (+ reviews_distribution on GET /products/{id}); list comes from the mock engagement repository
    final async = ref.watch(productReviewsProvider(product.id));
    final reviews = async.asData?.value ?? const <Review>[];
    final rating = product.averageRating;
    return PdpBlock(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 14, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: PdpHeader(
              title: PdpStrings.reviewsTitle,
              trailing: const DemoLabel(),
              actionLabel: PdpStrings.all(product.reviewsCount),
              onAction: () => _openReviews(context, ref, product),
            ),
          ),
          if (rating != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
              child: Row(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: DooryTypography.page(context),
                  ),
                  const SizedBox(width: 6),
                  StarsRow(rating: rating.round(), size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      PdpStrings.ratingsCount(product.reviewsCount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DooryTypography.label(context),
                    ),
                  ),
                ],
              ),
            ),
          if (async.isLoading)
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: LinearProgressIndicator(),
            )
          else if (reviews.isEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: Text(
                ShopStrings.noReviews,
                style: DooryTypography.label(context),
              ),
            )
          else
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                itemCount: reviews.length.clamp(0, 6),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => _openReviews(context, ref, product),
                  child: PdpReviewCard(review: reviews[index], width: 260),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: TextButton.icon(
              // BACKEND: AVAILABLE POST /orders/{public_id}/product-reviews (auth; review after delivery)
              onPressed: () =>
                  showNotWired(context, feature: ShopStrings.reviewFeature),
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text(ShopStrings.writeReview),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherSellersBlock extends StatelessWidget {
  const _OtherSellersBlock();

  @override
  Widget build(BuildContext context) {
    return PdpBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PdpHeader(
            title: PdpStrings.otherSellersTitle,
            trailing: DemoLabel(),
          ),
          const SizedBox(height: 8),
          // BACKEND: MISSING other sellers / offers for the same product
          for (final seller in PdpMock.otherSellers)
            Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DooryColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                seller.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: DooryTypography.labelStrong(context),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: DooryColors.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                seller.score,
                                style: DooryTypography.cardMeta(
                                  context,
                                  color: DooryColors.textOnStrong,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          seller.delivery,
                          style: DooryTypography.cardMeta(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatSyp(seller.priceSyp),
                          style: DooryTypography.compactPrice(context)
                              .copyWith(color: DooryColors.primary),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => showNotWired(
                      context,
                      feature: PdpStrings.otherSellersTitle,
                    ),
                    child: const Text(PdpStrings.view),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MoreBlock extends StatelessWidget {
  const _MoreBlock({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    return PdpBlock(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
      child: Column(
        children: [
          if (product.storeSlug != null)
            ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: const Text(PdpStrings.viewStore),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => pushStore(context, product.storeSlug!),
            ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text(ShopStrings.reportListing),
            trailing: const Icon(Icons.chevron_left),
            // BACKEND: AVAILABLE POST /abuse-reports (auth; not wired)
            onTap: () =>
                showNotWired(context, feature: ShopStrings.reportFeature),
          ),
        ],
      ),
    );
  }
}

/// Sticky bottom bar: price on the start side, orange add-to-cart at the end.
class _StickyBuyBar extends ConsumerWidget {
  const _StickyBuyBar({
    required this.product,
    required this.option,
    required this.onAdd,
  });

  final ProductDetailModel product;
  final ProductOptionModel? option;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionBlocks = option != null && !option!.available;
    final canPurchase =
        product.available && product.canPurchase && !optionBlocks;
    final price = product.priceSyp;
    return Material(
      color: DooryColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: DooryColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BACKEND: AVAILABLE GET /products/{id} → compare_at_syp, discount_percent, options[].price_syp (returned, not mapped)
                      if (price != null)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            formatSyp(price),
                            style: DooryTypography.pdpPrice(context)
                                .copyWith(color: DooryColors.primary),
                          ),
                        ),
                      if (product.priceIsEstimate)
                        Text(
                          DooryStrings.estimate,
                          style: DooryTypography.cardMeta(context),
                        )
                      else if (option != null)
                        Text(
                          option!.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DooryTypography.cardMeta(context),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: product.available
                      ? FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: DooryColors.primary,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: canPurchase ? onAdd : null,
                          child: Text(
                            canPurchase
                                ? PdpStrings.addToCart
                                : PdpStrings.unavailable,
                          ),
                        )
                      : OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          // BACKEND: AVAILABLE POST /product-watches
                          // {product_id, back_in_stock} (auth). On-device only.
                          onPressed: () =>
                              toggleStockWatch(context, ref, product.id),
                          icon: const Icon(Icons.notifications_active_outlined),
                          label: const Text(PdpStrings.notifyMe),
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

class _SameStore extends ConsumerWidget {
  const _SameStore({required this.slug, required this.productId});

  final String slug;
  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(storeProvider(slug));
    final result = async.asData?.value;
    if (result == null) return const SizedBox.shrink();
    final store = switch (result) {
      RepoOk<StoreModel>(:final data) => data,
      RepoUnavailable<StoreModel>(:final sample) => sample,
      _ => null,
    };
    if (store == null) return const SizedBox.shrink();
    final others = [
      for (final item in store.products)
        if (item.id != productId) item,
    ];
    if (others.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: DooryColors.surface,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: ProductShelf(
        title: PdpStrings.similarTitle,
        products: others,
        sample: store.sample,
        onViewAll: () => pushStore(context, slug),
      ),
    );
  }
}
