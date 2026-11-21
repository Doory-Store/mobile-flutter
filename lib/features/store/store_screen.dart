import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/date_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/mock/mock_fixtures.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../account/account_providers.dart';
import '../account/local_preferences.dart';
import '../listing/catalog_widgets.dart';

/// Store profile. Name, area, description, and products come from the live
/// `GET /stores/{slug}`; follow state and reviews are sample data.
class StoreScreen extends ConsumerWidget {
  const StoreScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(storeProvider(slug));
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.viewStore)),
      body: async.when(
        loading: () => const Padding(
          padding: EdgeInsetsDirectional.all(16),
          child: Column(
            children: [
              SkeletonBox(height: 120),
              SizedBox(height: 16),
              SkeletonBox(height: 220),
            ],
          ),
        ),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailable,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(storeProvider(slug)),
        ),
        data: (result) {
          if (result case RepoRejected<StoreModel>(:final message)) {
            return StatusMessage(
              title: message,
              actionLabel: DooryStrings.retry,
              onAction: () => ref.invalidate(storeProvider(slug)),
            );
          }
          if (result is RepoNotFound<StoreModel>) {
            return StatusMessage(
              title: DooryStrings.notFoundStore,
              actionLabel: DooryStrings.browseCategories,
              onAction: () => context.go('/categories'),
            );
          }
          final store = switch (result) {
            RepoOk<StoreModel>(:final data) => data,
            RepoUnavailable<StoreModel>(:final sample) => sample,
            _ => null,
          };
          if (store == null) {
            return StatusMessage(
              title: DooryStrings.unavailable,
              actionLabel: DooryStrings.retry,
              onAction: () => ref.invalidate(storeProvider(slug)),
            );
          }
          return _StoreBody(store: store);
        },
      ),
    );
  }
}

class _StoreBody extends ConsumerStatefulWidget {
  const _StoreBody({required this.store});

  final StoreModel store;

  @override
  ConsumerState<_StoreBody> createState() => _StoreBodyState();
}

enum _LocalSort { newest, priceAsc, priceDesc }

class _StoreBodyState extends ConsumerState<_StoreBody> {
  _LocalSort _sort = _LocalSort.newest;

