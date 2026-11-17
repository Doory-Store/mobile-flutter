import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/network/json_coercion.dart';

part 'buyer_dto.freezed.dart';
part 'buyer_dto.g.dart';

ShareDto? shareFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return ShareDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? shareToJson(ShareDto? value) => value?.toJson();

DeliveryPromiseDto? deliveryFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return DeliveryPromiseDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? deliveryToJson(DeliveryPromiseDto? value) =>
    value?.toJson();

RecommendationsDto? recommendationsFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return RecommendationsDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? recommendationsToJson(RecommendationsDto? value) =>
    value?.toJson();

PageMetaDto? pageMetaFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return PageMetaDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? pageMetaToJson(PageMetaDto? value) => value?.toJson();

StoreRefDto? storeRefFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return StoreRefDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? storeRefToJson(StoreRefDto? value) => value?.toJson();

CategoryRefDto? categoryRefFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return CategoryRefDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? categoryRefToJson(CategoryRefDto? value) =>
    value?.toJson();

SearchInfoDto? searchInfoFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return SearchInfoDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? searchInfoToJson(SearchInfoDto? value) => value?.toJson();

FacetsDto? facetsFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return FacetsDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? facetsToJson(FacetsDto? value) => value?.toJson();

PlatformDto? platformFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return PlatformDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? platformToJson(PlatformDto? value) => value?.toJson();

MaintenanceDto? maintenanceFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return MaintenanceDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? maintenanceToJson(MaintenanceDto? value) =>
    value?.toJson();

MaintenanceWindowDto? windowFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return MaintenanceWindowDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? windowToJson(MaintenanceWindowDto? value) =>
    value?.toJson();

MaintenanceMessageDto? messageFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return MaintenanceMessageDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? messageToJson(MaintenanceMessageDto? value) =>
    value?.toJson();

SeoDto? seoFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return SeoDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? seoToJson(SeoDto? value) => value?.toJson();

ProductPageDto? productPageFromJson(Object? raw) {
  if (raw is! Map) return null;
  try {
    return ProductPageDto.fromJson(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? productPageToJson(ProductPageDto? value) =>
    value?.toJson();

List<ProductCardDto> cardsFromJson(Object? raw) {
  if (raw is! List) return const [];
  final out = <ProductCardDto>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      out.add(ProductCardDto.fromJson(Map<String, dynamic>.from(item)));
    } catch (_) {}
  }
  return out;
}

List<Map<String, dynamic>> cardsToJson(List<ProductCardDto>? raw) => [
  for (final card in raw ?? const <ProductCardDto>[]) card.toJson(),
];

List<ProductOptionDto> optionsFromJson(Object? raw) {
  if (raw is! List) return const [];
  final out = <ProductOptionDto>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      out.add(ProductOptionDto.fromJson(Map<String, dynamic>.from(item)));
    } catch (_) {}
  }
  return out;
}

List<Map<String, dynamic>> optionsToJson(List<ProductOptionDto>? raw) => [
  for (final option in raw ?? const <ProductOptionDto>[]) option.toJson(),
];

List<CategoryDto> categoriesFromJson(Object? raw) {
  if (raw is! List) return const [];
  final out = <CategoryDto>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      out.add(CategoryDto.fromJson(Map<String, dynamic>.from(item)));
    } catch (_) {}
  }
  return out;
}

List<FacetBucketDto> facetsBucketsFromJson(Object? raw) {
  if (raw is! List) return const [];
  final out = <FacetBucketDto>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      out.add(FacetBucketDto.fromJson(Map<String, dynamic>.from(item)));
    } catch (_) {}
  }
  return out;
}

List<Map<String, dynamic>> facetBucketsToJson(List<FacetBucketDto>? raw) => [
  for (final bucket in raw ?? const <FacetBucketDto>[]) bucket.toJson(),
];

List<SeoAlternateDto> alternatesFromJson(Object? raw) {
  if (raw is! List) return const [];
  final out = <SeoAlternateDto>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      out.add(SeoAlternateDto.fromJson(Map<String, dynamic>.from(item)));
    } catch (_) {}
  }
  return out;
}

List<Map<String, dynamic>> alternatesToJson(List<SeoAlternateDto>? raw) => [
  for (final item in raw ?? const <SeoAlternateDto>[]) item.toJson(),
];

