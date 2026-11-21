import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/price_text.dart';
import '../../core/widgets/product_shelf.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/favorites/favorites_controller.dart';
import '../../data/mock/mock_fixtures.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../account/account_providers.dart';
import '../account/local_preferences.dart';
import '../auth/session_controller.dart';
import '../cart/cart_controller.dart';
import '../store/store_screen.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({required this.ref, super.key});

  final String ref;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  int _quantity = 1;
  int? _optionId;
  bool _pinned = false;

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
    final cartCount = ref.watch(cartCountProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(DooryStrings.appName),
        actions: [
          IconButton(
            tooltip: DooryStrings.tabCart,
            onPressed: () => context.go('/cart'),
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              backgroundColor: DooryColors.primaryStrong,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Padding(
          padding: EdgeInsetsDirectional.all(16),
          child: Column(
            children: [
              SkeletonBox(height: 280),
              SizedBox(height: 16),
              SkeletonBox(height: 28),
              SizedBox(height: 8),
              SkeletonBox(height: 48),
            ],
          ),
        ),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailableProduct,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(productProvider(id)),
        ),
        data: (result) => _ProductBody(
          result: result,
          quantity: _quantity,
          optionId: _optionId,
          pinned: _pinned,
          onQuantity: (value) => setState(() => _quantity = value),
          onOption: (value) => setState(() => _optionId = value),
          onPinned: (value) {
            if (value != _pinned) setState(() => _pinned = value);
          },
          onRetry: () => ref.invalidate(productProvider(id)),
        ),
      ),
    );
  }
}

class _ProductBody extends ConsumerWidget {
  const _ProductBody({
    required this.result,
    required this.quantity,
    required this.optionId,
    required this.pinned,
    required this.onQuantity,
    required this.onOption,
    required this.onPinned,
    required this.onRetry,
  });

  final RepoResult<ProductDetailModel> result;
  final int quantity;
  final int? optionId;
  final bool pinned;
  final ValueChanged<int> onQuantity;
  final ValueChanged<int> onOption;
  final ValueChanged<bool> onPinned;
  final VoidCallback onRetry;

  CartLineDraft _draft(ProductDetailModel product, ProductOptionModel? option) {
    return CartLineDraft(
      product: product.toCard(),
      quantity: quantity,
      optionId: option?.id,
      optionLabel: option?.label,
      storeId: product.storeId,
    );
  }

  Future<void> _addToCart(
    BuildContext context,
    WidgetRef ref,
    ProductDetailModel product,
    ProductOptionModel? option,
  ) async {
    await ref.read(cartProvider.notifier).add(_draft(product, option));
    if (!context.mounted) return;
    showToast(
      context,
      ShopStrings.addedToCart(quantity),
      actionLabel: ShopStrings.viewCart,
      onAction: () => context.go('/cart'),
    );
  }

