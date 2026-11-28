import 'buyer_dto.dart';

class ProductCardModel {
  const ProductCardModel({
    required this.id,
    required this.slug,
    required this.name,
    this.photoUrl,
    this.storeName,
    this.storeSlug,
    this.available = true,
    this.priceSyp,
    this.priceIsEstimate = false,
    this.canPurchase = true,
    this.averageRating,
    this.reviewsCount = 0,
    this.brandName,
    this.brandVerified = false,
    this.compareAtSyp,
    this.discountPercent,
    this.badgeLabels = const [],
    this.viewers,
    this.favoritesCount,
    this.sample = false,
  });

  final int id;
  final String slug;
  final String name;
  final String? photoUrl;
  final String? storeName;
  final String? storeSlug;
  final bool available;
  final int? priceSyp;
  final bool priceIsEstimate;
  final bool canPurchase;
  final double? averageRating;
  final int reviewsCount;

  /// `brand_name` / `brand_verified` from the card payload.
  final String? brandName;
  final bool brandVerified;

  /// `compare_at_syp` / `discount_percent`: a genuine struck price, if any.
  final int? compareAtSyp;
  final int? discountPercent;

  /// `badges[].label`, for example «منتج محلي».
  final List<String> badgeLabels;

  /// `viewer_activity`: how many people looked at it recently.
  final ViewerActivity? viewers;

  /// How many buyers favourited it. Null means the server has no count
  /// (show a red sample); 0 hides the line.
  // BACKEND: MISSING `favorites_count` on GET /products, /home, /search.
  final int? favoritesCount;
  final bool sample;

  String get ref => slug.isEmpty ? '$id' : slug;

  /// The bold lead-in on the card: brand first, store as a fallback.
  String? get sellerLabel => brandName ?? storeName;

  /// A struck compare-at price shows only when it is real and higher.
  bool get hasDiscount {
    final price = priceSyp;
    final compare = compareAtSyp;
    return price != null &&
        compare != null &&
        compare > price &&
        (discountPercent ?? 0) > 0;
  }
}

/// Unique viewers over the last [windowHours] hours.
class ViewerActivity {
  const ViewerActivity({required this.count, required this.windowHours});

  final int count;
  final int windowHours;
}

class ProductOptionModel {
  const ProductOptionModel({
    required this.id,
    required this.label,
    required this.available,
    required this.lowStock,
  });

  final int id;
  final String label;
  final bool available;
  final bool lowStock;
}

class ProductDetailModel {
  const ProductDetailModel({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.storeId,
    this.storeName,
    this.storeSlug,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.photoUrls = const [],
    this.options = const [],
    this.priceSyp,
    this.priceIsEstimate = false,
    this.canPurchase = true,
    this.available = true,
    this.averageRating,
    this.reviewsCount = 0,
    this.viewers,
    this.shareUrl,
    this.sample = false,
  });

  final int id;
  final String slug;
  final String name;
  final String? description;
  final int? storeId;
  final String? storeName;
  final String? storeSlug;
  final int? categoryId;
  final String? categoryName;
  final String? categorySlug;
  final List<String> photoUrls;
  final List<ProductOptionModel> options;
  final int? priceSyp;
  final bool priceIsEstimate;
  final bool canPurchase;
  final bool available;
  final double? averageRating;
  final int reviewsCount;

  /// `viewer_activity` on GET /products/{id}.
  final ViewerActivity? viewers;
  final String? shareUrl;
  final bool sample;

  ProductCardModel toCard() {
    return ProductCardModel(
      id: id,
      slug: slug,
      name: name,
      photoUrl: photoUrls.isEmpty ? null : photoUrls.first,
      storeName: storeName,
      storeSlug: storeSlug,
      available: available,
      priceSyp: priceSyp,
      priceIsEstimate: priceIsEstimate,
      canPurchase: canPurchase,
      averageRating: averageRating,
      reviewsCount: reviewsCount,
      viewers: viewers,
      sample: sample,
    );
  }
}

class CategoryNode {
  const CategoryNode({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.children = const [],
  });

  final int id;
  final String name;
  final String slug;
  final String? imageUrl;
  final List<CategoryNode> children;
}

