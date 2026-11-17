import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/doory_strings.dart';
import '../../data/demo/demo_data.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import 'listing_state.dart';

class ListingController extends FamilyNotifier<ListingState, String> {
  CancelToken? _cancel;
  var _generation = 0;
  late String _slug;

  @override
  ListingState build(String arg) {
    _slug = arg;
    ref.onDispose(() => _cancel?.cancel());
    Future<void>.microtask(reload);
    return ListingState.initial(arg);
  }

  Future<void> refresh() async {
    ref.invalidate(categoriesProvider);
    await reload();
  }

  Future<void> reload() => _fetch(reset: true);

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore) return;
    if (state.page >= state.lastPage) return;
    if (state.failure != ListingFailure.none && state.items.isEmpty) return;
    await _fetch(reset: false);
  }

  Future<void> setSort(ProductSort sort) async {
    state = state.copyWith(sort: sort, priceRangeError: false);
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

  Future<void> _fetch({required bool reset}) async {
    final generation = ++_generation;
    _cancel?.cancel();
    final cancel = CancelToken();
    _cancel = cancel;
    final sort = state.sort;
    final minPrice = state.minPrice;
    final maxPrice = state.maxPrice;

    state = state.copyWith(
      loading: reset,
      loadingMore: !reset,
      failure: ListingFailure.none,
      clearMessage: true,
      items: reset ? const [] : null,
      priceRangeError: false,
    );

    final categories = await ref.read(categoriesProvider.future);
    if (generation != _generation) return;

    final nodes = switch (categories) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample,
      _ => null,
    };
    final node = nodes == null ? null : findCategory(nodes, _slug);
    if (categories is RepoOk<List<CategoryNode>> && node == null) {
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        failure: ListingFailure.notFound,
        items: const [],
      );
      return;
    }
    if (node == null) {
      final demo = DemoData.listingFor(_slug);
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        failure: ListingFailure.unavailable,
        sample: demo != null,
        items: demo?.items ?? const [],
        total: demo?.meta.total ?? 0,
        lastPage: demo?.meta.lastPage ?? 1,
        page: 1,
        message: DooryStrings.resultsMayBeSample,
      );
      return;
    }

    final nextPage = reset ? 1 : state.page + 1;
    if (!reset && nextPage > state.lastPage) {
      state = state.copyWith(loading: false, loadingMore: false);
      return;
    }

    final result = await ref
        .read(catalogRepositoryProvider)
        .products(
          ProductsQuery(
            categoryId: node.id,
            sort: sort,
            minPriceSyp: minPrice,
            maxPriceSyp: maxPrice,
            page: clampPage(nextPage, reset ? nextPage : state.lastPage),
            perPage: 24,
          ),
          categorySlug: _slug,
          cancelToken: cancel,
        );
    if (generation != _generation) return;

    switch (result) {
      case RepoOk<ProductPage>(:final data):
        final merged = reset ? data.items : _merge(state.items, data.items);
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: merged,
          page: data.meta.page,
          lastPage: data.meta.lastPage,
          total: data.meta.total,
          sample: false,
          failure: ListingFailure.none,
          categoryName: node.name,
          children: node.children,
          clearMessage: true,
        );
      case RepoUnavailable<ProductPage>(:final sample, :final message):
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: reset ? (sample?.items ?? const []) : state.items,
          page: sample?.meta.page ?? state.page,
          lastPage: sample?.meta.lastPage ?? state.lastPage,
          total: sample?.meta.total ?? state.total,
          sample: sample != null,
          failure: ListingFailure.unavailable,
          message: sample == null
              ? DooryStrings.unavailable
              : DooryStrings.resultsMayBeSample,
          categoryName: node.name,
          children: node.children,
        );
        if (message != null && sample == null) {
          state = state.copyWith(message: message);
        }
      case RepoRejected<ProductPage>(:final message):
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          items: const [],
          sample: false,
          failure: ListingFailure.rejected,
          message: message,
          categoryName: node.name,
          children: node.children,
        );
      case RepoNotFound<ProductPage>():
        state = state.copyWith(
          loading: false,
          loadingMore: false,
          failure: ListingFailure.notFound,
          items: const [],
          categoryName: node.name,
        );
    }
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

final listingProvider =
    NotifierProvider.family<ListingController, ListingState, String>(
      ListingController.new,
    );
