import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/price_text.dart';
import '../../core/widgets/product_shelf.dart';
import '../../data/favorites/favorites_controller.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.appName)),
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

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            onPinned(notification.metrics.pixels > 360);
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
                _Gallery(urls: product.photoUrls, name: product.name),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.storeName != null)
                        Text(
                          product.storeName!,
                          style: DooryTypography.cardBrand(context),
                        ),
                      Semantics(
                        header: true,
                        child: Text(
                          product.name,
                          style: DooryTypography.productTitle(context),
                        ),
                      ),
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
                              .copyWith(color: DooryTokens.of(context).danger),
                        )
                      else if (!product.canPurchase)
                        Text(
                          DooryStrings.cannotPurchase,
                          style: DooryTypography.labelStrong(context)
                              .copyWith(color: DooryTokens.of(context).danger),
                        ),
                      if (product.averageRating != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${DooryStrings.seller} · ${product.averageRating!.toStringAsFixed(1)}'
                          '${product.reviewsCount > 0 ? ' (${product.reviewsCount})' : ''}',
                          style: DooryTypography.label(context),
                        ),
                      ],
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
                      Text(
                        DooryStrings.quantity,
                        style: DooryTypography.labelStrong(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: DooryStrings.quantity,
                            onPressed: quantity > 1
                                ? () => onQuantity(quantity - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            '$quantity',
                            style: DooryTypography.body(context),
                          ),
                          IconButton(
                            tooltip: DooryStrings.quantity,
                            onPressed: quantity < 99
                                ? () => onQuantity(quantity + 1)
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: canPurchase
                            ? () => showCheckoutComing(context)
                            : null,
                        child: const Text(DooryStrings.addToCart),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: canPurchase
                            ? () => showCheckoutComing(context)
                            : null,
                        child: const Text(DooryStrings.buyNow),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(product.toCard()),
                        icon: Icon(
                          saved ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                          saved
                              ? DooryStrings.removeFavorite
                              : DooryStrings.addFavorite,
                        ),
                      ),
                      if (product.storeSlug != null)
                        TextButton(
                          onPressed: () =>
                              pushStore(context, product.storeSlug!),
                          child: const Text(DooryStrings.viewStore),
                        ),
                      if (product.description != null &&
                          product.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          DooryStrings.description,
                          style: DooryTypography.labelStrong(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description!,
                          style: DooryTypography.body(context),
                        ),
                      ],
                      if (product.shareUrl != null)
                        TextButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: product.shareUrl!),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(DooryStrings.linkCopied),
                              ),
                            );
                          },
                          child: const Text(DooryStrings.copyLink),
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
                          ? () => showCheckoutComing(context)
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

class _Gallery extends StatelessWidget {
  const _Gallery({required this.urls, required this.name});

  final List<String> urls;
  final String name;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    if (urls.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Icon(Icons.image_outlined, color: muted, size: 48),
        ),
      );
    }
    if (urls.length == 1) {
      return AspectRatio(
        aspectRatio: 1,
        child: CachedNetworkImage(
          imageUrl: urls.first,
          fit: BoxFit.contain,
          memCacheWidth: 800,
          errorWidget: (context, url, error) =>
              Icon(Icons.image_outlined, color: muted),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 1,
      child: PageView(
        children: [
          for (final url in urls)
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              memCacheWidth: 800,
              errorWidget: (context, url, error) =>
                  Icon(Icons.image_outlined, color: muted),
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