  List<ProductCardModel> get _sorted {
    final items = [...widget.store.products];
    int price(ProductCardModel p, int fallback) => p.priceSyp ?? fallback;
    switch (_sort) {
      case _LocalSort.newest:
        break;
      case _LocalSort.priceAsc:
        items.sort((a, b) => price(a, 1 << 40).compareTo(price(b, 1 << 40)));
      case _LocalSort.priceDesc:
        items.sort((a, b) => price(b, -1).compareTo(price(a, -1)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverToBoxAdapter(child: _Header(store: store)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabsDelegate(
              const TabBar(
                tabs: [
                  Tab(text: ShopStrings.products),
                  Tab(text: ShopStrings.reviews),
                  Tab(text: ShopStrings.aboutStore),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            _productsTab(context),
            _ReviewsTab(slug: store.slug),
            _AboutTab(store: store),
          ],
        ),
      ),
    );
  }

  Widget _productsTab(BuildContext context) {
    final items = _sorted;
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: ShopStrings.storeNoProducts,
      );
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                for (final (sort, label) in [
                  (_LocalSort.newest, DooryStrings.sortNewest),
                  (_LocalSort.priceAsc, DooryStrings.sortPriceAsc),
                  (_LocalSort.priceDesc, DooryStrings.sortPriceDesc),
                ])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _sort == sort,
                      onSelected: (_) => setState(() => _sort = sort),
                    ),
                  ),
              ],
            ),
          ),
        ),
        ProductGridSliver(items: items),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = DooryTokens.of(context);
    final followed = ref
        .watch(localIdSetProvider(followedStoresKey))
        .contains(store.slug);
    final name = store.name ?? store.slug;
    return Container(
      color: tokens.primarySubtle,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (store.sample) ...[
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: DemoLabel(),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: DooryColors.primaryStrong,
                child: Text(
                  name.characters.first,
                  style: DooryTypography.page(context)
                      .copyWith(color: DooryColors.textOnStrong),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: DooryTypography.page(context)),
                    if (store.areaLabel != null)
                      Text(
                        store.areaLabel!,
                        style: DooryTypography.label(context),
                      ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 12,
                      children: [
                        if (store.averageRating != null)
                          Text(
                            '★ ${store.averageRating!.toStringAsFixed(1)}'
                            '${(store.reviewsCount ?? 0) > 0 ? ' (${store.reviewsCount})' : ''}',
                            style: DooryTypography.labelStrong(context),
                          ),
                        Text(
                          ShopStrings.productsCount(store.products.length),
                          style: DooryTypography.label(context),
                        ),
                        if (store.followersCount != null)
                          Text(
                            ShopStrings.followers(store.followersCount!),
                            style: DooryTypography.label(context),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: followed
                    ? OutlinedButton.icon(
                        onPressed: () => _toggle(context, ref),
                        icon: const Icon(Icons.check),
                        label: const Text(ShopStrings.following),
                      )
                    : FilledButton.icon(
                        onPressed: () => _toggle(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text(ShopStrings.follow),
                      ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: ShopStrings.messageStore,
                onPressed: () => showNotWired(
                  context,
                  feature: ShopStrings.messageStoreFeature,
                ),
                icon: const Icon(Icons.chat_bubble_outline),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: DooryStrings.copyLink,
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: 'https://doory.elogyc.com/ar/s/${store.slug}',
                    ),
                  );
                  if (context.mounted) {
                    showToast(context, DooryStrings.linkCopied);
                  }
                },
                icon: const Icon(Icons.share_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final now = await ref
        .read(localIdSetProvider(followedStoresKey).notifier)
        .toggle(store.slug);
    if (!context.mounted) return;
    showToast(
      context,
      now ? ShopStrings.followedLocal : ShopStrings.unfollowed,
    );
  }
}

class _TabsDelegate extends SliverPersistentHeaderDelegate {
  _TabsDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Material(color: DooryColors.surface, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabsDelegate oldDelegate) => false;
}

class _ReviewsTab extends ConsumerWidget {
  const _ReviewsTab({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(storeReviewsProvider(slug));
    return async.when(
      loading: () => const ListSkeleton(height: 72),
      error: (error, stack) =>
          const StatusMessage(title: DooryStrings.unavailable),
      data: (items) => ReviewList(reviews: items, sample: true),
    );
  }
}

/// Rating summary and review cards. Used by store and product pages.
class ReviewList extends StatelessWidget {
  const ReviewList({
    required this.reviews,
    this.sample = false,
    this.shrinkWrap = false,
    super.key,
  });

  final List<Review> reviews;
  final bool sample;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const EmptyState(
        icon: Icons.rate_review_outlined,
        title: ShopStrings.noReviews,
      );
    }
    final average =
        reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;
    final children = [
      Row(
        children: [
          Text(
            average.toStringAsFixed(1),
            style: DooryTypography.page(context),
          ),
          const SizedBox(width: 8),
          StarsRow(rating: average.round()),
          const SizedBox(width: 8),
          Text(
            ShopStrings.reviewsCount(reviews.length),
            style: DooryTypography.label(context),
          ),
          const Spacer(),
          if (sample) const DemoLabel(),
        ],
      ),
      const SizedBox(height: 12),
      for (final review in reviews)
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.authorName,
                    style: DooryTypography.labelStrong(context),
                  ),
                  const SizedBox(width: 8),
                  StarsRow(rating: review.rating, size: 14),
                  const Spacer(),
                  Text(
                    formatDate(review.createdAt),
                    style: DooryTypography.cardMeta(context),
                  ),
                ],
              ),
              if (review.comment != null)
                Text(review.comment!, style: DooryTypography.body(context)),
              const Divider(),
            ],
          ),
        ),
    ];
    if (shrinkWrap) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: children,
    );
  }
}

class StarsRow extends StatelessWidget {
  const StarsRow({required this.rating, this.size = 18, super.key});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            Icons.star_rounded,
            size: size,
            color: i <= rating ? DooryColors.rating : DooryColors.border,
          ),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsetsDirectional.only(top: 16, bottom: 24),
      children: [
        SectionCard(
          title: ShopStrings.aboutStore,
          child: Text(
            store.description ?? ShopStrings.noStoreDescription,
            style: DooryTypography.body(context),
          ),
        ),
        SectionCard(
          child: Column(
            children: [
              if (store.areaLabel != null)
                InfoRow(label: DooryStrings.area, value: store.areaLabel!),
              const InfoRow(label: ShopStrings.city, value: 'حمص'),
              const InfoRow(
                label: ShopStrings.delivery,
                value: MockFixtures.deliveryPromise,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: TextButton.icon(
            onPressed: () =>
                showNotWired(context, feature: ShopStrings.reportFeature),
            icon: const Icon(Icons.flag_outlined),
            label: const Text(ShopStrings.reportStore),
          ),
        ),
      ],
    );
  }
}