@freezed
abstract class ShareDto with _$ShareDto {
  const factory ShareDto({
    @JsonKey(fromJson: stringOrNull) String? url,
    @JsonKey(fromJson: stringOrNull) String? shareText,
  }) = _ShareDto;

  factory ShareDto.fromJson(Map<String, dynamic> json) =>
      _$ShareDtoFromJson(json);
}

@freezed
abstract class ProductCardDto with _$ProductCardDto {
  const factory ProductCardDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? slug,
    @JsonKey(fromJson: stringOrNull) String? path,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: photoUrlOrNull) String? photo,
    @JsonKey(fromJson: stringOrNull) String? storeName,
    @JsonKey(fromJson: stringOrNull) String? storeSlug,
    @JsonKey(fromJson: boolOrNull) bool? available,
    @JsonKey(fromJson: intOrNull) int? priceSyp,
    @JsonKey(fromJson: boolOrNull) bool? priceIsEstimate,
    @JsonKey(fromJson: boolOrNull) bool? canPurchase,
    @JsonKey(fromJson: stringOrNull) String? currencyListed,
    @JsonKey(fromJson: boolOrNull) bool? isFavorited,
    @JsonKey(fromJson: doubleOrNull) double? averageRating,
    @JsonKey(fromJson: intOrNull) int? reviewsCount,
    @JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,
  }) = _ProductCardDto;

  factory ProductCardDto.fromJson(Map<String, dynamic> json) =>
      _$ProductCardDtoFromJson(json);
}

@freezed
abstract class ProductOptionDto with _$ProductOptionDto {
  const factory ProductOptionDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? label,
    @JsonKey(fromJson: boolOrNull) bool? available,
    @JsonKey(fromJson: boolOrNull) bool? lowStockHint,
  }) = _ProductOptionDto;

  factory ProductOptionDto.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionDtoFromJson(json);
}

@freezed
abstract class StoreRefDto with _$StoreRefDto {
  const factory StoreRefDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: stringOrNull) String? slug,
  }) = _StoreRefDto;

  factory StoreRefDto.fromJson(Map<String, dynamic> json) =>
      _$StoreRefDtoFromJson(json);
}

@freezed
abstract class CategoryRefDto with _$CategoryRefDto {
  const factory CategoryRefDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: stringOrNull) String? slug,
  }) = _CategoryRefDto;

  factory CategoryRefDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryRefDtoFromJson(json);
}

@freezed
abstract class SeoAlternateDto with _$SeoAlternateDto {
  const factory SeoAlternateDto({
    @JsonKey(fromJson: stringOrNull) String? hreflang,
    @JsonKey(fromJson: stringOrNull) String? href,
  }) = _SeoAlternateDto;

  factory SeoAlternateDto.fromJson(Map<String, dynamic> json) =>
      _$SeoAlternateDtoFromJson(json);
}

@freezed
abstract class SeoDto with _$SeoDto {
  const factory SeoDto({
    @JsonKey(fromJson: stringOrNull) String? canonical,
    @JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson)
    List<SeoAlternateDto>? alternates,
  }) = _SeoDto;

  factory SeoDto.fromJson(Map<String, dynamic> json) => _$SeoDtoFromJson(json);
}

@freezed
abstract class ProductDetailDto with _$ProductDetailDto {
  const factory ProductDetailDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? slug,
    @JsonKey(fromJson: stringOrNull) String? path,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: stringOrNull) String? description,
    @JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson)
    StoreRefDto? store,
    @JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson)
    CategoryRefDto? category,
    @JsonKey(fromJson: photoListFromJson, toJson: photoListToJson)
    List<String>? photos,
    @JsonKey(fromJson: optionsFromJson, toJson: optionsToJson)
    List<ProductOptionDto>? options,
    @JsonKey(fromJson: intOrNull) int? priceSyp,
    @JsonKey(fromJson: boolOrNull) bool? priceIsEstimate,
    @JsonKey(fromJson: boolOrNull) bool? canPurchase,
    @JsonKey(fromJson: boolOrNull) bool? available,
    @JsonKey(fromJson: stringOrNull) String? currencyListed,
    @JsonKey(fromJson: boolOrNull) bool? isFavorited,
    @JsonKey(fromJson: doubleOrNull) double? averageRating,
    @JsonKey(fromJson: intOrNull) int? reviewsCount,
    @JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,
    @JsonKey(fromJson: seoFromJson, toJson: seoToJson) SeoDto? seo,
  }) = _ProductDetailDto;

  factory ProductDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailDtoFromJson(json);
}

