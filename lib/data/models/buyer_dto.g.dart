// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareDto _$ShareDtoFromJson(Map<String, dynamic> json) => _ShareDto(
  url: stringOrNull(json['url']),
  shareText: stringOrNull(json['share_text']),
);

Map<String, dynamic> _$ShareDtoToJson(_ShareDto instance) => <String, dynamic>{
  'url': instance.url,
  'share_text': instance.shareText,
};

_ProductCardDto _$ProductCardDtoFromJson(Map<String, dynamic> json) =>
    _ProductCardDto(
      id: intOrNull(json['id']),
      slug: stringOrNull(json['slug']),
      path: stringOrNull(json['path']),
      name: stringOrNull(json['name']),
      photo: photoUrlOrNull(json['photo']),
      storeName: stringOrNull(json['store_name']),
      storeSlug: stringOrNull(json['store_slug']),
      available: boolOrNull(json['available']),
      priceSyp: intOrNull(json['price_syp']),
      priceIsEstimate: boolOrNull(json['price_is_estimate']),
      canPurchase: boolOrNull(json['can_purchase']),
      currencyListed: stringOrNull(json['currency_listed']),
      isFavorited: boolOrNull(json['is_favorited']),
      averageRating: doubleOrNull(json['average_rating']),
      reviewsCount: intOrNull(json['reviews_count']),
      share: shareFromJson(json['share']),
    );

Map<String, dynamic> _$ProductCardDtoToJson(_ProductCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'path': instance.path,
      'name': instance.name,
      'photo': instance.photo,
      'store_name': instance.storeName,
      'store_slug': instance.storeSlug,
      'available': instance.available,
      'price_syp': instance.priceSyp,
      'price_is_estimate': instance.priceIsEstimate,
      'can_purchase': instance.canPurchase,
      'currency_listed': instance.currencyListed,
      'is_favorited': instance.isFavorited,
      'average_rating': instance.averageRating,
      'reviews_count': instance.reviewsCount,
      'share': shareToJson(instance.share),
    };

_ProductOptionDto _$ProductOptionDtoFromJson(Map<String, dynamic> json) =>
    _ProductOptionDto(
      id: intOrNull(json['id']),
      label: stringOrNull(json['label']),
      available: boolOrNull(json['available']),
      lowStockHint: boolOrNull(json['low_stock_hint']),
    );

Map<String, dynamic> _$ProductOptionDtoToJson(_ProductOptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'available': instance.available,
      'low_stock_hint': instance.lowStockHint,
    };

_StoreRefDto _$StoreRefDtoFromJson(Map<String, dynamic> json) => _StoreRefDto(
  id: intOrNull(json['id']),
  name: stringOrNull(json['name']),
  slug: stringOrNull(json['slug']),
);

Map<String, dynamic> _$StoreRefDtoToJson(_StoreRefDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_CategoryRefDto _$CategoryRefDtoFromJson(Map<String, dynamic> json) =>
    _CategoryRefDto(
      id: intOrNull(json['id']),
      name: stringOrNull(json['name']),
      slug: stringOrNull(json['slug']),
    );

Map<String, dynamic> _$CategoryRefDtoToJson(_CategoryRefDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_SeoAlternateDto _$SeoAlternateDtoFromJson(Map<String, dynamic> json) =>
    _SeoAlternateDto(
      hreflang: stringOrNull(json['hreflang']),
      href: stringOrNull(json['href']),
    );

Map<String, dynamic> _$SeoAlternateDtoToJson(_SeoAlternateDto instance) =>
    <String, dynamic>{'hreflang': instance.hreflang, 'href': instance.href};

_SeoDto _$SeoDtoFromJson(Map<String, dynamic> json) => _SeoDto(
  canonical: stringOrNull(json['canonical']),
  alternates: alternatesFromJson(json['alternates']),
);

Map<String, dynamic> _$SeoDtoToJson(_SeoDto instance) => <String, dynamic>{
  'canonical': instance.canonical,
  'alternates': alternatesToJson(instance.alternates),
};

_ProductDetailDto _$ProductDetailDtoFromJson(Map<String, dynamic> json) =>
    _ProductDetailDto(
      id: intOrNull(json['id']),
      slug: stringOrNull(json['slug']),
      path: stringOrNull(json['path']),
      name: stringOrNull(json['name']),
      description: stringOrNull(json['description']),
      store: storeRefFromJson(json['store']),
      category: categoryRefFromJson(json['category']),
      photos: photoListFromJson(json['photos']),
      options: optionsFromJson(json['options']),
      priceSyp: intOrNull(json['price_syp']),
      priceIsEstimate: boolOrNull(json['price_is_estimate']),
      canPurchase: boolOrNull(json['can_purchase']),
      available: boolOrNull(json['available']),
      currencyListed: stringOrNull(json['currency_listed']),
      isFavorited: boolOrNull(json['is_favorited']),
      averageRating: doubleOrNull(json['average_rating']),
      reviewsCount: intOrNull(json['reviews_count']),
      share: shareFromJson(json['share']),
      seo: seoFromJson(json['seo']),
    );

Map<String, dynamic> _$ProductDetailDtoToJson(_ProductDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'path': instance.path,
      'name': instance.name,
      'description': instance.description,
      'store': storeRefToJson(instance.store),
      'category': categoryRefToJson(instance.category),
      'photos': photoListToJson(instance.photos),
      'options': optionsToJson(instance.options),
      'price_syp': instance.priceSyp,
      'price_is_estimate': instance.priceIsEstimate,
      'can_purchase': instance.canPurchase,
      'available': instance.available,
      'currency_listed': instance.currencyListed,
      'is_favorited': instance.isFavorited,
      'average_rating': instance.averageRating,
      'reviews_count': instance.reviewsCount,
      'share': shareToJson(instance.share),
      'seo': seoToJson(instance.seo),
    };

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  id: intOrNull(json['id']),
  name: stringOrNull(json['name']),
  slug: stringOrNull(json['slug']),
  parentId: intOrNull(json['parent_id']),
  image: photoUrlOrNull(json['image']),
);

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'parent_id': instance.parentId,
      'image': instance.image,
    };