  Future<void> _buyNow(
    BuildContext context,
    WidgetRef ref,
    ProductDetailModel product,
    ProductOptionModel? option,
  ) async {
    await ref.read(cartProvider.notifier).add(_draft(product, option));
    if (!context.mounted) return;
    final signedIn = ref.read(sessionProvider).signedIn;
    context.push(signedIn ? '/checkout' : '/login?next=/checkout');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = switch (result) {
      RepoOk<ProductDetailModel>(:final data) => data,
      RepoUnavailable<ProductDetailModel>(:final sample) => sample,
      _ => null,
    };
    if (result is RepoNotFound<ProductDetailModel> ||
        (result is RepoUnavailable<ProductDetailModel> && product == null)) {
      final missing = result is RepoNotFound<ProductDetailModel>;
      return StatusMessage(
        title: missing
            ? DooryStrings.notFoundProduct
            : DooryStrings.unavailableProduct,
        actionLabel: missing
            ? DooryStrings.browseCategories
            : DooryStrings.retry,
        onAction: missing ? () => context.go('/categories') : onRetry,
      );
    }
    if (result case RepoRejected<ProductDetailModel>(:final message)) {
      return StatusMessage(
        title: message,
        actionLabel: DooryStrings.retry,
        onAction: onRetry,
      );
    }
    if (product == null) {
      return StatusMessage(
        title: DooryStrings.unavailableProduct,
        actionLabel: DooryStrings.retry,
        onAction: onRetry,
      );
    }

    final selected = product.options.cast<ProductOptionModel?>().firstWhere(
      (option) => option!.id == optionId,
      orElse: () => product.options.isEmpty ? null : product.options.first,
    );
    final optionBlocks = selected != null && !selected.available;
    final canPurchase =
        product.available && product.canPurchase && !optionBlocks;
    final saved = ref
        .watch(favoritesProvider)
        .any((item) => item.id == product.id);
    final watching = ref
        .watch(localIdSetProvider(priceWatchesKey))
        .contains('${product.id}');
    final danger = DooryTokens.of(context).danger;

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            onPinned(notification.metrics.pixels > 420);
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async => onRetry(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsetsDirectional.only(bottom: 96),
              children: [
                if (product.sample)
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: DemoLabel(),
                  ),
                _Breadcrumb(product: product),
                Stack(
                  children: [
                    _Gallery(urls: product.photoUrls, name: product.name),
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: Column(
                        children: [
                          _RoundAction(
                            tooltip: saved
                                ? DooryStrings.removeFavorite
                                : DooryStrings.addFavorite,
                            icon: saved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: saved ? DooryColors.primaryStrong : null,
                            onTap: () async {
                              await ref
                                  .read(favoritesProvider.notifier)
                                  .toggle(product.toCard());
                              if (context.mounted) {
                                showToast(
                                  context,
                                  saved
                                      ? ShopStrings.removedFromFavorites
                                      : ShopStrings.addedToFavorites,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          if (product.shareUrl != null)
                            _RoundAction(
                              tooltip: DooryStrings.copyLink,
                              icon: Icons.share_outlined,
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: product.shareUrl!),
                                );
                                if (context.mounted) {
                                  showToast(context, DooryStrings.linkCopied);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.storeName != null)
                        InkWell(
                          onTap: product.storeSlug == null
                              ? null
                              : () => pushStore(context, product.storeSlug!),
                          child: Text(
                            product.storeName!,
                            style: DooryTypography.cardBrand(context),
                          ),
                        ),
                      Semantics(
                        header: true,
                        child: Text(
                          product.name,
                          style: DooryTypography.productTitle(context),
                        ),
                      ),
                      if (product.averageRating != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            StarsRow(
                              rating: product.averageRating!.round(),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${product.averageRating!.toStringAsFixed(1)}'
                              '${product.reviewsCount > 0 ? ' (${product.reviewsCount})' : ''}',
                              style: DooryTypography.label(context),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      PriceText(
                        amount: product.priceSyp,
                        estimate: product.priceIsEstimate,
                        style: PriceStyle.pdp,
                      ),
                      if (!product.available)
                        Text(
                          DooryStrings.soldOut,
                          style: DooryTypography.labelStrong(context)
                              .copyWith(color: danger),
                        )
                      else if (!product.canPurchase)
                        Text(
                          DooryStrings.cannotPurchase,
                          style: DooryTypography.labelStrong(context)
                              .copyWith(color: danger),
                        ),
                      if (product.options.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          DooryStrings.variants,
                          style: DooryTypography.labelStrong(context),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final option in product.options)
                              ChoiceChip(
                                label: Text(
                                  option.lowStock
                                      ? '${option.label} · ${DooryStrings.lowStock}'
                                      : option.available
                                      ? option.label
                                      : '${option.label} · ${DooryStrings.soldOut}',
                                ),
                                selected:
                                    (selected?.id ?? optionId) == option.id,
                                onSelected: option.available
                                    ? (_) => onOption(option.id)
                                    : null,
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            DooryStrings.quantity,
                            style: DooryTypography.labelStrong(context),
                          ),
                          const SizedBox(width: 16),
                          QuantityStepper(
                            value: quantity,
                            onChanged: onQuantity,
                          ),
                          const Spacer(),
                          if (product.priceSyp != null && quantity > 1)
                            Text(
                              formatSyp(product.priceSyp! * quantity),
                              style: DooryTypography.compactPrice(context),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DooryPrimaryButton(
                        label: DooryStrings.addToCart,
                        icon: Icons.add_shopping_cart,
                        onPressed: canPurchase
                            ? () => _addToCart(context, ref, product, selected)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      DooryOutlineButton(
                        label: DooryStrings.buyNow,
                        onPressed: canPurchase
                            ? () => _buyNow(context, ref, product, selected)
                            : null,
                      ),
                      if (!product.available) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => showNotWired(
                            context,
                            feature: ShopStrings.backInStockFeature,
                          ),
                          icon: const Icon(Icons.notifications_active_outlined),
                          label: const Text(ShopStrings.notifyBackInStock),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: ShopStrings.deliveryAndReturns,
                  trailing: const DemoLabel(),
                  child: Column(
                    children: [
                      _IconLine(
                        icon: Icons.local_shipping_outlined,
                        text: MockFixtures.deliveryPromise,
                      ),
                      _IconLine(
                        icon: Icons.payments_outlined,
                        text: ShopStrings.deliveryFeeLine(
                          formatSyp(MockFixtures.deliveryFeePerStoreSyp),
                        ),
                      ),
                      const _IconLine(
                        icon: Icons.verified_user_outlined,
                        text: ShopStrings.inspectOnDelivery,
                      ),
                    ],
                  ),
                ),
                SectionCard(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                  child: SwitchListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
                    secondary: const Icon(Icons.trending_down),
                    title: const Text(ShopStrings.priceDropAlert),
                    subtitle: const Text(ShopStrings.savedOnDevice),
                    value: watching,
                    onChanged: (_) async {
                      final now = await ref
                          .read(localIdSetProvider(priceWatchesKey).notifier)
                          .toggle('${product.id}');
                      if (context.mounted) {
                        showToast(
                          context,
                          now
                              ? ShopStrings.priceWatchOn
                              : ShopStrings.priceWatchOff,
                        );
                      }
                    },
                  ),
                ),
                if (product.description != null &&
                    product.description!.isNotEmpty)
                  SectionCard(
                    title: DooryStrings.description,
                    child: Text(
                      product.description!,
                      style: DooryTypography.body(context),
                    ),
                  ),
                _ReviewsSection(productId: product.id),
                SectionCard(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text(ShopStrings.askQuestion),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () => showNotWired(
                          context,
                          feature: ShopStrings.questionFeature,
                        ),
                      ),
                      if (product.storeSlug != null)
                        ListTile(
                          leading: const Icon(Icons.storefront_outlined),
                          title: const Text(DooryStrings.viewStore),
                          trailing: const Icon(Icons.chevron_left),
                          onTap: () => pushStore(context, product.storeSlug!),
                        ),
                      ListTile(
                        leading: const Icon(Icons.flag_outlined),
                        title: const Text(ShopStrings.reportListing),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () => showNotWired(
                          context,
                          feature: ShopStrings.reportFeature,
                        ),
                      ),
                    ],
                  ),
                ),
                if (product.storeSlug != null)
                  _SameStore(slug: product.storeSlug!, productId: product.id),
              ],
            ),
          ),
        ),
        if (pinned)
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                // A fixed height keeps the bar a strip at the bottom; the price
                // column would otherwise stretch it to the full screen.
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                      child: PriceText(
                        amount: product.priceSyp,
                        estimate: false,
                        style: PriceStyle.compact,
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(64, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: canPurchase
                          ? () => _addToCart(context, ref, product, selected)
                          : null,
                      child: const Text(DooryStrings.addToCart),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DooryColors.surface,
      shape: const CircleBorder(),
      elevation: 1,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onTap,
        icon: Icon(icon, color: color),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: DooryColors.primaryStrong),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: DooryTypography.label(context))),
        ],
      ),
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productReviewsProvider(productId));
    return SectionCard(
      title: ShopStrings.reviews,
      trailing: TextButton(
        onPressed: () =>
            showNotWired(context, feature: ShopStrings.reviewFeature),
        child: const Text(ShopStrings.writeReview),
      ),
      child: async.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, stack) => const SizedBox.shrink(),
        data: (items) => ReviewList(
          reviews: items.take(3).toList(),
          sample: true,
          shrinkWrap: true,
        ),
      ),
    );
  }
}