@freezed
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: stringOrNull) String? slug,
    @JsonKey(fromJson: intOrNull) int? parentId,
    @JsonKey(fromJson: photoUrlOrNull) String? image,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}

@freezed
abstract class CityDto with _$CityDto {
  const factory CityDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: stringOrNull) String? code,
    @JsonKey(fromJson: boolOrNull) bool? isActive,
    @JsonKey(fromJson: stringOrNull) String? status,
    @JsonKey(fromJson: stringOrNull) String? label,
  }) = _CityDto;

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);
}

@freezed
abstract class PageMetaDto with _$PageMetaDto {
  const factory PageMetaDto({
    @JsonKey(fromJson: intOrNull) int? page,
    @JsonKey(fromJson: intOrNull) int? perPage,
    @JsonKey(fromJson: intOrNull) int? total,
    @JsonKey(fromJson: intOrNull) int? lastPage,
  }) = _PageMetaDto;

  factory PageMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PageMetaDtoFromJson(json);
}

@freezed
abstract class ProductPageDto with _$ProductPageDto {
  const factory ProductPageDto({
    @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)
    List<ProductCardDto>? data,
    @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)
    PageMetaDto? meta,
  }) = _ProductPageDto;

  factory ProductPageDto.fromJson(Map<String, dynamic> json) =>
      _$ProductPageDtoFromJson(json);
}

@freezed
abstract class DeliveryPromiseDto with _$DeliveryPromiseDto {
  const factory DeliveryPromiseDto({
    @JsonKey(fromJson: stringOrNull) String? messageAr,
    @JsonKey(fromJson: stringOrNull) String? updatedAt,
  }) = _DeliveryPromiseDto;

  factory DeliveryPromiseDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPromiseDtoFromJson(json);
}

@freezed
abstract class RecommendationsDto with _$RecommendationsDto {
  const factory RecommendationsDto({
    @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)
    List<ProductCardDto>? recentlyViewed,
  }) = _RecommendationsDto;

  factory RecommendationsDto.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsDtoFromJson(json);
}

@freezed
abstract class HomeDto with _$HomeDto {
  const factory HomeDto({
    @JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson)
    DeliveryPromiseDto? deliveryPromise,
    @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)
    List<ProductCardDto>? featured,
    @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)
    List<ProductCardDto>? latest,
    @JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson)
    RecommendationsDto? recommendations,
  }) = _HomeDto;

  factory HomeDto.fromJson(Map<String, dynamic> json) =>
      _$HomeDtoFromJson(json);
}

@freezed
abstract class FacetBucketDto with _$FacetBucketDto {
  const factory FacetBucketDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: intOrNull) int? count,
  }) = _FacetBucketDto;

  factory FacetBucketDto.fromJson(Map<String, dynamic> json) =>
      _$FacetBucketDtoFromJson(json);
}

@freezed
abstract class FacetsDto with _$FacetsDto {
  const factory FacetsDto({
    @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)
    List<FacetBucketDto>? category,
    @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)
    List<FacetBucketDto>? brand,
    @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)
    List<FacetBucketDto>? store,
  }) = _FacetsDto;

  factory FacetsDto.fromJson(Map<String, dynamic> json) =>
      _$FacetsDtoFromJson(json);
}

@freezed
abstract class SearchInfoDto with _$SearchInfoDto {
  const factory SearchInfoDto({
    @JsonKey(fromJson: stringOrNull) String? q,
    @JsonKey(fromJson: stringOrNull) String? normalizedQ,
    @JsonKey(fromJson: stringOrNull) String? engine,
    @JsonKey(fromJson: boolOrNull) bool? degraded,
  }) = _SearchInfoDto;

  factory SearchInfoDto.fromJson(Map<String, dynamic> json) =>
      _$SearchInfoDtoFromJson(json);
}

