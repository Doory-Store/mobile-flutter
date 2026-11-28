import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/routing/home_collection.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../listing/catalog_widgets.dart';

/// Sample data for «قطع لك خصيصًا»: the newest 10 products.
// BACKEND: MISSING personalised recommendations feed for a signed-in buyer
// (shelf is labelled «غير مدعوم»; sample = GET /products?per_page=10)
final recommendedProvider = FutureProvider.autoDispose<List<ProductCardModel>>((
  ref,
) async {
  final cancel = CancelToken();
  ref.onDispose(cancel.cancel);
  final result = await ref
      .watch(catalogRepositoryProvider)
      .products(const ProductsQuery(perPage: 10), cancelToken: cancel);
  return switch (result) {
    RepoOk<ProductPage>(:final data) => data.items,
    RepoUnavailable<ProductPage>(:final sample) => sample?.items ?? const [],
    _ => const [],
  };
});

TextStyle _t(double size, FontWeight weight, Color color) => TextStyle(
  fontFamily: 'Cairo',
  fontSize: size,
  fontWeight: weight,
  color: color,
);

/// Red «غير مدعوم» marker (11 sp w600).
class UnsupportedTag extends StatelessWidget {
  const UnsupportedTag({super.key});

  @override
  Widget build(BuildContext context) => Text(
    SearchStrings.unsupported,
    style: _t(11, FontWeight.w600, DooryColors.backendMissing),
  );
}

/// «عرض الكل ›»: 14 sp w600 primary and a 16 dp chevron.
class ViewAllLink extends StatelessWidget {
  const ViewAllLink({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DooryStrings.viewAll,
              style: _t(14, FontWeight.w600, DooryColors.primary),
            ),
            const Icon(
              Icons.chevron_left,
              size: 16,
              color: DooryColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// «قطع لك خصيصًا»: a horizontal shelf of small cards (98×145) after
/// Trendyol's search page. Hidden when there is nothing to show.
class RecommendedShelf extends ConsumerWidget {
  const RecommendedShelf({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recommendedProvider).asData?.value ?? const [];
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      key: const ValueKey('recommended-shelf'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
          child: Row(
            children: [
              Text(
                SearchStrings.recommendedTitle,
                style: _t(16, FontWeight.w700, DooryColors.textPrimary),
              ),
              const SizedBox(width: 8),
              const UnsupportedTag(),
              const Spacer(),
              ViewAllLink(
                onTap: () =>
                    pushCollection(context, HomeCollection.recommended),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 145,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (context, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) => _MiniCard(product: items[index]),
          ),
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.product});

  final ProductCardModel product;

  @override
  Widget build(BuildContext context) {
    final seller = product.sellerLabel;
    final price = product.priceSyp;
    final discount = product.hasDiscount ? product.discountPercent : null;
    return SizedBox(
      width: 98,
      height: 145,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DooryColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: DooryColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Material(
            color: DooryColors.surface,
            child: InkWell(
              onTap: () => pushProduct(context, product.ref, card: product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: product.photoUrl == null
                        ? const _NoPhoto()
                        : CachedNetworkImage(
                            imageUrl: product.photoUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: 300,
                            placeholder: (context, _) =>
                                const SkeletonBox(height: double.infinity),
                            errorWidget: (context, _, _) => const _NoPhoto(),
                          ),
                  ),
                  if (discount != null)
                    Container(
                      height: 16,
                      alignment: Alignment.center,
                      color: DooryColors.primary,
                      child: Text(
                        SearchStrings.discountStrip(discount),
                        style: _t(10, FontWeight.w700, Colors.white),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              if (seller != null)
                                TextSpan(
                                  text: '$seller ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              TextSpan(text: product.name),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _t(
                            11,
                            FontWeight.w400,
                            DooryColors.textPrimary,
                          ).copyWith(height: 15 / 11),
                        ),
                        if (price != null && price > 0)
                          Text(
                            formatSyp(price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _t(
                              11,
                              FontWeight.w700,
                              DooryColors.cardPrice,
                            ).copyWith(height: 15 / 11),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// «عرض الكل» of the recommended shelf: the same sample list as a grid, with
/// the red «غير مدعوم» label beside the title.
class RecommendedCollectionScreen extends ConsumerWidget {
  const RecommendedCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recommendedProvider);
    final items = async.asData?.value ?? const <ProductCardModel>[];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(SearchStrings.recommendedTitle),
            const SizedBox(width: 8),
            const UnsupportedTag(),
          ],
        ),
      ),
      body: async.isLoading
          ? const Padding(
              padding: EdgeInsetsDirectional.all(16),
              child: SkeletonBox(height: 220),
            )
          : CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                ProductGridSliver(items: items),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 24 + MediaQuery.paddingOf(context).bottom,
                  ),
                ),
              ],
            ),
    );
  }
}

class _NoPhoto extends StatelessWidget {
  const _NoPhoto();

  @override
  Widget build(BuildContext context) => const Center(
    child: Icon(Icons.image_outlined, color: DooryColors.textMuted, size: 24),
  );
}
