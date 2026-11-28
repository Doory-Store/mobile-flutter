import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';

enum ListingFailure { none, unavailable, rejected, notFound }

/// Draft / applied listing filters. [brand] is kept for the UI row but is
/// not sent: GET /products ignores `brand`.
class ListingFilters {
  const ListingFilters({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.brand,
  });

  static const empty = ListingFilters();

  final int? categoryId;
  final int? minPrice;
  final int? maxPrice;
  final String? brand;

  bool get hasPrice => minPrice != null || maxPrice != null;

  int activeCount({int? rootCategoryId}) {
    var n = 0;
    if (hasPrice) n++;
    if (categoryId != null && categoryId != rootCategoryId) n++;
    if (brand != null && brand!.isNotEmpty) n++;
    return n;
  }

  ListingFilters copyWith({
    int? categoryId,
    int? minPrice,
    int? maxPrice,
    String? brand,
    bool clearCategory = false,
    bool clearPrice = false,
    bool clearBrand = false,
  }) {
    return ListingFilters(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      brand: clearBrand ? null : (brand ?? this.brand),
    );
  }
}

class ListingState {
  const ListingState({
    required this.slug,
    this.categoryName,
    this.children = const [],
    this.items = const [],
    this.page = 1,
    this.lastPage = 1,
    this.total = 0,
    this.loading = true,
    this.loadingMore = false,
    this.sample = false,
    this.failure = ListingFailure.none,
    this.message,
    this.sort = ProductSort.newest,
    this.minPrice,
    this.maxPrice,
    this.filters = ListingFilters.empty,
    this.rootCategoryId,
    this.priceRangeError = false,
  });

  factory ListingState.initial(String slug) => ListingState(slug: slug);

  final String slug;
  final String? categoryName;
  final List<CategoryNode> children;
  final List<ProductCardModel> items;
  final int page;
  final int lastPage;
  final int total;
  final bool loading;
  final bool loadingMore;
  final bool sample;
  final ListingFailure failure;
  final String? message;
  final ProductSort sort;
  final int? minPrice;
  final int? maxPrice;
  final ListingFilters filters;
  final int? rootCategoryId;
  final bool priceRangeError;

  int get activeFilterCount =>
      filters.activeCount(rootCategoryId: rootCategoryId);

  bool get hasActiveFilters => activeFilterCount > 0;

  bool get isEmptyResult =>
      !loading && failure == ListingFailure.none && items.isEmpty;

  ListingState copyWith({
    String? categoryName,
    List<CategoryNode>? children,
    List<ProductCardModel>? items,
    int? page,
    int? lastPage,
    int? total,
    bool? loading,
    bool? loadingMore,
    bool? sample,
    ListingFailure? failure,
    String? message,
    bool clearMessage = false,
    ProductSort? sort,
    int? minPrice,
    int? maxPrice,
    bool updatePrices = false,
    ListingFilters? filters,
    int? rootCategoryId,
    bool? priceRangeError,
  }) {
    return ListingState(
      slug: slug,
      categoryName: categoryName ?? this.categoryName,
      children: children ?? this.children,
      items: items ?? this.items,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      sample: sample ?? this.sample,
      failure: failure ?? this.failure,
      message: clearMessage ? message : (message ?? this.message),
      sort: sort ?? this.sort,
      minPrice: updatePrices ? minPrice : (minPrice ?? this.minPrice),
      maxPrice: updatePrices ? maxPrice : (maxPrice ?? this.maxPrice),
      filters: filters ?? this.filters,
      rootCategoryId: rootCategoryId ?? this.rootCategoryId,
      priceRangeError: priceRangeError ?? this.priceRangeError,
    );
  }
}

class SearchState {
  const SearchState({
    required this.query,
    this.items = const [],
    this.facets = const [],
    this.page = 1,
    this.lastPage = 1,
    this.total = 0,
    this.loading = false,
    this.loadingMore = false,
    this.sample = false,
    this.degraded = false,
    this.failure = ListingFailure.none,
    this.message,
    this.sort = ProductSort.newest,
    this.minPrice,
    this.maxPrice,
    this.categoryId,
    this.priceRangeError = false,
  });

  factory SearchState.idle() => const SearchState(query: '');

  factory SearchState.loading(String query) =>
      SearchState(query: query, loading: true);

  final String query;
  final List<ProductCardModel> items;
  final List<CategoryFacet> facets;
  final int page;
  final int lastPage;
  final int total;
  final bool loading;
  final bool loadingMore;
  final bool sample;
  final bool degraded;
  final ListingFailure failure;
  final String? message;
  final ProductSort sort;
  final int? minPrice;
  final int? maxPrice;
  final int? categoryId;
  final bool priceRangeError;

  bool get isEmptyQuery => query.trim().isEmpty;

  bool get isEmptyResult =>
      !isEmptyQuery &&
      !loading &&
      failure == ListingFailure.none &&
      items.isEmpty;

  SearchState copyWith({
    List<ProductCardModel>? items,
    List<CategoryFacet>? facets,
    int? page,
    int? lastPage,
    int? total,
    bool? loading,
    bool? loadingMore,
    bool? sample,
    bool? degraded,
    ListingFailure? failure,
    String? message,
    bool clearMessage = false,
    ProductSort? sort,
    int? minPrice,
    int? maxPrice,
    bool updatePrices = false,
    int? categoryId,
    bool updateCategory = false,
    bool? priceRangeError,
  }) {
    return SearchState(
      query: query,
      items: items ?? this.items,
      facets: facets ?? this.facets,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      sample: sample ?? this.sample,
      degraded: degraded ?? this.degraded,
      failure: failure ?? this.failure,
      message: clearMessage ? message : (message ?? this.message),
      sort: sort ?? this.sort,
      minPrice: updatePrices ? minPrice : (minPrice ?? this.minPrice),
      maxPrice: updatePrices ? maxPrice : (maxPrice ?? this.maxPrice),
      categoryId: updateCategory ? categoryId : (categoryId ?? this.categoryId),
      priceRangeError: priceRangeError ?? this.priceRangeError,
    );
  }
}