@freezed
abstract class SearchResponseDto with _$SearchResponseDto {
  const factory SearchResponseDto({
    @JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson)
    SearchInfoDto? search,
    @JsonKey(fromJson: facetsFromJson, toJson: facetsToJson) FacetsDto? facets,
    @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)
    List<ProductCardDto>? data,
    @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)
    PageMetaDto? meta,
  }) = _SearchResponseDto;

  factory SearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseDtoFromJson(json);
}

@freezed
abstract class StoreDto with _$StoreDto {
  const factory StoreDto({
    @JsonKey(fromJson: intOrNull) int? id,
    @JsonKey(fromJson: stringOrNull) String? name,
    @JsonKey(fromJson: stringOrNull) String? slug,
    @JsonKey(fromJson: stringOrNull) String? description,
    @JsonKey(fromJson: stringOrNull) String? areaLabel,
    @JsonKey(fromJson: intOrNull) int? followersCount,
    @JsonKey(fromJson: boolOrNull) bool? isFollowed,
    @JsonKey(fromJson: doubleOrNull) double? averageRating,
    @JsonKey(fromJson: intOrNull) int? reviewsCount,
    @JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,
    @JsonKey(fromJson: productPageFromJson, toJson: productPageToJson)
    ProductPageDto? products,
  }) = _StoreDto;

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);
}

@freezed
abstract class PlatformDto with _$PlatformDto {
  const factory PlatformDto({
    @JsonKey(fromJson: stringOrNull) String? version,
  }) = _PlatformDto;

  factory PlatformDto.fromJson(Map<String, dynamic> json) =>
      _$PlatformDtoFromJson(json);
}

@freezed
abstract class HealthDto with _$HealthDto {
  const factory HealthDto({
    @JsonKey(fromJson: stringOrNull) String? status,
    @JsonKey(fromJson: stringOrNull) String? requestId,
    @JsonKey(fromJson: platformFromJson, toJson: platformToJson)
    PlatformDto? platform,
    @JsonKey(fromJson: stringMapOrEmpty) Map<String, String>? checks,
  }) = _HealthDto;

  factory HealthDto.fromJson(Map<String, dynamic> json) =>
      _$HealthDtoFromJson(json);
}

@freezed
abstract class MaintenanceMessageDto with _$MaintenanceMessageDto {
  const factory MaintenanceMessageDto({
    @JsonKey(fromJson: stringOrNull) String? ar,
    @JsonKey(fromJson: stringOrNull) String? en,
  }) = _MaintenanceMessageDto;

  factory MaintenanceMessageDto.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceMessageDtoFromJson(json);
}

@freezed
abstract class MaintenanceWindowDto with _$MaintenanceWindowDto {
  const factory MaintenanceWindowDto({
    @JsonKey(fromJson: stringOrNull) String? startsAt,
    @JsonKey(fromJson: stringOrNull) String? endsAt,
  }) = _MaintenanceWindowDto;

  factory MaintenanceWindowDto.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceWindowDtoFromJson(json);
}

@freezed
abstract class MaintenanceDto with _$MaintenanceDto {
  const factory MaintenanceDto({
    @JsonKey(fromJson: boolOrNull) bool? forced,
    @JsonKey(fromJson: boolOrNull) bool? scheduled,
    @JsonKey(fromJson: windowFromJson, toJson: windowToJson)
    MaintenanceWindowDto? window,
    @JsonKey(fromJson: messageFromJson, toJson: messageToJson)
    MaintenanceMessageDto? message,
  }) = _MaintenanceDto;

  factory MaintenanceDto.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceDtoFromJson(json);
}

@freezed
abstract class MetaStatusDto with _$MetaStatusDto {
  const factory MetaStatusDto({
    @JsonKey(fromJson: stringOrNull) String? overall,
    @JsonKey(fromJson: boolOrNull) bool? maintenanceActive,
    @JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson)
    MaintenanceDto? maintenance,
  }) = _MetaStatusDto;

  factory MetaStatusDto.fromJson(Map<String, dynamic> json) =>
      _$MetaStatusDtoFromJson(json);
}

/// Exposed for tests that decode a raw category list.
List<CategoryDto> decodeCategoryList(Object? raw) => categoriesFromJson(raw);

List<CityDto> decodeCityList(Object? raw) {
  if (raw is! List) return const [];
  final out = <CityDto>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      out.add(CityDto.fromJson(Map<String, dynamic>.from(item)));
    } catch (_) {}
  }
  return out;
}