_CityDto _$CityDtoFromJson(Map<String, dynamic> json) => _CityDto(
  id: intOrNull(json['id']),
  name: stringOrNull(json['name']),
  code: stringOrNull(json['code']),
  isActive: boolOrNull(json['is_active']),
  status: stringOrNull(json['status']),
  label: stringOrNull(json['label']),
);

Map<String, dynamic> _$CityDtoToJson(_CityDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'is_active': instance.isActive,
  'status': instance.status,
  'label': instance.label,
};

_PageMetaDto _$PageMetaDtoFromJson(Map<String, dynamic> json) => _PageMetaDto(
  page: intOrNull(json['page']),
  perPage: intOrNull(json['per_page']),
  total: intOrNull(json['total']),
  lastPage: intOrNull(json['last_page']),
);

Map<String, dynamic> _$PageMetaDtoToJson(_PageMetaDto instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
      'total': instance.total,
      'last_page': instance.lastPage,
    };

_ProductPageDto _$ProductPageDtoFromJson(Map<String, dynamic> json) =>
    _ProductPageDto(
      data: cardsFromJson(json['data']),
      meta: pageMetaFromJson(json['meta']),
    );

Map<String, dynamic> _$ProductPageDtoToJson(_ProductPageDto instance) =>
    <String, dynamic>{
      'data': cardsToJson(instance.data),
      'meta': pageMetaToJson(instance.meta),
    };

_DeliveryPromiseDto _$DeliveryPromiseDtoFromJson(Map<String, dynamic> json) =>
    _DeliveryPromiseDto(
      messageAr: stringOrNull(json['message_ar']),
      updatedAt: stringOrNull(json['updated_at']),
    );

Map<String, dynamic> _$DeliveryPromiseDtoToJson(_DeliveryPromiseDto instance) =>
    <String, dynamic>{
      'message_ar': instance.messageAr,
      'updated_at': instance.updatedAt,
    };

_RecommendationsDto _$RecommendationsDtoFromJson(Map<String, dynamic> json) =>
    _RecommendationsDto(recentlyViewed: cardsFromJson(json['recently_viewed']));

Map<String, dynamic> _$RecommendationsDtoToJson(_RecommendationsDto instance) =>
    <String, dynamic>{'recently_viewed': cardsToJson(instance.recentlyViewed)};

_HomeDto _$HomeDtoFromJson(Map<String, dynamic> json) => _HomeDto(
  deliveryPromise: deliveryFromJson(json['delivery_promise']),
  featured: cardsFromJson(json['featured']),
  latest: cardsFromJson(json['latest']),
  recommendations: recommendationsFromJson(json['recommendations']),
);

Map<String, dynamic> _$HomeDtoToJson(_HomeDto instance) => <String, dynamic>{
  'delivery_promise': deliveryToJson(instance.deliveryPromise),
  'featured': cardsToJson(instance.featured),
  'latest': cardsToJson(instance.latest),
  'recommendations': recommendationsToJson(instance.recommendations),
};

_FacetBucketDto _$FacetBucketDtoFromJson(Map<String, dynamic> json) =>
    _FacetBucketDto(id: intOrNull(json['id']), count: intOrNull(json['count']));

Map<String, dynamic> _$FacetBucketDtoToJson(_FacetBucketDto instance) =>
    <String, dynamic>{'id': instance.id, 'count': instance.count};

_FacetsDto _$FacetsDtoFromJson(Map<String, dynamic> json) => _FacetsDto(
  category: facetsBucketsFromJson(json['category']),
  brand: facetsBucketsFromJson(json['brand']),
  store: facetsBucketsFromJson(json['store']),
);

Map<String, dynamic> _$FacetsDtoToJson(_FacetsDto instance) =>
    <String, dynamic>{
      'category': facetBucketsToJson(instance.category),
      'brand': facetBucketsToJson(instance.brand),
      'store': facetBucketsToJson(instance.store),
    };

