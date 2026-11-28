import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/catalog_strings.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import 'catalog_widgets.dart';
import 'listing_controller.dart';
import 'listing_filter_screen.dart';
import 'listing_state.dart';

class ListingScreen extends ConsumerStatefulWidget {
  const ListingScreen({required this.slug, this.title, super.key});

  final String slug;
  final String? title;

  @override
  ConsumerState<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends ConsumerState<ListingScreen> {
  final _scroll = ScrollController();
  late final _pill = TextEditingController();

  @override
  void dispose() {
    _scroll.dispose();
    _pill.dispose();
    super.dispose();
  }

  bool _nearEnd(ScrollNotification notification) {
    if (notification.metrics.extentAfter < 480) {
      ref.read(listingProvider(widget.slug).notifier).loadMore();
    }
    return false;
  }

  String _pillText(ListingState state) {
    final name = widget.title ?? state.categoryName ?? widget.slug;
    if (state.loading && state.items.isEmpty) return name;
    return '$name | ${SearchStrings.resultsCount(state.total)}';
  }

  Future<void> _apply(ListingFilters? next) async {
    if (next == null || !mounted) return;
    await ref.read(listingProvider(widget.slug).notifier).applyFilters(next);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listingProvider(widget.slug));
    final text = _pillText(state);
    if (_pill.text != text) _pill.text = text;

    return Scaffold(
      backgroundColor: DooryColors.surfaceSubtle,
      body: SafeArea(
        child: Column(
          children: [
            _PinnedHeader(
              controller: _pill,
              state: state,
              slug: widget.slug,
              title: widget.title,
              onApply: _apply,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(listingProvider(widget.slug).notifier).refresh(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: _nearEnd,
                  child: CustomScrollView(
                    controller: _scroll,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: _body(context, state),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
      return [
        SliverPadding(
          padding: const EdgeInsetsDirectional.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const SkeletonBox(height: 220),
              childCount: 4,
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
            actionLabel: state.hasActiveFilters
                ? CatalogStrings.clearFilters
                : DooryStrings.browseCategories,
            onAction: state.hasActiveFilters
                ? () => ref
                      .read(listingProvider(widget.slug).notifier)
                      .clearFilters()
                : () => context.go('/categories'),
          ),
        ),
      ];
    }
    return [
      if (state.failure == ListingFailure.unavailable && state.sample)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
            child: Text(
              DooryStrings.resultsMayBeSample,
              style: DooryTypography.label(context),
            ),
          ),
        ),
      ProductGridSliver(items: state.items, showFavorites: true),
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

class _PinnedHeader extends ConsumerWidget {
  const _PinnedHeader({
    required this.controller,
    required this.state,
    required this.slug,
    required this.onApply,
    this.title,
  });

  final TextEditingController controller;
  final ListingState state;
  final String slug;
  final String? title;
  final Future<void> Function(ListingFilters?) onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: DooryColors.surface,
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(
                  tooltip: SearchStrings.back,
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: DooryColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: DoorySearchField(
                      controller: controller,
                      readOnly: true,
                      showCamera: true,
                      onTap: () => pushSearch(context),
                      onCameraTap: () => showNotWired(
                        context,
                        feature: SearchStrings.visualSearchFeature,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListingChipBar(
            sort: state.sort,
            filters: state.filters,
            rootCategoryId: state.rootCategoryId,
            children: state.children,
            onSort: () async {
              final next = await showSortSheet(context, state.sort);
              if (next != null && context.mounted) {
                await ref.read(listingProvider(slug).notifier).setSort(next);
              }
            },
            onFilter: () async {
              final next = await ListingFilterScreen.open(
                context,
                initial: state.filters,
                sort: state.sort,
                children: state.children,
                rootCategoryId: state.rootCategoryId,
                rootCategoryName: title ?? state.categoryName,
              );
              await onApply(next);
            },
            onPrice: () async {
              final next = await showPriceFilterSheet(
                context,
                initial: state.filters,
              );
              await onApply(next);
            },
            onCategory: () async {
              final next = await showCategoryFilterSheet(
                context,
                initial: state.filters,
                children: state.children,
                rootCategoryId: state.rootCategoryId,
                rootCategoryName: title ?? state.categoryName,
              );
              await onApply(next);
            },
          ),
        ],
      ),
    );
  }
}
