import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/routing/home_collection.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import 'catalog_widgets.dart';
import 'listing_controller.dart';
import 'listing_state.dart';

class ListingScreen extends ConsumerStatefulWidget {
  const ListingScreen({required this.slug, this.title, super.key});

  /// Category slug, or [allProductsKey] for the whole catalog.
  final String slug;

  /// Fixed app-bar title; the category name is used when this is null.
  final String? title;

  @override
  ConsumerState<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends ConsumerState<ListingScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  bool _nearEnd(ScrollNotification notification) {
    if (notification.metrics.extentAfter < 480) {
      ref.read(listingProvider(widget.slug).notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listingProvider(widget.slug));
    final title = widget.title ?? state.categoryName ?? widget.slug;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(listingProvider(widget.slug).notifier).refresh(),
        child: NotificationListener<ScrollNotification>(
          onNotification: _nearEnd,
          child: CustomScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (state.failure != ListingFailure.notFound)
                SliverToBoxAdapter(child: _header(context, state)),
              ..._body(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, ListingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.children.isNotEmpty)
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: state.children.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final child = state.children[index];
                return ActionChip(
                  label: Text(child.name),
                  onPressed: () => pushCategory(context, child.slug),
                );
              },
            ),
          ),
        CatalogToolbar(
          sort: state.sort,
          total: state.loading ? null : state.total,
          sample: state.sample,
          onSort: () async {
            final next = await showSortSheet(context, state.sort);
            if (next != null && context.mounted) {
              await ref
                  .read(listingProvider(widget.slug).notifier)
                  .setSort(next);
            }
          },
          onPrice: () async {
            final result = await showPriceSheet(
              context,
              min: state.minPrice,
              max: state.maxPrice,
            );
            if (result == null || !context.mounted) return;
            await ref
                .read(listingProvider(widget.slug).notifier)
                .applyPrice(
                  result.cleared ? null : result.min,
                  result.cleared ? null : result.max,
                );
          },
        ),
        if (state.priceRangeError)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(
              DooryStrings.invalidRange,
              style: DooryTypography.label(context)
                  .copyWith(color: DooryTokens.of(context).danger),
            ),
          ),
      ],
    );
  }

  List<Widget> _body(BuildContext context, ListingState state) {
    if (state.failure == ListingFailure.notFound) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusMessage(
            title: DooryStrings.notFoundCategory,
            actionLabel: DooryStrings.browseCategories,
            onAction: () => context.go('/categories'),
          ),
        ),
      ];
    }
    if (state.loading && state.items.isEmpty) {
      return const [
        SliverPadding(
          padding: EdgeInsetsDirectional.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                SkeletonBox(height: 220),
                SizedBox(height: 12),
                SkeletonBox(height: 220),
              ],
            ),
          ),
        ),
      ];
    }
    if (state.failure == ListingFailure.rejected ||
        (state.failure == ListingFailure.unavailable && state.items.isEmpty)) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusMessage(
            title: state.message ?? DooryStrings.unavailable,
            actionLabel: DooryStrings.retry,
            onAction: () =>
                ref.read(listingProvider(widget.slug).notifier).refresh(),
          ),
        ),
      ];
    }
    if (state.isEmptyResult) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusMessage(
            title: DooryStrings.emptyCategory,
            actionLabel: DooryStrings.browseCategories,
            onAction: () => context.go('/categories'),
          ),
        ),
      ];
    }
    return [
      if (state.failure == ListingFailure.unavailable && state.sample)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(
              DooryStrings.resultsMayBeSample,
              style: DooryTypography.label(context),
            ),
          ),
        ),
      ProductGridSliver(items: state.items),
      if (state.loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }
}
