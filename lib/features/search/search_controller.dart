import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/doory_strings.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../listing/listing_state.dart';

class SearchController extends FamilyNotifier<SearchState, String> {
  CancelToken? _cancel;
  var _generation = 0;
  late String _query;

  @override
  SearchState build(String arg) {
    _query = arg.trim();
    ref.onDispose(() => _cancel?.cancel());
    if (_query.isEmpty) return SearchState.idle();
    Future<void>.microtask(reload);
    return SearchState.loading(_query);
  }

  Future<void> refresh() => reload();

  Future<void> reload() => _fetch(reset: true);

  Future<void> loadMore() async {
    if (_query.isEmpty || state.loading || state.loadingMore) return;
    if (state.page >= state.lastPage) return;
    if (state.failure != ListingFailure.none && state.items.isEmpty) return;
    await _fetch(reset: false);
  }

  Future<void> setSort(ProductSort sort) async {
    state = state.copyWith(sort: sort);
    await reload();
  }

  Future<void> applyPrice(int? min, int? max) async {
    if (min != null && max != null && min > max) {
      state = state.copyWith(
        updatePrices: true,
        minPrice: min,
        maxPrice: max,
        priceRangeError: true,
      );
      return;
    }
    state = state.copyWith(
      updatePrices: true,
      minPrice: min,
      maxPrice: max,
      priceRangeError: false,
    );
    await reload();
  }

  Future<void> toggleCategory(int id) async {
    final next = state.categoryId == id ? null : id;
    state = state.copyWith(updateCategory: true, categoryId: next);
    await reload();
  }

  Future<void> _fetch({required bool reset}) async {
    if (_query.isEmpty) {
      state = SearchState.idle();
      return;
    }
    final generation = ++_generation;
    _cancel?.cancel();
    final cancel = CancelToken();
    _cancel = cancel;
    final sort = state.sort;
    final minPrice = state.minPrice;
    final maxPrice = state.maxPrice;
    final categoryId = state.categoryId;

    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        priceRangeError: true,
      );
      return;
    }

    state = state.copyWith(
      loading: reset,
      loadingMore: !reset,
      failure: ListingFailure.none,
      clearMessage: true,
      items: reset ? const [] : null,
      degraded: false,
    );

    final result = await ref
        .read(searchRepositoryProvider)
        .search(
          ProductsQuery(
            q: _query,
            categoryId: categoryId,
            sort: sort,
            minPriceSyp: minPrice,
            maxPriceSyp: maxPrice,
            page: reset ? 1 : state.page + 1,
            perPage: 24,
          ),
          cancelToken: cancel,
        );
    if (generation != _generation) return;

    final categories = ref.read(categoriesProvider).asData?.value;
    final nodes = switch (categories) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample,
      _ => null,
    };

    switch (result) {
      case RepoOk<SearchPage>(:final data):
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: reset ? data.items : _merge(state.items, data.items),
          facets: _nameFacets(data.categoryFacets, nodes),
          page: data.meta.page,
          lastPage: data.meta.lastPage,
          total: data.meta.total,
          degraded: data.degraded,
          sample: data.sample,
          failure: ListingFailure.none,
          clearMessage: true,
        );
      case RepoUnavailable<SearchPage>(:final sample):
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: sample?.items ?? const [],
          facets: _nameFacets(sample?.categoryFacets ?? const [], nodes),
          page: sample?.meta.page ?? 1,
          lastPage: sample?.meta.lastPage ?? 1,
          total: sample?.meta.total ?? 0,
          degraded: sample?.degraded ?? false,
          sample: sample != null,
          failure: ListingFailure.unavailable,
          message: sample == null
              ? DooryStrings.unavailable
              : DooryStrings.resultsMayBeSample,
        );
      case RepoRejected<SearchPage>(:final message):
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: const [],
          sample: false,
          failure: ListingFailure.rejected,
          message: message,
        );
      case RepoNotFound<SearchPage>():
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: const [],
          total: 0,
          failure: ListingFailure.none,
        );
    }
  }

  List<CategoryFacet> _nameFacets(
    List<CategoryFacet> facets,
    List<CategoryNode>? nodes,
  ) {
    if (nodes == null) return facets;
    return [
      for (final facet in facets)
        CategoryFacet(
          id: facet.id,
          count: facet.count,
          name: facet.name ?? findCategoryById(nodes, facet.id)?.name,
        ),
    ];
  }

  List<ProductCardModel> _merge(
    List<ProductCardModel> current,
    List<ProductCardModel> incoming,
  ) {
    final seen = {for (final item in current) item.id};
    return [
      ...current,
      for (final item in incoming)
        if (seen.add(item.id)) item,
    ];
  }
}

final searchProvider =
    NotifierProvider.family<SearchController, SearchState, String>(
      SearchController.new,
    );