_SearchInfoDto _$SearchInfoDtoFromJson(Map<String, dynamic> json) =>
    _SearchInfoDto(
      q: stringOrNull(json['q']),
      normalizedQ: stringOrNull(json['normalized_q']),
      engine: stringOrNull(json['engine']),
      degraded: boolOrNull(json['degraded']),
    );

Map<String, dynamic> _$SearchInfoDtoToJson(_SearchInfoDto instance) =>
    <String, dynamic>{
      'q': instance.q,
      'normalized_q': instance.normalizedQ,
      'engine': instance.engine,
      'degraded': instance.degraded,
    };

_SearchResponseDto _$SearchResponseDtoFromJson(Map<String, dynamic> json) =>
    _SearchResponseDto(
      search: searchInfoFromJson(json['search']),
      facets: facetsFromJson(json['facets']),
      data: cardsFromJson(json['data']),
      meta: pageMetaFromJson(json['meta']),
    );

Map<String, dynamic> _$SearchResponseDtoToJson(_SearchResponseDto instance) =>
    <String, dynamic>{
      'search': searchInfoToJson(instance.search),
      'facets': facetsToJson(instance.facets),
      'data': cardsToJson(instance.data),
      'meta': pageMetaToJson(instance.meta),
    };

_StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => _StoreDto(
  id: intOrNull(json['id']),
  name: stringOrNull(json['name']),
  slug: stringOrNull(json['slug']),
  description: stringOrNull(json['description']),
  areaLabel: stringOrNull(json['area_label']),
  followersCount: intOrNull(json['followers_count']),
  isFollowed: boolOrNull(json['is_followed']),
  averageRating: doubleOrNull(json['average_rating']),
  reviewsCount: intOrNull(json['reviews_count']),
  share: shareFromJson(json['share']),
  products: productPageFromJson(json['products']),
);

Map<String, dynamic> _$StoreDtoToJson(_StoreDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'area_label': instance.areaLabel,
  'followers_count': instance.followersCount,
  'is_followed': instance.isFollowed,
  'average_rating': instance.averageRating,
  'reviews_count': instance.reviewsCount,
  'share': shareToJson(instance.share),
  'products': productPageToJson(instance.products),
};

_PlatformDto _$PlatformDtoFromJson(Map<String, dynamic> json) =>
    _PlatformDto(version: stringOrNull(json['version']));

Map<String, dynamic> _$PlatformDtoToJson(_PlatformDto instance) =>
    <String, dynamic>{'version': instance.version};

_HealthDto _$HealthDtoFromJson(Map<String, dynamic> json) => _HealthDto(
  status: stringOrNull(json['status']),
  requestId: stringOrNull(json['request_id']),
  platform: platformFromJson(json['platform']),
  checks: stringMapOrEmpty(json['checks']),
);

Map<String, dynamic> _$HealthDtoToJson(_HealthDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'request_id': instance.requestId,
      'platform': platformToJson(instance.platform),
      'checks': instance.checks,
    };

_MaintenanceMessageDto _$MaintenanceMessageDtoFromJson(
  Map<String, dynamic> json,
) => _MaintenanceMessageDto(
  ar: stringOrNull(json['ar']),
  en: stringOrNull(json['en']),
);

Map<String, dynamic> _$MaintenanceMessageDtoToJson(
  _MaintenanceMessageDto instance,
) => <String, dynamic>{'ar': instance.ar, 'en': instance.en};

_MaintenanceWindowDto _$MaintenanceWindowDtoFromJson(
  Map<String, dynamic> json,
) => _MaintenanceWindowDto(
  startsAt: stringOrNull(json['starts_at']),
  endsAt: stringOrNull(json['ends_at']),
);

Map<String, dynamic> _$MaintenanceWindowDtoToJson(
  _MaintenanceWindowDto instance,
) => <String, dynamic>{
  'starts_at': instance.startsAt,
  'ends_at': instance.endsAt,
};

_MaintenanceDto _$MaintenanceDtoFromJson(Map<String, dynamic> json) =>
    _MaintenanceDto(
      forced: boolOrNull(json['forced']),
      scheduled: boolOrNull(json['scheduled']),
      window: windowFromJson(json['window']),
      message: messageFromJson(json['message']),
    );

Map<String, dynamic> _$MaintenanceDtoToJson(_MaintenanceDto instance) =>
    <String, dynamic>{
      'forced': instance.forced,
      'scheduled': instance.scheduled,
      'window': windowToJson(instance.window),
      'message': messageToJson(instance.message),
    };

_MetaStatusDto _$MetaStatusDtoFromJson(Map<String, dynamic> json) =>
    _MetaStatusDto(
      overall: stringOrNull(json['overall']),
      maintenanceActive: boolOrNull(json['maintenance_active']),
      maintenance: maintenanceFromJson(json['maintenance']),
    );

Map<String, dynamic> _$MetaStatusDtoToJson(_MetaStatusDto instance) =>
    <String, dynamic>{
      'overall': instance.overall,
      'maintenance_active': instance.maintenanceActive,
      'maintenance': maintenanceToJson(instance.maintenance),
    };