class PageInfo {
  const PageInfo({
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  final int page;
  final int perPage;
  final int total;
  final int lastPage;
}

class ProductPage {
  const ProductPage({
    required this.items,
    required this.meta,
    this.sample = false,
  });

  final List<ProductCardModel> items;
  final PageInfo meta;
  final bool sample;
}

class CategoryFacet {
  const CategoryFacet({required this.id, required this.count, this.name});

  final int id;
  final int count;
  final String? name;
}

class SearchPage {
  const SearchPage({
    required this.query,
    required this.items,
    required this.meta,
    required this.degraded,
    required this.categoryFacets,
    this.sample = false,
  });

  final String query;
  final List<ProductCardModel> items;
  final PageInfo meta;
  final bool degraded;
  final List<CategoryFacet> categoryFacets;
  final bool sample;
}

class StoreModel {
  const StoreModel({
    required this.slug,
    this.id,
    this.name,
    this.description,
    this.areaLabel,
    this.followersCount,
    this.isFollowed,
    this.averageRating,
    this.reviewsCount,
    this.products = const [],
    this.sample = false,
  });

  final String slug;
  final int? id;
  final String? name;
  final String? description;
  final String? areaLabel;
  final int? followersCount;
  final bool? isFollowed;
  final double? averageRating;
  final int? reviewsCount;
  final List<ProductCardModel> products;
  final bool sample;
}

class HomeContent {
  const HomeContent({
    this.deliveryMessage,
    this.featured = const [],
    this.latest = const [],
    this.recentlyViewed = const [],
    this.sample = false,
  });

  final String? deliveryMessage;
  final List<ProductCardModel> featured;
  final List<ProductCardModel> latest;
  final List<ProductCardModel> recentlyViewed;
  final bool sample;
}

class HealthReport {
  const HealthReport({
    this.status,
    this.requestId,
    this.platformVersion,
    this.checks = const {},
  });

  final String? status;
  final String? requestId;
  final String? platformVersion;
  final Map<String, String> checks;

  bool get ok => status == 'ok';
}

class ServiceStatus {
  const ServiceStatus({
    required this.maintenanceActive,
    this.maintenanceMessageAr,
    this.overall,
  });

  final bool maintenanceActive;
  final String? maintenanceMessageAr;
  final String? overall;
}

class CityModel {
  const CityModel({
    required this.id,
    required this.name,
    this.code,
    this.isActive = false,
    this.status,
    this.label,
  });

  final int id;
  final String name;
  final String? code;
  final bool isActive;
  final String? status;
  final String? label;
}

ProductCardModel? mapCard(ProductCardDto dto, {bool sample = false}) {
  final id = dto.id;
  final name = dto.name;
  if (id == null || name == null || name.isEmpty) return null;
  final slug = dto.slug;
  return ProductCardModel(
    id: id,
    slug: slug == null || slug.isEmpty ? '$id' : slug,
    name: name,
    photoUrl: dto.photo,
    storeName: dto.storeName,
    storeSlug: dto.storeSlug,
    available: dto.available ?? true,
    priceSyp: dto.priceSyp,
    priceIsEstimate: dto.priceIsEstimate ?? false,
    canPurchase: dto.canPurchase ?? true,
    averageRating: dto.averageRating,
    reviewsCount: dto.reviewsCount ?? 0,
    brandName: dto.brandName,
    brandVerified: dto.brandVerified ?? false,
    compareAtSyp: dto.compareAtSyp,
    discountPercent: dto.discountPercent,
    badgeLabels: dto.badges ?? const [],
    viewers: _mapViewers(dto.viewerActivity),
    sample: sample,
  );
}

ViewerActivity? _mapViewers(ViewerActivityDto? dto) {
  final count = dto?.count;
  final hours = dto?.windowHours;
  if (count == null || count <= 0 || hours == null || hours <= 0) return null;
  return ViewerActivity(count: count, windowHours: hours);
}

List<ProductCardModel> mapCards(
  List<ProductCardDto>? cards, {
  bool sample = false,
}) {
  return [
    for (final dto in cards ?? const <ProductCardDto>[])
      if (mapCard(dto, sample: sample) case final card?) card,
  ];
}

PageInfo mapMeta(
  PageMetaDto? meta, {
  required int fallbackPage,
  required int fallbackPerPage,
  required int itemCount,
}) {
  final page = meta?.page ?? fallbackPage;
  final perPage = meta?.perPage ?? fallbackPerPage;
  final total = meta?.total ?? itemCount;
  final last = meta?.lastPage ?? 1;
  return PageInfo(
    page: page < 1 ? 1 : page,
    perPage: perPage < 1 ? fallbackPerPage : perPage,
    total: total < 0 ? 0 : total,
    lastPage: last < 1 ? 1 : last,
  );
}

HomeContent mapHome(HomeDto dto, {bool sample = false}) {
  return HomeContent(
    deliveryMessage: dto.deliveryPromise?.messageAr,
    featured: mapCards(dto.featured, sample: sample),
    latest: mapCards(dto.latest, sample: sample),
    recentlyViewed: mapCards(
      dto.recommendations?.recentlyViewed,
      sample: sample,
    ),
    sample: sample,
  );
}

ProductDetailModel? mapDetail(ProductDetailDto dto, {bool sample = false}) {
  final id = dto.id;
  final name = dto.name;
  if (id == null || name == null || name.isEmpty) return null;
  final slug = dto.slug;
  return ProductDetailModel(
    id: id,
    slug: slug == null || slug.isEmpty ? '$id' : slug,
    name: name,
    description: dto.description,
    storeId: dto.store?.id,
    storeName: dto.store?.name,
    storeSlug: dto.store?.slug,
    categoryId: dto.category?.id,
    categoryName: dto.category?.name,
    categorySlug: dto.category?.slug,
    photoUrls: dto.photos ?? const [],
    options: [
      for (final option in dto.options ?? const <ProductOptionDto>[])
        if (option.id != null && option.label != null)
          ProductOptionModel(
            id: option.id!,
            label: option.label!,
            available: option.available ?? true,
            lowStock: option.lowStockHint ?? false,
          ),
    ],
    priceSyp: dto.priceSyp,
    priceIsEstimate: dto.priceIsEstimate ?? false,
    canPurchase: dto.canPurchase ?? true,
    available: dto.available ?? true,
    averageRating: dto.averageRating,
    reviewsCount: dto.reviewsCount ?? 0,
    viewers: _mapViewers(dto.viewerActivity),
    shareUrl: dto.share?.url,
    sample: sample,
  );
}

List<CategoryNode> buildCategoryTree(List<CategoryDto> flat) {
  final byId = <int, CategoryDto>{};
  for (final dto in flat) {
    final id = dto.id;
    if (id != null) byId[id] = dto;
  }

  List<CategoryNode> childrenOf(int? parentId) {
    final kids = <CategoryNode>[];
    for (final dto in flat) {
      final id = dto.id;
      final name = dto.name;
      final slug = dto.slug;
      if (id == null ||
          name == null ||
          name.isEmpty ||
          slug == null ||
          slug.isEmpty) {
        continue;
      }
      final parent = dto.parentId;
      final isRoot =
          parentId == null && (parent == null || !byId.containsKey(parent));
      final isChild = parentId != null && parent == parentId;
      if (!isRoot && !isChild) continue;
      kids.add(
        CategoryNode(
          id: id,
          name: name,
          slug: slug,
          imageUrl: dto.image,
          children: childrenOf(id),
        ),
      );
    }
    return kids;
  }

  return childrenOf(null);
}

CategoryNode? findCategory(List<CategoryNode> nodes, String slug) {
  for (final node in nodes) {
    if (node.slug == slug) return node;
    final child = findCategory(node.children, slug);
    if (child != null) return child;
  }
  return null;
}

CategoryNode? findCategoryById(List<CategoryNode> nodes, int id) {
  for (final node in nodes) {
    if (node.id == id) return node;
    final child = findCategoryById(node.children, id);
    if (child != null) return child;
  }
  return null;
}

int? parseProductRef(String ref) {
  final match = RegExp(r'^(\d+)').firstMatch(ref.trim());
  if (match == null) return null;
  final id = int.tryParse(match.group(1)!);
  if (id == null || id <= 0) return null;
  return id;
}

StoreModel? mapStore(StoreDto dto, {bool sample = false}) {
  final slug = dto.slug;
  if (slug == null || slug.isEmpty) return null;
  final page = dto.products;
  return StoreModel(
    slug: slug,
    id: dto.id,
    name: dto.name,
    description: dto.description,
    areaLabel: dto.areaLabel,
    followersCount: dto.followersCount,
    isFollowed: dto.isFollowed,
    averageRating: dto.averageRating,
    reviewsCount: dto.reviewsCount,
    products: mapCards(page?.data, sample: sample),
    sample: sample,
  );
}

HealthReport mapHealth(HealthDto dto) {
  return HealthReport(
    status: dto.status,
    requestId: dto.requestId,
    platformVersion: dto.platform?.version,
    checks: dto.checks ?? const {},
  );
}

ServiceStatus mapStatus(MetaStatusDto dto) {
  return ServiceStatus(
    maintenanceActive: dto.maintenanceActive ?? false,
    maintenanceMessageAr: dto.maintenance?.message?.ar,
    overall: dto.overall,
  );
}

CityModel? mapCity(CityDto dto) {
  final id = dto.id;
  final name = dto.name;
  if (id == null || name == null || name.isEmpty) return null;
  return CityModel(
    id: id,
    name: name,
    code: dto.code,
    isActive: dto.isActive ?? false,
    status: dto.status,
    label: dto.label,
  );
}
