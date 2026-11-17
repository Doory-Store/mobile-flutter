enum ProductSort {
  newest,
  priceAsc,
  priceDesc;

  String get apiValue => switch (this) {
    ProductSort.newest => 'newest',
    ProductSort.priceAsc => 'price_asc',
    ProductSort.priceDesc => 'price_desc',
  };

  static ProductSort parse(String? raw) {
    switch (raw) {
      case 'price_asc':
        return ProductSort.priceAsc;
      case 'price_desc':
        return ProductSort.priceDesc;
      default:
        return ProductSort.newest;
    }
  }
}

/// Query string for `/products` and `/search`.
///
/// The live API filters `category` by numeric id. An unknown string is ignored
/// and the endpoint returns the unfiltered catalog, so callers resolve a slug
/// to an id before building this query.
class ProductsQuery {
  const ProductsQuery({
    this.categoryId,
    this.store,
    this.brand,
    this.sort = ProductSort.newest,
    this.minPriceSyp,
    this.maxPriceSyp,
    this.cityId,
    this.page = 1,
    this.perPage = 24,
    this.q,
  });

  final int? categoryId;
  final String? store;
  final String? brand;
  final ProductSort sort;
  final int? minPriceSyp;
  final int? maxPriceSyp;
  final int? cityId;
  final int page;
  final int perPage;
  final String? q;

  bool get hasInvertedPrices =>
      minPriceSyp != null && maxPriceSyp != null && minPriceSyp! > maxPriceSyp!;

  bool get hasEmptySearch => q == null || q!.trim().isEmpty;

  /// Null means the request must not be sent (inverted prices, or search
  /// without `q`).
  Map<String, dynamic>? toQuery({required bool search}) {
    if (hasInvertedPrices) return null;
    if (search && hasEmptySearch) return null;
    final query = <String, dynamic>{
      'page': page < 1 ? 1 : page,
      'per_page': perPage < 1 ? 24 : perPage,
    };
    if (categoryId != null) query['category'] = categoryId;
    if (store != null && store!.isNotEmpty) query['store'] = store;
    if (brand != null && brand!.isNotEmpty) query['brand'] = brand;
    if (sort != ProductSort.newest) query['sort'] = sort.apiValue;
    if (minPriceSyp != null && minPriceSyp! >= 0) {
      query['min_price_syp'] = minPriceSyp;
    }
    if (maxPriceSyp != null && maxPriceSyp! >= 0) {
      query['max_price_syp'] = maxPriceSyp;
    }
    if (cityId != null) query['city_id'] = cityId;
    if (search) query['q'] = q!.trim();
    return query;
  }
}

int clampPage(int page, int lastPage) {
  final last = lastPage < 1 ? 1 : lastPage;
  if (page < 1) return 1;
  if (page > last) return last;
  return page;
}