class _Breadcrumb extends ConsumerWidget {
  const _Breadcrumb({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 16, 0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: () => goTabRoot(context),
            child: const Text(DooryStrings.tabHome),
          ),
          const Text('›'),
          if (product.categorySlug != null && product.categoryName != null) ...[
            TextButton(
              onPressed: () => pushCategory(context, product.categorySlug!),
              child: Text(product.categoryName!),
            ),
            const Text('›'),
          ],
          Text(product.name, style: DooryTypography.label(context)),
        ],
      ),
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({required this.urls, required this.name});

  final List<String> urls;
  final String name;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final urls = widget.urls;
    if (urls.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: ColoredBox(
          color: DooryColors.surfaceSubtle,
          child: Icon(Icons.image_outlined, color: muted, size: 64),
        ),
      );
    }
    Widget image(String url) => CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      memCacheWidth: 800,
      errorWidget: (context, url, error) =>
          Icon(Icons.image_outlined, color: muted),
    );
    if (urls.length == 1) {
      return AspectRatio(aspectRatio: 1, child: image(urls.first));
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (value) => setState(() => _page = value),
            children: [for (final url in urls) image(url)],
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < urls.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: 3,
                    ),
                    width: i == _page ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? DooryColors.primaryStrong
                          : DooryColors.border,
                      borderRadius: BorderRadius.circular(3),
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
    return ProductShelf(
      title: DooryStrings.fromSameStore,
      products: others,
      sample: store.sample,
      onViewAll: () => pushStore(context, slug),
    );
  }
}
