import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/category_avatar.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../listing/catalog_widgets.dart';
import '../listing/listing_state.dart';
import 'search_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({required this.initialQuery, super.key});

  final String initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _field = TextEditingController(
    text: widget.initialQuery,
  );
  final _scroll = ScrollController();
  Timer? _debounce;

  /// Query the results follow. Typing updates it in place; the route's `q`
  /// changes only on submit, so the field keeps its focus, cursor, and the
  /// keyboard's composing region (Arabic and other IME input) while results
  /// refresh underneath.
  late String _query = widget.initialQuery.trim();

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.initialQuery.trim();
    if (widget.initialQuery == oldWidget.initialQuery || incoming == _query) {
      return;
    }
    _query = incoming;
    // A new `q` from outside (a deep link or a chip) replaces the text; the
    // user's own words, including a trailing space between words, stay as
    // typed.
    if (_field.text.trim() != incoming) {
      _field.value = TextEditingValue(
        text: incoming,
        selection: TextSelection.collapsed(offset: incoming.length),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _field.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _show(String value) {
    final next = value.trim();
    if (!mounted || next == _query) return;
    setState(() => _query = next);
  }

  void _commit(String value) {
    _debounce?.cancel();
    _show(value);
    replaceSearch(context, value);
  }

  void _pick(String value) {
    _field.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _commit(value);
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _show(value));
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final state = ref.watch(searchProvider(query));
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: DoorySearchField(
            controller: _field,
            autofocus: query.isEmpty,
            onChanged: _onChanged,
            onSubmitted: _commit,
          ),
        ),
      ),
      body: query.isEmpty
          ? _EmptySearch(onPick: _pick)
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(searchProvider(query).notifier).refresh(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 480) {
                    ref.read(searchProvider(query).notifier).loadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: _slivers(context, query, state),
                ),
              ),
            ),
    );
  }

  List<Widget> _slivers(BuildContext context, String query, SearchState state) {
    final header = SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
            child: Text(
              DooryStrings.searchHeading(query),
              style: DooryTypography.section(context),
            ),
          ),
          if (state.degraded)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
              child: Text(
                DooryStrings.degraded,
                style: DooryTypography.label(context),
              ),
            ),
          CatalogToolbar(
            sort: state.sort,
            total: state.loading ? null : state.total,
            sample: state.sample,
            onSort: () async {
              final next = await showSortSheet(context, state.sort);
              if (next != null && context.mounted) {
                await ref.read(searchProvider(query).notifier).setSort(next);
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
                  .read(searchProvider(query).notifier)
                  .applyPrice(
                    result.cleared ? null : result.min,
                    result.cleared ? null : result.max,
                  );
            },
          ),
          if (state.facets.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final facet in state.facets)
                    FilterChip(
                      label: Text(
                        DooryStrings.categoryFacet(
                          facet.name ?? '${facet.id}',
                          facet.count,
                        ),
                      ),
                      selected: state.categoryId == facet.id,
                      onSelected: (_) => ref
                          .read(searchProvider(query).notifier)
                          .toggleCategory(facet.id),
                    ),
                ],
              ),
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
      ),
    );

    if (state.loading && state.items.isEmpty) {
      return [
        header,
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.all(16),
            child: SkeletonBox(height: 240),
          ),
        ),
      ];
    }
    if (state.failure == ListingFailure.rejected ||
        (state.failure == ListingFailure.unavailable && !state.sample)) {
      return [
        header,
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusMessage(
            title: state.message ?? DooryStrings.rejectedGeneric,
            actionLabel: DooryStrings.retry,
            onAction: () => ref.read(searchProvider(query).notifier).refresh(),
          ),
        ),
      ];
    }
    if (state.isEmptyResult) {
      return [
        header,
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusMessage(
            title: DooryStrings.noResults,
            body: DooryStrings.noResultsHint,
            actionLabel: DooryStrings.browseCategories,
            onAction: () => context.go('/categories'),
          ),
        ),
      ];
    }
    return [
      header,
      if (state.sample)
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

class _EmptySearch extends ConsumerWidget {
  const _EmptySearch({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final nodes = switch (categories.asData?.value) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample ?? const [],
      _ => const <CategoryNode>[],
    };
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(DooryStrings.emptySearch, style: DooryTypography.body(context)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final node in nodes)
              CategoryChip(
                node: node,
                onPressed: () => onPick(node.name),
              ),
          ],
        ),
      ],
    );
  }
}
