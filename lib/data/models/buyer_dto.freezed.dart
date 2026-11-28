// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'buyer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShareDto {

@JsonKey(fromJson: stringOrNull) String? get url;@JsonKey(fromJson: stringOrNull) String? get shareText;
/// Create a copy of ShareDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<ShareDto> get copyWith => _$ShareDtoCopyWithImpl<ShareDto>(this as ShareDto, _$identity);

  /// Serializes this ShareDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ShareDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareDto&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.shareText, _this.shareText) || other.shareText == _this.shareText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShareDto;
  return Object.hash(runtimeType,_this.url,_this.shareText);
}

@override
String toString() {
  final _this = this as ShareDto;
  return 'ShareDto(url: ${_this.url}, shareText: ${_this.shareText})';
}


}

/// @nodoc
abstract mixin class $ShareDtoCopyWith<$Res>  {
  factory $ShareDtoCopyWith(ShareDto value, $Res Function(ShareDto) _then) = _$ShareDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? url,@JsonKey(fromJson: stringOrNull) String? shareText
});




}
/// @nodoc
class _$ShareDtoCopyWithImpl<$Res>
    implements $ShareDtoCopyWith<$Res> {
  _$ShareDtoCopyWithImpl(this._self, this._then);

  final ShareDto _self;
  final $Res Function(ShareDto) _then;

/// Create a copy of ShareDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? shareText = freezed,}) {
  return _then(ShareDto(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,shareText: freezed == shareText ? _self.shareText : shareText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShareDto].
extension ShareDtoPatterns on ShareDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShareDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShareDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShareDto value)  $default,){
final _that = this;
switch (_that) {
case _ShareDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShareDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShareDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? url, @JsonKey(fromJson: stringOrNull)  String? shareText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShareDto() when $default != null:
return $default(_that.url,_that.shareText);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? url, @JsonKey(fromJson: stringOrNull)  String? shareText)  $default,) {final _that = this;
switch (_that) {
case _ShareDto():
return $default(_that.url,_that.shareText);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? url, @JsonKey(fromJson: stringOrNull)  String? shareText)?  $default,) {final _that = this;
switch (_that) {
case _ShareDto() when $default != null:
return $default(_that.url,_that.shareText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShareDto implements ShareDto {
  const _ShareDto({@JsonKey(fromJson: stringOrNull) this.url, @JsonKey(fromJson: stringOrNull) this.shareText});
  factory _ShareDto.fromJson(Map<String, dynamic> json) => _$ShareDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? url;
@override@JsonKey(fromJson: stringOrNull) final  String? shareText;

/// Create a copy of ShareDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareDtoCopyWith<_ShareDto> get copyWith => __$ShareDtoCopyWithImpl<_ShareDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShareDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareDto&&(identical(other.url, url) || other.url == url)&&(identical(other.shareText, shareText) || other.shareText == shareText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,shareText);
}

@override
String toString() {
    return 'ShareDto(url: $url, shareText: $shareText)';
}


}

/// @nodoc
abstract mixin class _$ShareDtoCopyWith<$Res> implements $ShareDtoCopyWith<$Res> {
  factory _$ShareDtoCopyWith(_ShareDto value, $Res Function(_ShareDto) _then) = __$ShareDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? url,@JsonKey(fromJson: stringOrNull) String? shareText
});




}
/// @nodoc
class __$ShareDtoCopyWithImpl<$Res>
    implements _$ShareDtoCopyWith<$Res> {
  __$ShareDtoCopyWithImpl(this._self, this._then);

  final _ShareDto _self;
  final $Res Function(_ShareDto) _then;

/// Create a copy of ShareDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? shareText = freezed,}) {
  return _then(_ShareDto(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,shareText: freezed == shareText ? _self.shareText : shareText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductCardDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get slug;@JsonKey(fromJson: stringOrNull) String? get path;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: photoUrlOrNull) String? get photo;@JsonKey(fromJson: stringOrNull) String? get storeName;@JsonKey(fromJson: stringOrNull) String? get storeSlug;@JsonKey(fromJson: boolOrNull) bool? get available;@JsonKey(fromJson: intOrNull) int? get priceSyp;@JsonKey(fromJson: boolOrNull) bool? get priceIsEstimate;@JsonKey(fromJson: boolOrNull) bool? get canPurchase;@JsonKey(fromJson: stringOrNull) String? get currencyListed;@JsonKey(fromJson: boolOrNull) bool? get isFavorited;@JsonKey(fromJson: doubleOrNull) double? get averageRating;@JsonKey(fromJson: intOrNull) int? get reviewsCount;@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? get share;@JsonKey(fromJson: stringOrNull) String? get brandName;@JsonKey(fromJson: boolOrNull) bool? get brandVerified;@JsonKey(fromJson: intOrNull) int? get compareAtSyp;@JsonKey(fromJson: intOrNull) int? get discountPercent;@JsonKey(fromJson: badgeLabelsFromJson) List<String>? get badges;@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) ViewerActivityDto? get viewerActivity;
/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCardDtoCopyWith<ProductCardDto> get copyWith => _$ProductCardDtoCopyWithImpl<ProductCardDto>(this as ProductCardDto, _$identity);

  /// Serializes this ProductCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductCardDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCardDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.photo, _this.photo) || other.photo == _this.photo)&&(identical(other.storeName, _this.storeName) || other.storeName == _this.storeName)&&(identical(other.storeSlug, _this.storeSlug) || other.storeSlug == _this.storeSlug)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.priceSyp, _this.priceSyp) || other.priceSyp == _this.priceSyp)&&(identical(other.priceIsEstimate, _this.priceIsEstimate) || other.priceIsEstimate == _this.priceIsEstimate)&&(identical(other.canPurchase, _this.canPurchase) || other.canPurchase == _this.canPurchase)&&(identical(other.currencyListed, _this.currencyListed) || other.currencyListed == _this.currencyListed)&&(identical(other.isFavorited, _this.isFavorited) || other.isFavorited == _this.isFavorited)&&(identical(other.averageRating, _this.averageRating) || other.averageRating == _this.averageRating)&&(identical(other.reviewsCount, _this.reviewsCount) || other.reviewsCount == _this.reviewsCount)&&(identical(other.share, _this.share) || other.share == _this.share)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.brandVerified, _this.brandVerified) || other.brandVerified == _this.brandVerified)&&(identical(other.compareAtSyp, _this.compareAtSyp) || other.compareAtSyp == _this.compareAtSyp)&&(identical(other.discountPercent, _this.discountPercent) || other.discountPercent == _this.discountPercent)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&(identical(other.viewerActivity, _this.viewerActivity) || other.viewerActivity == _this.viewerActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductCardDto;
  return Object.hashAll([runtimeType,_this.id,_this.slug,_this.path,_this.name,_this.photo,_this.storeName,_this.storeSlug,_this.available,_this.priceSyp,_this.priceIsEstimate,_this.canPurchase,_this.currencyListed,_this.isFavorited,_this.averageRating,_this.reviewsCount,_this.share,_this.brandName,_this.brandVerified,_this.compareAtSyp,_this.discountPercent,const DeepCollectionEquality().hash(_this.badges),_this.viewerActivity]);
}

@override
String toString() {
  final _this = this as ProductCardDto;
  return 'ProductCardDto(id: ${_this.id}, slug: ${_this.slug}, path: ${_this.path}, name: ${_this.name}, photo: ${_this.photo}, storeName: ${_this.storeName}, storeSlug: ${_this.storeSlug}, available: ${_this.available}, priceSyp: ${_this.priceSyp}, priceIsEstimate: ${_this.priceIsEstimate}, canPurchase: ${_this.canPurchase}, currencyListed: ${_this.currencyListed}, isFavorited: ${_this.isFavorited}, averageRating: ${_this.averageRating}, reviewsCount: ${_this.reviewsCount}, share: ${_this.share}, brandName: ${_this.brandName}, brandVerified: ${_this.brandVerified}, compareAtSyp: ${_this.compareAtSyp}, discountPercent: ${_this.discountPercent}, badges: ${_this.badges}, viewerActivity: ${_this.viewerActivity})';
}


}

/// @nodoc
abstract mixin class $ProductCardDtoCopyWith<$Res>  {
  factory $ProductCardDtoCopyWith(ProductCardDto value, $Res Function(ProductCardDto) _then) = _$ProductCardDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: stringOrNull) String? path,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: photoUrlOrNull) String? photo,@JsonKey(fromJson: stringOrNull) String? storeName,@JsonKey(fromJson: stringOrNull) String? storeSlug,@JsonKey(fromJson: boolOrNull) bool? available,@JsonKey(fromJson: intOrNull) int? priceSyp,@JsonKey(fromJson: boolOrNull) bool? priceIsEstimate,@JsonKey(fromJson: boolOrNull) bool? canPurchase,@JsonKey(fromJson: stringOrNull) String? currencyListed,@JsonKey(fromJson: boolOrNull) bool? isFavorited,@JsonKey(fromJson: doubleOrNull) double? averageRating,@JsonKey(fromJson: intOrNull) int? reviewsCount,@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,@JsonKey(fromJson: stringOrNull) String? brandName,@JsonKey(fromJson: boolOrNull) bool? brandVerified,@JsonKey(fromJson: intOrNull) int? compareAtSyp,@JsonKey(fromJson: intOrNull) int? discountPercent,@JsonKey(fromJson: badgeLabelsFromJson) List<String>? badges,@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) ViewerActivityDto? viewerActivity
});


$ShareDtoCopyWith<$Res>? get share;$ViewerActivityDtoCopyWith<$Res>? get viewerActivity;

}
/// @nodoc
class _$ProductCardDtoCopyWithImpl<$Res>
    implements $ProductCardDtoCopyWith<$Res> {
  _$ProductCardDtoCopyWithImpl(this._self, this._then);

  final ProductCardDto _self;
  final $Res Function(ProductCardDto) _then;

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? slug = freezed,Object? path = freezed,Object? name = freezed,Object? photo = freezed,Object? storeName = freezed,Object? storeSlug = freezed,Object? available = freezed,Object? priceSyp = freezed,Object? priceIsEstimate = freezed,Object? canPurchase = freezed,Object? currencyListed = freezed,Object? isFavorited = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? share = freezed,Object? brandName = freezed,Object? brandVerified = freezed,Object? compareAtSyp = freezed,Object? discountPercent = freezed,Object? badges = freezed,Object? viewerActivity = freezed,}) {
  return _then(ProductCardDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,storeSlug: freezed == storeSlug ? _self.storeSlug : storeSlug // ignore: cast_nullable_to_non_nullable
as String?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,priceSyp: freezed == priceSyp ? _self.priceSyp : priceSyp // ignore: cast_nullable_to_non_nullable
as int?,priceIsEstimate: freezed == priceIsEstimate ? _self.priceIsEstimate : priceIsEstimate // ignore: cast_nullable_to_non_nullable
as bool?,canPurchase: freezed == canPurchase ? _self.canPurchase : canPurchase // ignore: cast_nullable_to_non_nullable
as bool?,currencyListed: freezed == currencyListed ? _self.currencyListed : currencyListed // ignore: cast_nullable_to_non_nullable
as String?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareDto?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,brandVerified: freezed == brandVerified ? _self.brandVerified : brandVerified // ignore: cast_nullable_to_non_nullable
as bool?,compareAtSyp: freezed == compareAtSyp ? _self.compareAtSyp : compareAtSyp // ignore: cast_nullable_to_non_nullable
as int?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,badges: freezed == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>?,viewerActivity: freezed == viewerActivity ? _self.viewerActivity : viewerActivity // ignore: cast_nullable_to_non_nullable
as ViewerActivityDto?,
  ));
}
/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareDtoCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerActivityDtoCopyWith<$Res>? get viewerActivity {
    if (_self.viewerActivity == null) {
    return null;
  }

  return $ViewerActivityDtoCopyWith<$Res>(_self.viewerActivity!, (value) {
    return _then(_self.copyWith(viewerActivity: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductCardDto].
extension ProductCardDtoPatterns on ProductCardDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCardDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductCardDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? path, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: photoUrlOrNull)  String? photo, @JsonKey(fromJson: stringOrNull)  String? storeName, @JsonKey(fromJson: stringOrNull)  String? storeSlug, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: intOrNull)  int? priceSyp, @JsonKey(fromJson: boolOrNull)  bool? priceIsEstimate, @JsonKey(fromJson: boolOrNull)  bool? canPurchase, @JsonKey(fromJson: stringOrNull)  String? currencyListed, @JsonKey(fromJson: boolOrNull)  bool? isFavorited, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: stringOrNull)  String? brandName, @JsonKey(fromJson: boolOrNull)  bool? brandVerified, @JsonKey(fromJson: intOrNull)  int? compareAtSyp, @JsonKey(fromJson: intOrNull)  int? discountPercent, @JsonKey(fromJson: badgeLabelsFromJson)  List<String>? badges, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson)  ViewerActivityDto? viewerActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
return $default(_that.id,_that.slug,_that.path,_that.name,_that.photo,_that.storeName,_that.storeSlug,_that.available,_that.priceSyp,_that.priceIsEstimate,_that.canPurchase,_that.currencyListed,_that.isFavorited,_that.averageRating,_that.reviewsCount,_that.share,_that.brandName,_that.brandVerified,_that.compareAtSyp,_that.discountPercent,_that.badges,_that.viewerActivity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? path, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: photoUrlOrNull)  String? photo, @JsonKey(fromJson: stringOrNull)  String? storeName, @JsonKey(fromJson: stringOrNull)  String? storeSlug, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: intOrNull)  int? priceSyp, @JsonKey(fromJson: boolOrNull)  bool? priceIsEstimate, @JsonKey(fromJson: boolOrNull)  bool? canPurchase, @JsonKey(fromJson: stringOrNull)  String? currencyListed, @JsonKey(fromJson: boolOrNull)  bool? isFavorited, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: stringOrNull)  String? brandName, @JsonKey(fromJson: boolOrNull)  bool? brandVerified, @JsonKey(fromJson: intOrNull)  int? compareAtSyp, @JsonKey(fromJson: intOrNull)  int? discountPercent, @JsonKey(fromJson: badgeLabelsFromJson)  List<String>? badges, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson)  ViewerActivityDto? viewerActivity)  $default,) {final _that = this;
switch (_that) {
case _ProductCardDto():
return $default(_that.id,_that.slug,_that.path,_that.name,_that.photo,_that.storeName,_that.storeSlug,_that.available,_that.priceSyp,_that.priceIsEstimate,_that.canPurchase,_that.currencyListed,_that.isFavorited,_that.averageRating,_that.reviewsCount,_that.share,_that.brandName,_that.brandVerified,_that.compareAtSyp,_that.discountPercent,_that.badges,_that.viewerActivity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? path, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: photoUrlOrNull)  String? photo, @JsonKey(fromJson: stringOrNull)  String? storeName, @JsonKey(fromJson: stringOrNull)  String? storeSlug, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: intOrNull)  int? priceSyp, @JsonKey(fromJson: boolOrNull)  bool? priceIsEstimate, @JsonKey(fromJson: boolOrNull)  bool? canPurchase, @JsonKey(fromJson: stringOrNull)  String? currencyListed, @JsonKey(fromJson: boolOrNull)  bool? isFavorited, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: stringOrNull)  String? brandName, @JsonKey(fromJson: boolOrNull)  bool? brandVerified, @JsonKey(fromJson: intOrNull)  int? compareAtSyp, @JsonKey(fromJson: intOrNull)  int? discountPercent, @JsonKey(fromJson: badgeLabelsFromJson)  List<String>? badges, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson)  ViewerActivityDto? viewerActivity)?  $default,) {final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
return $default(_that.id,_that.slug,_that.path,_that.name,_that.photo,_that.storeName,_that.storeSlug,_that.available,_that.priceSyp,_that.priceIsEstimate,_that.canPurchase,_that.currencyListed,_that.isFavorited,_that.averageRating,_that.reviewsCount,_that.share,_that.brandName,_that.brandVerified,_that.compareAtSyp,_that.discountPercent,_that.badges,_that.viewerActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCardDto implements ProductCardDto {
  const _ProductCardDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.slug, @JsonKey(fromJson: stringOrNull) this.path, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: photoUrlOrNull) this.photo, @JsonKey(fromJson: stringOrNull) this.storeName, @JsonKey(fromJson: stringOrNull) this.storeSlug, @JsonKey(fromJson: boolOrNull) this.available, @JsonKey(fromJson: intOrNull) this.priceSyp, @JsonKey(fromJson: boolOrNull) this.priceIsEstimate, @JsonKey(fromJson: boolOrNull) this.canPurchase, @JsonKey(fromJson: stringOrNull) this.currencyListed, @JsonKey(fromJson: boolOrNull) this.isFavorited, @JsonKey(fromJson: doubleOrNull) this.averageRating, @JsonKey(fromJson: intOrNull) this.reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson) this.share, @JsonKey(fromJson: stringOrNull) this.brandName, @JsonKey(fromJson: boolOrNull) this.brandVerified, @JsonKey(fromJson: intOrNull) this.compareAtSyp, @JsonKey(fromJson: intOrNull) this.discountPercent, @JsonKey(fromJson: badgeLabelsFromJson)  List<String>? badges, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) this.viewerActivity}): _badges = badges;
  factory _ProductCardDto.fromJson(Map<String, dynamic> json) => _$ProductCardDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? slug;
@override@JsonKey(fromJson: stringOrNull) final  String? path;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: photoUrlOrNull) final  String? photo;
@override@JsonKey(fromJson: stringOrNull) final  String? storeName;
@override@JsonKey(fromJson: stringOrNull) final  String? storeSlug;
@override@JsonKey(fromJson: boolOrNull) final  bool? available;
@override@JsonKey(fromJson: intOrNull) final  int? priceSyp;
@override@JsonKey(fromJson: boolOrNull) final  bool? priceIsEstimate;
@override@JsonKey(fromJson: boolOrNull) final  bool? canPurchase;
@override@JsonKey(fromJson: stringOrNull) final  String? currencyListed;
@override@JsonKey(fromJson: boolOrNull) final  bool? isFavorited;
@override@JsonKey(fromJson: doubleOrNull) final  double? averageRating;
@override@JsonKey(fromJson: intOrNull) final  int? reviewsCount;
@override@JsonKey(fromJson: shareFromJson, toJson: shareToJson) final  ShareDto? share;
@override@JsonKey(fromJson: stringOrNull) final  String? brandName;
@override@JsonKey(fromJson: boolOrNull) final  bool? brandVerified;
@override@JsonKey(fromJson: intOrNull) final  int? compareAtSyp;
@override@JsonKey(fromJson: intOrNull) final  int? discountPercent;
 final  List<String>? _badges;
@override@JsonKey(fromJson: badgeLabelsFromJson) List<String>? get badges {
  final value = _badges;
  if (value == null) return null;
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) final  ViewerActivityDto? viewerActivity;

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCardDtoCopyWith<_ProductCardDto> get copyWith => __$ProductCardDtoCopyWithImpl<_ProductCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCardDto&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeSlug, storeSlug) || other.storeSlug == storeSlug)&&(identical(other.available, available) || other.available == available)&&(identical(other.priceSyp, priceSyp) || other.priceSyp == priceSyp)&&(identical(other.priceIsEstimate, priceIsEstimate) || other.priceIsEstimate == priceIsEstimate)&&(identical(other.canPurchase, canPurchase) || other.canPurchase == canPurchase)&&(identical(other.currencyListed, currencyListed) || other.currencyListed == currencyListed)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.share, share) || other.share == share)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.brandVerified, brandVerified) || other.brandVerified == brandVerified)&&(identical(other.compareAtSyp, compareAtSyp) || other.compareAtSyp == compareAtSyp)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&const DeepCollectionEquality().equals(other.badges, _badges)&&(identical(other.viewerActivity, viewerActivity) || other.viewerActivity == viewerActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,slug,path,name,photo,storeName,storeSlug,available,priceSyp,priceIsEstimate,canPurchase,currencyListed,isFavorited,averageRating,reviewsCount,share,brandName,brandVerified,compareAtSyp,discountPercent,const DeepCollectionEquality().hash(_badges),viewerActivity]);
}

@override
String toString() {
    return 'ProductCardDto(id: $id, slug: $slug, path: $path, name: $name, photo: $photo, storeName: $storeName, storeSlug: $storeSlug, available: $available, priceSyp: $priceSyp, priceIsEstimate: $priceIsEstimate, canPurchase: $canPurchase, currencyListed: $currencyListed, isFavorited: $isFavorited, averageRating: $averageRating, reviewsCount: $reviewsCount, share: $share, brandName: $brandName, brandVerified: $brandVerified, compareAtSyp: $compareAtSyp, discountPercent: $discountPercent, badges: $badges, viewerActivity: $viewerActivity)';
}


}

/// @nodoc
abstract mixin class _$ProductCardDtoCopyWith<$Res> implements $ProductCardDtoCopyWith<$Res> {
  factory _$ProductCardDtoCopyWith(_ProductCardDto value, $Res Function(_ProductCardDto) _then) = __$ProductCardDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: stringOrNull) String? path,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: photoUrlOrNull) String? photo,@JsonKey(fromJson: stringOrNull) String? storeName,@JsonKey(fromJson: stringOrNull) String? storeSlug,@JsonKey(fromJson: boolOrNull) bool? available,@JsonKey(fromJson: intOrNull) int? priceSyp,@JsonKey(fromJson: boolOrNull) bool? priceIsEstimate,@JsonKey(fromJson: boolOrNull) bool? canPurchase,@JsonKey(fromJson: stringOrNull) String? currencyListed,@JsonKey(fromJson: boolOrNull) bool? isFavorited,@JsonKey(fromJson: doubleOrNull) double? averageRating,@JsonKey(fromJson: intOrNull) int? reviewsCount,@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,@JsonKey(fromJson: stringOrNull) String? brandName,@JsonKey(fromJson: boolOrNull) bool? brandVerified,@JsonKey(fromJson: intOrNull) int? compareAtSyp,@JsonKey(fromJson: intOrNull) int? discountPercent,@JsonKey(fromJson: badgeLabelsFromJson) List<String>? badges,@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) ViewerActivityDto? viewerActivity
});


@override $ShareDtoCopyWith<$Res>? get share;@override $ViewerActivityDtoCopyWith<$Res>? get viewerActivity;

}
/// @nodoc
class __$ProductCardDtoCopyWithImpl<$Res>
    implements _$ProductCardDtoCopyWith<$Res> {
  __$ProductCardDtoCopyWithImpl(this._self, this._then);

  final _ProductCardDto _self;
  final $Res Function(_ProductCardDto) _then;

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? slug = freezed,Object? path = freezed,Object? name = freezed,Object? photo = freezed,Object? storeName = freezed,Object? storeSlug = freezed,Object? available = freezed,Object? priceSyp = freezed,Object? priceIsEstimate = freezed,Object? canPurchase = freezed,Object? currencyListed = freezed,Object? isFavorited = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? share = freezed,Object? brandName = freezed,Object? brandVerified = freezed,Object? compareAtSyp = freezed,Object? discountPercent = freezed,Object? badges = freezed,Object? viewerActivity = freezed,}) {
  return _then(_ProductCardDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,storeSlug: freezed == storeSlug ? _self.storeSlug : storeSlug // ignore: cast_nullable_to_non_nullable
as String?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,priceSyp: freezed == priceSyp ? _self.priceSyp : priceSyp // ignore: cast_nullable_to_non_nullable
as int?,priceIsEstimate: freezed == priceIsEstimate ? _self.priceIsEstimate : priceIsEstimate // ignore: cast_nullable_to_non_nullable
as bool?,canPurchase: freezed == canPurchase ? _self.canPurchase : canPurchase // ignore: cast_nullable_to_non_nullable
as bool?,currencyListed: freezed == currencyListed ? _self.currencyListed : currencyListed // ignore: cast_nullable_to_non_nullable
as String?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareDto?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,brandVerified: freezed == brandVerified ? _self.brandVerified : brandVerified // ignore: cast_nullable_to_non_nullable
as bool?,compareAtSyp: freezed == compareAtSyp ? _self.compareAtSyp : compareAtSyp // ignore: cast_nullable_to_non_nullable
as int?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,badges: freezed == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>?,viewerActivity: freezed == viewerActivity ? _self.viewerActivity : viewerActivity // ignore: cast_nullable_to_non_nullable
as ViewerActivityDto?,
  ));
}

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareDtoCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerActivityDtoCopyWith<$Res>? get viewerActivity {
    if (_self.viewerActivity == null) {
    return null;
  }

  return $ViewerActivityDtoCopyWith<$Res>(_self.viewerActivity!, (value) {
    return _then(_self.copyWith(viewerActivity: value));
  });
}
}


/// @nodoc
mixin _$ViewerActivityDto {

@JsonKey(fromJson: stringOrNull) String? get metric;@JsonKey(fromJson: intOrNull) int? get count;@JsonKey(fromJson: intOrNull) int? get windowHours;@JsonKey(fromJson: stringOrNull) String? get asOf;
/// Create a copy of ViewerActivityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewerActivityDtoCopyWith<ViewerActivityDto> get copyWith => _$ViewerActivityDtoCopyWithImpl<ViewerActivityDto>(this as ViewerActivityDto, _$identity);

  /// Serializes this ViewerActivityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ViewerActivityDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewerActivityDto&&(identical(other.metric, _this.metric) || other.metric == _this.metric)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.windowHours, _this.windowHours) || other.windowHours == _this.windowHours)&&(identical(other.asOf, _this.asOf) || other.asOf == _this.asOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ViewerActivityDto;
  return Object.hash(runtimeType,_this.metric,_this.count,_this.windowHours,_this.asOf);
}

@override
String toString() {
  final _this = this as ViewerActivityDto;
  return 'ViewerActivityDto(metric: ${_this.metric}, count: ${_this.count}, windowHours: ${_this.windowHours}, asOf: ${_this.asOf})';
}


}

/// @nodoc
abstract mixin class $ViewerActivityDtoCopyWith<$Res>  {
  factory $ViewerActivityDtoCopyWith(ViewerActivityDto value, $Res Function(ViewerActivityDto) _then) = _$ViewerActivityDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? metric,@JsonKey(fromJson: intOrNull) int? count,@JsonKey(fromJson: intOrNull) int? windowHours,@JsonKey(fromJson: stringOrNull) String? asOf
});




}
/// @nodoc
class _$ViewerActivityDtoCopyWithImpl<$Res>
    implements $ViewerActivityDtoCopyWith<$Res> {
  _$ViewerActivityDtoCopyWithImpl(this._self, this._then);

  final ViewerActivityDto _self;
  final $Res Function(ViewerActivityDto) _then;

/// Create a copy of ViewerActivityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metric = freezed,Object? count = freezed,Object? windowHours = freezed,Object? asOf = freezed,}) {
  return _then(ViewerActivityDto(
metric: freezed == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,windowHours: freezed == windowHours ? _self.windowHours : windowHours // ignore: cast_nullable_to_non_nullable
as int?,asOf: freezed == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewerActivityDto].
extension ViewerActivityDtoPatterns on ViewerActivityDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewerActivityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewerActivityDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewerActivityDto value)  $default,){
final _that = this;
switch (_that) {
case _ViewerActivityDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewerActivityDto value)?  $default,){
final _that = this;
switch (_that) {
case _ViewerActivityDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? metric, @JsonKey(fromJson: intOrNull)  int? count, @JsonKey(fromJson: intOrNull)  int? windowHours, @JsonKey(fromJson: stringOrNull)  String? asOf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewerActivityDto() when $default != null:
return $default(_that.metric,_that.count,_that.windowHours,_that.asOf);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? metric, @JsonKey(fromJson: intOrNull)  int? count, @JsonKey(fromJson: intOrNull)  int? windowHours, @JsonKey(fromJson: stringOrNull)  String? asOf)  $default,) {final _that = this;
switch (_that) {
case _ViewerActivityDto():
return $default(_that.metric,_that.count,_that.windowHours,_that.asOf);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? metric, @JsonKey(fromJson: intOrNull)  int? count, @JsonKey(fromJson: intOrNull)  int? windowHours, @JsonKey(fromJson: stringOrNull)  String? asOf)?  $default,) {final _that = this;
switch (_that) {
case _ViewerActivityDto() when $default != null:
return $default(_that.metric,_that.count,_that.windowHours,_that.asOf);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ViewerActivityDto implements ViewerActivityDto {
  const _ViewerActivityDto({@JsonKey(fromJson: stringOrNull) this.metric, @JsonKey(fromJson: intOrNull) this.count, @JsonKey(fromJson: intOrNull) this.windowHours, @JsonKey(fromJson: stringOrNull) this.asOf});
  factory _ViewerActivityDto.fromJson(Map<String, dynamic> json) => _$ViewerActivityDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? metric;
@override@JsonKey(fromJson: intOrNull) final  int? count;
@override@JsonKey(fromJson: intOrNull) final  int? windowHours;
@override@JsonKey(fromJson: stringOrNull) final  String? asOf;

/// Create a copy of ViewerActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewerActivityDtoCopyWith<_ViewerActivityDto> get copyWith => __$ViewerActivityDtoCopyWithImpl<_ViewerActivityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewerActivityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewerActivityDto&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.count, count) || other.count == count)&&(identical(other.windowHours, windowHours) || other.windowHours == windowHours)&&(identical(other.asOf, asOf) || other.asOf == asOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,metric,count,windowHours,asOf);
}

@override
String toString() {
    return 'ViewerActivityDto(metric: $metric, count: $count, windowHours: $windowHours, asOf: $asOf)';
}


}

/// @nodoc
abstract mixin class _$ViewerActivityDtoCopyWith<$Res> implements $ViewerActivityDtoCopyWith<$Res> {
  factory _$ViewerActivityDtoCopyWith(_ViewerActivityDto value, $Res Function(_ViewerActivityDto) _then) = __$ViewerActivityDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? metric,@JsonKey(fromJson: intOrNull) int? count,@JsonKey(fromJson: intOrNull) int? windowHours,@JsonKey(fromJson: stringOrNull) String? asOf
});




}
/// @nodoc
class __$ViewerActivityDtoCopyWithImpl<$Res>
    implements _$ViewerActivityDtoCopyWith<$Res> {
  __$ViewerActivityDtoCopyWithImpl(this._self, this._then);

  final _ViewerActivityDto _self;
  final $Res Function(_ViewerActivityDto) _then;

/// Create a copy of ViewerActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metric = freezed,Object? count = freezed,Object? windowHours = freezed,Object? asOf = freezed,}) {
  return _then(_ViewerActivityDto(
metric: freezed == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,windowHours: freezed == windowHours ? _self.windowHours : windowHours // ignore: cast_nullable_to_non_nullable
as int?,asOf: freezed == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductOptionDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get label;@JsonKey(fromJson: boolOrNull) bool? get available;@JsonKey(fromJson: boolOrNull) bool? get lowStockHint;
/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductOptionDtoCopyWith<ProductOptionDto> get copyWith => _$ProductOptionDtoCopyWithImpl<ProductOptionDto>(this as ProductOptionDto, _$identity);

  /// Serializes this ProductOptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductOptionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductOptionDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.lowStockHint, _this.lowStockHint) || other.lowStockHint == _this.lowStockHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductOptionDto;
  return Object.hash(runtimeType,_this.id,_this.label,_this.available,_this.lowStockHint);
}

@override
String toString() {
  final _this = this as ProductOptionDto;
  return 'ProductOptionDto(id: ${_this.id}, label: ${_this.label}, available: ${_this.available}, lowStockHint: ${_this.lowStockHint})';
}


}

/// @nodoc
abstract mixin class $ProductOptionDtoCopyWith<$Res>  {
  factory $ProductOptionDtoCopyWith(ProductOptionDto value, $Res Function(ProductOptionDto) _then) = _$ProductOptionDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? label,@JsonKey(fromJson: boolOrNull) bool? available,@JsonKey(fromJson: boolOrNull) bool? lowStockHint
});




}
/// @nodoc
class _$ProductOptionDtoCopyWithImpl<$Res>
    implements $ProductOptionDtoCopyWith<$Res> {
  _$ProductOptionDtoCopyWithImpl(this._self, this._then);

  final ProductOptionDto _self;
  final $Res Function(ProductOptionDto) _then;

/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? label = freezed,Object? available = freezed,Object? lowStockHint = freezed,}) {
  return _then(ProductOptionDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,lowStockHint: freezed == lowStockHint ? _self.lowStockHint : lowStockHint // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductOptionDto].
extension ProductOptionDtoPatterns on ProductOptionDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductOptionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductOptionDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductOptionDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductOptionDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductOptionDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductOptionDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? label, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: boolOrNull)  bool? lowStockHint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductOptionDto() when $default != null:
return $default(_that.id,_that.label,_that.available,_that.lowStockHint);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? label, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: boolOrNull)  bool? lowStockHint)  $default,) {final _that = this;
switch (_that) {
case _ProductOptionDto():
return $default(_that.id,_that.label,_that.available,_that.lowStockHint);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? label, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: boolOrNull)  bool? lowStockHint)?  $default,) {final _that = this;
switch (_that) {
case _ProductOptionDto() when $default != null:
return $default(_that.id,_that.label,_that.available,_that.lowStockHint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductOptionDto implements ProductOptionDto {
  const _ProductOptionDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.label, @JsonKey(fromJson: boolOrNull) this.available, @JsonKey(fromJson: boolOrNull) this.lowStockHint});
  factory _ProductOptionDto.fromJson(Map<String, dynamic> json) => _$ProductOptionDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? label;
@override@JsonKey(fromJson: boolOrNull) final  bool? available;
@override@JsonKey(fromJson: boolOrNull) final  bool? lowStockHint;

/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductOptionDtoCopyWith<_ProductOptionDto> get copyWith => __$ProductOptionDtoCopyWithImpl<_ProductOptionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductOptionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductOptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.available, available) || other.available == available)&&(identical(other.lowStockHint, lowStockHint) || other.lowStockHint == lowStockHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,label,available,lowStockHint);
}

@override
String toString() {
    return 'ProductOptionDto(id: $id, label: $label, available: $available, lowStockHint: $lowStockHint)';
}


}

/// @nodoc
abstract mixin class _$ProductOptionDtoCopyWith<$Res> implements $ProductOptionDtoCopyWith<$Res> {
  factory _$ProductOptionDtoCopyWith(_ProductOptionDto value, $Res Function(_ProductOptionDto) _then) = __$ProductOptionDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? label,@JsonKey(fromJson: boolOrNull) bool? available,@JsonKey(fromJson: boolOrNull) bool? lowStockHint
});




}
/// @nodoc
class __$ProductOptionDtoCopyWithImpl<$Res>
    implements _$ProductOptionDtoCopyWith<$Res> {
  __$ProductOptionDtoCopyWithImpl(this._self, this._then);

  final _ProductOptionDto _self;
  final $Res Function(_ProductOptionDto) _then;

/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? label = freezed,Object? available = freezed,Object? lowStockHint = freezed,}) {
  return _then(_ProductOptionDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,lowStockHint: freezed == lowStockHint ? _self.lowStockHint : lowStockHint // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$StoreRefDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: stringOrNull) String? get slug;
/// Create a copy of StoreRefDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreRefDtoCopyWith<StoreRefDto> get copyWith => _$StoreRefDtoCopyWithImpl<StoreRefDto>(this as StoreRefDto, _$identity);

  /// Serializes this StoreRefDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoreRefDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreRefDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoreRefDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.slug);
}

@override
String toString() {
  final _this = this as StoreRefDto;
  return 'StoreRefDto(id: ${_this.id}, name: ${_this.name}, slug: ${_this.slug})';
}


}

/// @nodoc
abstract mixin class $StoreRefDtoCopyWith<$Res>  {
  factory $StoreRefDtoCopyWith(StoreRefDto value, $Res Function(StoreRefDto) _then) = _$StoreRefDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug
});




}
/// @nodoc
class _$StoreRefDtoCopyWithImpl<$Res>
    implements $StoreRefDtoCopyWith<$Res> {
  _$StoreRefDtoCopyWithImpl(this._self, this._then);

  final StoreRefDto _self;
  final $Res Function(StoreRefDto) _then;

/// Create a copy of StoreRefDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,}) {
  return _then(StoreRefDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreRefDto].
extension StoreRefDtoPatterns on StoreRefDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreRefDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreRefDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreRefDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreRefDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreRefDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreRefDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreRefDto() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug)  $default,) {final _that = this;
switch (_that) {
case _StoreRefDto():
return $default(_that.id,_that.name,_that.slug);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug)?  $default,) {final _that = this;
switch (_that) {
case _StoreRefDto() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreRefDto implements StoreRefDto {
  const _StoreRefDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: stringOrNull) this.slug});
  factory _StoreRefDto.fromJson(Map<String, dynamic> json) => _$StoreRefDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: stringOrNull) final  String? slug;

/// Create a copy of StoreRefDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreRefDtoCopyWith<_StoreRefDto> get copyWith => __$StoreRefDtoCopyWithImpl<_StoreRefDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreRefDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreRefDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,slug);
}

@override
String toString() {
    return 'StoreRefDto(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$StoreRefDtoCopyWith<$Res> implements $StoreRefDtoCopyWith<$Res> {
  factory _$StoreRefDtoCopyWith(_StoreRefDto value, $Res Function(_StoreRefDto) _then) = __$StoreRefDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug
});




}
/// @nodoc
class __$StoreRefDtoCopyWithImpl<$Res>
    implements _$StoreRefDtoCopyWith<$Res> {
  __$StoreRefDtoCopyWithImpl(this._self, this._then);

  final _StoreRefDto _self;
  final $Res Function(_StoreRefDto) _then;

/// Create a copy of StoreRefDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,}) {
  return _then(_StoreRefDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CategoryRefDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: stringOrNull) String? get slug;
/// Create a copy of CategoryRefDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryRefDtoCopyWith<CategoryRefDto> get copyWith => _$CategoryRefDtoCopyWithImpl<CategoryRefDto>(this as CategoryRefDto, _$identity);

  /// Serializes this CategoryRefDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryRefDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryRefDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryRefDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.slug);
}

@override
String toString() {
  final _this = this as CategoryRefDto;
  return 'CategoryRefDto(id: ${_this.id}, name: ${_this.name}, slug: ${_this.slug})';
}


}

/// @nodoc
abstract mixin class $CategoryRefDtoCopyWith<$Res>  {
  factory $CategoryRefDtoCopyWith(CategoryRefDto value, $Res Function(CategoryRefDto) _then) = _$CategoryRefDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug
});




}
/// @nodoc
class _$CategoryRefDtoCopyWithImpl<$Res>
    implements $CategoryRefDtoCopyWith<$Res> {
  _$CategoryRefDtoCopyWithImpl(this._self, this._then);

  final CategoryRefDto _self;
  final $Res Function(CategoryRefDto) _then;

/// Create a copy of CategoryRefDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,}) {
  return _then(CategoryRefDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryRefDto].
extension CategoryRefDtoPatterns on CategoryRefDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryRefDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryRefDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryRefDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryRefDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryRefDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryRefDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryRefDto() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug)  $default,) {final _that = this;
switch (_that) {
case _CategoryRefDto():
return $default(_that.id,_that.name,_that.slug);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug)?  $default,) {final _that = this;
switch (_that) {
case _CategoryRefDto() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryRefDto implements CategoryRefDto {
  const _CategoryRefDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: stringOrNull) this.slug});
  factory _CategoryRefDto.fromJson(Map<String, dynamic> json) => _$CategoryRefDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: stringOrNull) final  String? slug;

/// Create a copy of CategoryRefDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryRefDtoCopyWith<_CategoryRefDto> get copyWith => __$CategoryRefDtoCopyWithImpl<_CategoryRefDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryRefDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryRefDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,slug);
}

@override
String toString() {
    return 'CategoryRefDto(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$CategoryRefDtoCopyWith<$Res> implements $CategoryRefDtoCopyWith<$Res> {
  factory _$CategoryRefDtoCopyWith(_CategoryRefDto value, $Res Function(_CategoryRefDto) _then) = __$CategoryRefDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug
});




}
/// @nodoc
class __$CategoryRefDtoCopyWithImpl<$Res>
    implements _$CategoryRefDtoCopyWith<$Res> {
  __$CategoryRefDtoCopyWithImpl(this._self, this._then);

  final _CategoryRefDto _self;
  final $Res Function(_CategoryRefDto) _then;

/// Create a copy of CategoryRefDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,}) {
  return _then(_CategoryRefDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SeoAlternateDto {

@JsonKey(fromJson: stringOrNull) String? get hreflang;@JsonKey(fromJson: stringOrNull) String? get href;
/// Create a copy of SeoAlternateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeoAlternateDtoCopyWith<SeoAlternateDto> get copyWith => _$SeoAlternateDtoCopyWithImpl<SeoAlternateDto>(this as SeoAlternateDto, _$identity);

  /// Serializes this SeoAlternateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SeoAlternateDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeoAlternateDto&&(identical(other.hreflang, _this.hreflang) || other.hreflang == _this.hreflang)&&(identical(other.href, _this.href) || other.href == _this.href));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SeoAlternateDto;
  return Object.hash(runtimeType,_this.hreflang,_this.href);
}

@override
String toString() {
  final _this = this as SeoAlternateDto;
  return 'SeoAlternateDto(hreflang: ${_this.hreflang}, href: ${_this.href})';
}


}

/// @nodoc
abstract mixin class $SeoAlternateDtoCopyWith<$Res>  {
  factory $SeoAlternateDtoCopyWith(SeoAlternateDto value, $Res Function(SeoAlternateDto) _then) = _$SeoAlternateDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? hreflang,@JsonKey(fromJson: stringOrNull) String? href
});




}
/// @nodoc
class _$SeoAlternateDtoCopyWithImpl<$Res>
    implements $SeoAlternateDtoCopyWith<$Res> {
  _$SeoAlternateDtoCopyWithImpl(this._self, this._then);

  final SeoAlternateDto _self;
  final $Res Function(SeoAlternateDto) _then;

/// Create a copy of SeoAlternateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hreflang = freezed,Object? href = freezed,}) {
  return _then(SeoAlternateDto(
hreflang: freezed == hreflang ? _self.hreflang : hreflang // ignore: cast_nullable_to_non_nullable
as String?,href: freezed == href ? _self.href : href // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeoAlternateDto].
extension SeoAlternateDtoPatterns on SeoAlternateDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeoAlternateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeoAlternateDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeoAlternateDto value)  $default,){
final _that = this;
switch (_that) {
case _SeoAlternateDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeoAlternateDto value)?  $default,){
final _that = this;
switch (_that) {
case _SeoAlternateDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? hreflang, @JsonKey(fromJson: stringOrNull)  String? href)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeoAlternateDto() when $default != null:
return $default(_that.hreflang,_that.href);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? hreflang, @JsonKey(fromJson: stringOrNull)  String? href)  $default,) {final _that = this;
switch (_that) {
case _SeoAlternateDto():
return $default(_that.hreflang,_that.href);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? hreflang, @JsonKey(fromJson: stringOrNull)  String? href)?  $default,) {final _that = this;
switch (_that) {
case _SeoAlternateDto() when $default != null:
return $default(_that.hreflang,_that.href);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeoAlternateDto implements SeoAlternateDto {
  const _SeoAlternateDto({@JsonKey(fromJson: stringOrNull) this.hreflang, @JsonKey(fromJson: stringOrNull) this.href});
  factory _SeoAlternateDto.fromJson(Map<String, dynamic> json) => _$SeoAlternateDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? hreflang;
@override@JsonKey(fromJson: stringOrNull) final  String? href;

/// Create a copy of SeoAlternateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeoAlternateDtoCopyWith<_SeoAlternateDto> get copyWith => __$SeoAlternateDtoCopyWithImpl<_SeoAlternateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeoAlternateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeoAlternateDto&&(identical(other.hreflang, hreflang) || other.hreflang == hreflang)&&(identical(other.href, href) || other.href == href));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hreflang,href);
}

@override
String toString() {
    return 'SeoAlternateDto(hreflang: $hreflang, href: $href)';
}


}

/// @nodoc
abstract mixin class _$SeoAlternateDtoCopyWith<$Res> implements $SeoAlternateDtoCopyWith<$Res> {
  factory _$SeoAlternateDtoCopyWith(_SeoAlternateDto value, $Res Function(_SeoAlternateDto) _then) = __$SeoAlternateDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? hreflang,@JsonKey(fromJson: stringOrNull) String? href
});




}
/// @nodoc
class __$SeoAlternateDtoCopyWithImpl<$Res>
    implements _$SeoAlternateDtoCopyWith<$Res> {
  __$SeoAlternateDtoCopyWithImpl(this._self, this._then);

  final _SeoAlternateDto _self;
  final $Res Function(_SeoAlternateDto) _then;

/// Create a copy of SeoAlternateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hreflang = freezed,Object? href = freezed,}) {
  return _then(_SeoAlternateDto(
hreflang: freezed == hreflang ? _self.hreflang : hreflang // ignore: cast_nullable_to_non_nullable
as String?,href: freezed == href ? _self.href : href // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SeoDto {

@JsonKey(fromJson: stringOrNull) String? get canonical;@JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson) List<SeoAlternateDto>? get alternates;
/// Create a copy of SeoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeoDtoCopyWith<SeoDto> get copyWith => _$SeoDtoCopyWithImpl<SeoDto>(this as SeoDto, _$identity);

  /// Serializes this SeoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SeoDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeoDto&&(identical(other.canonical, _this.canonical) || other.canonical == _this.canonical)&&const DeepCollectionEquality().equals(other.alternates, _this.alternates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SeoDto;
  return Object.hash(runtimeType,_this.canonical,const DeepCollectionEquality().hash(_this.alternates));
}

@override
String toString() {
  final _this = this as SeoDto;
  return 'SeoDto(canonical: ${_this.canonical}, alternates: ${_this.alternates})';
}


}

/// @nodoc
abstract mixin class $SeoDtoCopyWith<$Res>  {
  factory $SeoDtoCopyWith(SeoDto value, $Res Function(SeoDto) _then) = _$SeoDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? canonical,@JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson) List<SeoAlternateDto>? alternates
});




}
/// @nodoc
class _$SeoDtoCopyWithImpl<$Res>
    implements $SeoDtoCopyWith<$Res> {
  _$SeoDtoCopyWithImpl(this._self, this._then);

  final SeoDto _self;
  final $Res Function(SeoDto) _then;

/// Create a copy of SeoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canonical = freezed,Object? alternates = freezed,}) {
  return _then(SeoDto(
canonical: freezed == canonical ? _self.canonical : canonical // ignore: cast_nullable_to_non_nullable
as String?,alternates: freezed == alternates ? _self.alternates : alternates // ignore: cast_nullable_to_non_nullable
as List<SeoAlternateDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeoDto].
extension SeoDtoPatterns on SeoDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeoDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeoDto value)  $default,){
final _that = this;
switch (_that) {
case _SeoDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeoDto value)?  $default,){
final _that = this;
switch (_that) {
case _SeoDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? canonical, @JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson)  List<SeoAlternateDto>? alternates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeoDto() when $default != null:
return $default(_that.canonical,_that.alternates);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? canonical, @JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson)  List<SeoAlternateDto>? alternates)  $default,) {final _that = this;
switch (_that) {
case _SeoDto():
return $default(_that.canonical,_that.alternates);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? canonical, @JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson)  List<SeoAlternateDto>? alternates)?  $default,) {final _that = this;
switch (_that) {
case _SeoDto() when $default != null:
return $default(_that.canonical,_that.alternates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeoDto implements SeoDto {
  const _SeoDto({@JsonKey(fromJson: stringOrNull) this.canonical, @JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson)  List<SeoAlternateDto>? alternates}): _alternates = alternates;
  factory _SeoDto.fromJson(Map<String, dynamic> json) => _$SeoDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? canonical;
 final  List<SeoAlternateDto>? _alternates;
@override@JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson) List<SeoAlternateDto>? get alternates {
  final value = _alternates;
  if (value == null) return null;
  if (_alternates is EqualUnmodifiableListView) return _alternates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SeoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeoDtoCopyWith<_SeoDto> get copyWith => __$SeoDtoCopyWithImpl<_SeoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeoDto&&(identical(other.canonical, canonical) || other.canonical == canonical)&&const DeepCollectionEquality().equals(other.alternates, _alternates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,canonical,const DeepCollectionEquality().hash(_alternates));
}

@override
String toString() {
    return 'SeoDto(canonical: $canonical, alternates: $alternates)';
}


}

/// @nodoc
abstract mixin class _$SeoDtoCopyWith<$Res> implements $SeoDtoCopyWith<$Res> {
  factory _$SeoDtoCopyWith(_SeoDto value, $Res Function(_SeoDto) _then) = __$SeoDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? canonical,@JsonKey(fromJson: alternatesFromJson, toJson: alternatesToJson) List<SeoAlternateDto>? alternates
});




}
/// @nodoc
class __$SeoDtoCopyWithImpl<$Res>
    implements _$SeoDtoCopyWith<$Res> {
  __$SeoDtoCopyWithImpl(this._self, this._then);

  final _SeoDto _self;
  final $Res Function(_SeoDto) _then;

/// Create a copy of SeoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canonical = freezed,Object? alternates = freezed,}) {
  return _then(_SeoDto(
canonical: freezed == canonical ? _self.canonical : canonical // ignore: cast_nullable_to_non_nullable
as String?,alternates: freezed == alternates ? _self._alternates : alternates // ignore: cast_nullable_to_non_nullable
as List<SeoAlternateDto>?,
  ));
}


}


/// @nodoc
mixin _$ProductDetailDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get slug;@JsonKey(fromJson: stringOrNull) String? get path;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: stringOrNull) String? get description;@JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson) StoreRefDto? get store;@JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson) CategoryRefDto? get category;@JsonKey(fromJson: photoListFromJson, toJson: photoListToJson) List<String>? get photos;@JsonKey(fromJson: optionsFromJson, toJson: optionsToJson) List<ProductOptionDto>? get options;@JsonKey(fromJson: intOrNull) int? get priceSyp;@JsonKey(fromJson: boolOrNull) bool? get priceIsEstimate;@JsonKey(fromJson: boolOrNull) bool? get canPurchase;@JsonKey(fromJson: boolOrNull) bool? get available;@JsonKey(fromJson: stringOrNull) String? get currencyListed;@JsonKey(fromJson: boolOrNull) bool? get isFavorited;@JsonKey(fromJson: doubleOrNull) double? get averageRating;@JsonKey(fromJson: intOrNull) int? get reviewsCount;@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? get share;@JsonKey(fromJson: seoFromJson, toJson: seoToJson) SeoDto? get seo;@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) ViewerActivityDto? get viewerActivity;
/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailDtoCopyWith<ProductDetailDto> get copyWith => _$ProductDetailDtoCopyWithImpl<ProductDetailDto>(this as ProductDetailDto, _$identity);

  /// Serializes this ProductDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductDetailDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.category, _this.category) || other.category == _this.category)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.priceSyp, _this.priceSyp) || other.priceSyp == _this.priceSyp)&&(identical(other.priceIsEstimate, _this.priceIsEstimate) || other.priceIsEstimate == _this.priceIsEstimate)&&(identical(other.canPurchase, _this.canPurchase) || other.canPurchase == _this.canPurchase)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.currencyListed, _this.currencyListed) || other.currencyListed == _this.currencyListed)&&(identical(other.isFavorited, _this.isFavorited) || other.isFavorited == _this.isFavorited)&&(identical(other.averageRating, _this.averageRating) || other.averageRating == _this.averageRating)&&(identical(other.reviewsCount, _this.reviewsCount) || other.reviewsCount == _this.reviewsCount)&&(identical(other.share, _this.share) || other.share == _this.share)&&(identical(other.seo, _this.seo) || other.seo == _this.seo)&&(identical(other.viewerActivity, _this.viewerActivity) || other.viewerActivity == _this.viewerActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductDetailDto;
  return Object.hashAll([runtimeType,_this.id,_this.slug,_this.path,_this.name,_this.description,_this.store,_this.category,const DeepCollectionEquality().hash(_this.photos),const DeepCollectionEquality().hash(_this.options),_this.priceSyp,_this.priceIsEstimate,_this.canPurchase,_this.available,_this.currencyListed,_this.isFavorited,_this.averageRating,_this.reviewsCount,_this.share,_this.seo,_this.viewerActivity]);
}

@override
String toString() {
  final _this = this as ProductDetailDto;
  return 'ProductDetailDto(id: ${_this.id}, slug: ${_this.slug}, path: ${_this.path}, name: ${_this.name}, description: ${_this.description}, store: ${_this.store}, category: ${_this.category}, photos: ${_this.photos}, options: ${_this.options}, priceSyp: ${_this.priceSyp}, priceIsEstimate: ${_this.priceIsEstimate}, canPurchase: ${_this.canPurchase}, available: ${_this.available}, currencyListed: ${_this.currencyListed}, isFavorited: ${_this.isFavorited}, averageRating: ${_this.averageRating}, reviewsCount: ${_this.reviewsCount}, share: ${_this.share}, seo: ${_this.seo}, viewerActivity: ${_this.viewerActivity})';
}


}

/// @nodoc
abstract mixin class $ProductDetailDtoCopyWith<$Res>  {
  factory $ProductDetailDtoCopyWith(ProductDetailDto value, $Res Function(ProductDetailDto) _then) = _$ProductDetailDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: stringOrNull) String? path,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? description,@JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson) StoreRefDto? store,@JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson) CategoryRefDto? category,@JsonKey(fromJson: photoListFromJson, toJson: photoListToJson) List<String>? photos,@JsonKey(fromJson: optionsFromJson, toJson: optionsToJson) List<ProductOptionDto>? options,@JsonKey(fromJson: intOrNull) int? priceSyp,@JsonKey(fromJson: boolOrNull) bool? priceIsEstimate,@JsonKey(fromJson: boolOrNull) bool? canPurchase,@JsonKey(fromJson: boolOrNull) bool? available,@JsonKey(fromJson: stringOrNull) String? currencyListed,@JsonKey(fromJson: boolOrNull) bool? isFavorited,@JsonKey(fromJson: doubleOrNull) double? averageRating,@JsonKey(fromJson: intOrNull) int? reviewsCount,@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,@JsonKey(fromJson: seoFromJson, toJson: seoToJson) SeoDto? seo,@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) ViewerActivityDto? viewerActivity
});


$StoreRefDtoCopyWith<$Res>? get store;$CategoryRefDtoCopyWith<$Res>? get category;$ShareDtoCopyWith<$Res>? get share;$SeoDtoCopyWith<$Res>? get seo;$ViewerActivityDtoCopyWith<$Res>? get viewerActivity;

}
/// @nodoc
class _$ProductDetailDtoCopyWithImpl<$Res>
    implements $ProductDetailDtoCopyWith<$Res> {
  _$ProductDetailDtoCopyWithImpl(this._self, this._then);

  final ProductDetailDto _self;
  final $Res Function(ProductDetailDto) _then;

/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? slug = freezed,Object? path = freezed,Object? name = freezed,Object? description = freezed,Object? store = freezed,Object? category = freezed,Object? photos = freezed,Object? options = freezed,Object? priceSyp = freezed,Object? priceIsEstimate = freezed,Object? canPurchase = freezed,Object? available = freezed,Object? currencyListed = freezed,Object? isFavorited = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? share = freezed,Object? seo = freezed,Object? viewerActivity = freezed,}) {
  return _then(ProductDetailDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as StoreRefDto?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryRefDto?,photos: freezed == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ProductOptionDto>?,priceSyp: freezed == priceSyp ? _self.priceSyp : priceSyp // ignore: cast_nullable_to_non_nullable
as int?,priceIsEstimate: freezed == priceIsEstimate ? _self.priceIsEstimate : priceIsEstimate // ignore: cast_nullable_to_non_nullable
as bool?,canPurchase: freezed == canPurchase ? _self.canPurchase : canPurchase // ignore: cast_nullable_to_non_nullable
as bool?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,currencyListed: freezed == currencyListed ? _self.currencyListed : currencyListed // ignore: cast_nullable_to_non_nullable
as String?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareDto?,seo: freezed == seo ? _self.seo : seo // ignore: cast_nullable_to_non_nullable
as SeoDto?,viewerActivity: freezed == viewerActivity ? _self.viewerActivity : viewerActivity // ignore: cast_nullable_to_non_nullable
as ViewerActivityDto?,
  ));
}
/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreRefDtoCopyWith<$Res>? get store {
    if (_self.store == null) {
    return null;
  }

  return $StoreRefDtoCopyWith<$Res>(_self.store!, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryRefDtoCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryRefDtoCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareDtoCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeoDtoCopyWith<$Res>? get seo {
    if (_self.seo == null) {
    return null;
  }

  return $SeoDtoCopyWith<$Res>(_self.seo!, (value) {
    return _then(_self.copyWith(seo: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerActivityDtoCopyWith<$Res>? get viewerActivity {
    if (_self.viewerActivity == null) {
    return null;
  }

  return $ViewerActivityDtoCopyWith<$Res>(_self.viewerActivity!, (value) {
    return _then(_self.copyWith(viewerActivity: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetailDto].
extension ProductDetailDtoPatterns on ProductDetailDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetailDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetailDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetailDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? path, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? description, @JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson)  StoreRefDto? store, @JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson)  CategoryRefDto? category, @JsonKey(fromJson: photoListFromJson, toJson: photoListToJson)  List<String>? photos, @JsonKey(fromJson: optionsFromJson, toJson: optionsToJson)  List<ProductOptionDto>? options, @JsonKey(fromJson: intOrNull)  int? priceSyp, @JsonKey(fromJson: boolOrNull)  bool? priceIsEstimate, @JsonKey(fromJson: boolOrNull)  bool? canPurchase, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: stringOrNull)  String? currencyListed, @JsonKey(fromJson: boolOrNull)  bool? isFavorited, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: seoFromJson, toJson: seoToJson)  SeoDto? seo, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson)  ViewerActivityDto? viewerActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetailDto() when $default != null:
return $default(_that.id,_that.slug,_that.path,_that.name,_that.description,_that.store,_that.category,_that.photos,_that.options,_that.priceSyp,_that.priceIsEstimate,_that.canPurchase,_that.available,_that.currencyListed,_that.isFavorited,_that.averageRating,_that.reviewsCount,_that.share,_that.seo,_that.viewerActivity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? path, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? description, @JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson)  StoreRefDto? store, @JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson)  CategoryRefDto? category, @JsonKey(fromJson: photoListFromJson, toJson: photoListToJson)  List<String>? photos, @JsonKey(fromJson: optionsFromJson, toJson: optionsToJson)  List<ProductOptionDto>? options, @JsonKey(fromJson: intOrNull)  int? priceSyp, @JsonKey(fromJson: boolOrNull)  bool? priceIsEstimate, @JsonKey(fromJson: boolOrNull)  bool? canPurchase, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: stringOrNull)  String? currencyListed, @JsonKey(fromJson: boolOrNull)  bool? isFavorited, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: seoFromJson, toJson: seoToJson)  SeoDto? seo, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson)  ViewerActivityDto? viewerActivity)  $default,) {final _that = this;
switch (_that) {
case _ProductDetailDto():
return $default(_that.id,_that.slug,_that.path,_that.name,_that.description,_that.store,_that.category,_that.photos,_that.options,_that.priceSyp,_that.priceIsEstimate,_that.canPurchase,_that.available,_that.currencyListed,_that.isFavorited,_that.averageRating,_that.reviewsCount,_that.share,_that.seo,_that.viewerActivity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? path, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? description, @JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson)  StoreRefDto? store, @JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson)  CategoryRefDto? category, @JsonKey(fromJson: photoListFromJson, toJson: photoListToJson)  List<String>? photos, @JsonKey(fromJson: optionsFromJson, toJson: optionsToJson)  List<ProductOptionDto>? options, @JsonKey(fromJson: intOrNull)  int? priceSyp, @JsonKey(fromJson: boolOrNull)  bool? priceIsEstimate, @JsonKey(fromJson: boolOrNull)  bool? canPurchase, @JsonKey(fromJson: boolOrNull)  bool? available, @JsonKey(fromJson: stringOrNull)  String? currencyListed, @JsonKey(fromJson: boolOrNull)  bool? isFavorited, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: seoFromJson, toJson: seoToJson)  SeoDto? seo, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson)  ViewerActivityDto? viewerActivity)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetailDto() when $default != null:
return $default(_that.id,_that.slug,_that.path,_that.name,_that.description,_that.store,_that.category,_that.photos,_that.options,_that.priceSyp,_that.priceIsEstimate,_that.canPurchase,_that.available,_that.currencyListed,_that.isFavorited,_that.averageRating,_that.reviewsCount,_that.share,_that.seo,_that.viewerActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDetailDto implements ProductDetailDto {
  const _ProductDetailDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.slug, @JsonKey(fromJson: stringOrNull) this.path, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: stringOrNull) this.description, @JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson) this.store, @JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson) this.category, @JsonKey(fromJson: photoListFromJson, toJson: photoListToJson)  List<String>? photos, @JsonKey(fromJson: optionsFromJson, toJson: optionsToJson)  List<ProductOptionDto>? options, @JsonKey(fromJson: intOrNull) this.priceSyp, @JsonKey(fromJson: boolOrNull) this.priceIsEstimate, @JsonKey(fromJson: boolOrNull) this.canPurchase, @JsonKey(fromJson: boolOrNull) this.available, @JsonKey(fromJson: stringOrNull) this.currencyListed, @JsonKey(fromJson: boolOrNull) this.isFavorited, @JsonKey(fromJson: doubleOrNull) this.averageRating, @JsonKey(fromJson: intOrNull) this.reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson) this.share, @JsonKey(fromJson: seoFromJson, toJson: seoToJson) this.seo, @JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) this.viewerActivity}): _photos = photos,_options = options;
  factory _ProductDetailDto.fromJson(Map<String, dynamic> json) => _$ProductDetailDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? slug;
@override@JsonKey(fromJson: stringOrNull) final  String? path;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: stringOrNull) final  String? description;
@override@JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson) final  StoreRefDto? store;
@override@JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson) final  CategoryRefDto? category;
 final  List<String>? _photos;
@override@JsonKey(fromJson: photoListFromJson, toJson: photoListToJson) List<String>? get photos {
  final value = _photos;
  if (value == null) return null;
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ProductOptionDto>? _options;
@override@JsonKey(fromJson: optionsFromJson, toJson: optionsToJson) List<ProductOptionDto>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: intOrNull) final  int? priceSyp;
@override@JsonKey(fromJson: boolOrNull) final  bool? priceIsEstimate;
@override@JsonKey(fromJson: boolOrNull) final  bool? canPurchase;
@override@JsonKey(fromJson: boolOrNull) final  bool? available;
@override@JsonKey(fromJson: stringOrNull) final  String? currencyListed;
@override@JsonKey(fromJson: boolOrNull) final  bool? isFavorited;
@override@JsonKey(fromJson: doubleOrNull) final  double? averageRating;
@override@JsonKey(fromJson: intOrNull) final  int? reviewsCount;
@override@JsonKey(fromJson: shareFromJson, toJson: shareToJson) final  ShareDto? share;
@override@JsonKey(fromJson: seoFromJson, toJson: seoToJson) final  SeoDto? seo;
@override@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) final  ViewerActivityDto? viewerActivity;

/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailDtoCopyWith<_ProductDetailDto> get copyWith => __$ProductDetailDtoCopyWithImpl<_ProductDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.store, store) || other.store == store)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.photos, _photos)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.priceSyp, priceSyp) || other.priceSyp == priceSyp)&&(identical(other.priceIsEstimate, priceIsEstimate) || other.priceIsEstimate == priceIsEstimate)&&(identical(other.canPurchase, canPurchase) || other.canPurchase == canPurchase)&&(identical(other.available, available) || other.available == available)&&(identical(other.currencyListed, currencyListed) || other.currencyListed == currencyListed)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.share, share) || other.share == share)&&(identical(other.seo, seo) || other.seo == seo)&&(identical(other.viewerActivity, viewerActivity) || other.viewerActivity == viewerActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,slug,path,name,description,store,category,const DeepCollectionEquality().hash(_photos),const DeepCollectionEquality().hash(_options),priceSyp,priceIsEstimate,canPurchase,available,currencyListed,isFavorited,averageRating,reviewsCount,share,seo,viewerActivity]);
}

@override
String toString() {
    return 'ProductDetailDto(id: $id, slug: $slug, path: $path, name: $name, description: $description, store: $store, category: $category, photos: $photos, options: $options, priceSyp: $priceSyp, priceIsEstimate: $priceIsEstimate, canPurchase: $canPurchase, available: $available, currencyListed: $currencyListed, isFavorited: $isFavorited, averageRating: $averageRating, reviewsCount: $reviewsCount, share: $share, seo: $seo, viewerActivity: $viewerActivity)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailDtoCopyWith<$Res> implements $ProductDetailDtoCopyWith<$Res> {
  factory _$ProductDetailDtoCopyWith(_ProductDetailDto value, $Res Function(_ProductDetailDto) _then) = __$ProductDetailDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: stringOrNull) String? path,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? description,@JsonKey(fromJson: storeRefFromJson, toJson: storeRefToJson) StoreRefDto? store,@JsonKey(fromJson: categoryRefFromJson, toJson: categoryRefToJson) CategoryRefDto? category,@JsonKey(fromJson: photoListFromJson, toJson: photoListToJson) List<String>? photos,@JsonKey(fromJson: optionsFromJson, toJson: optionsToJson) List<ProductOptionDto>? options,@JsonKey(fromJson: intOrNull) int? priceSyp,@JsonKey(fromJson: boolOrNull) bool? priceIsEstimate,@JsonKey(fromJson: boolOrNull) bool? canPurchase,@JsonKey(fromJson: boolOrNull) bool? available,@JsonKey(fromJson: stringOrNull) String? currencyListed,@JsonKey(fromJson: boolOrNull) bool? isFavorited,@JsonKey(fromJson: doubleOrNull) double? averageRating,@JsonKey(fromJson: intOrNull) int? reviewsCount,@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,@JsonKey(fromJson: seoFromJson, toJson: seoToJson) SeoDto? seo,@JsonKey(fromJson: viewerActivityFromJson, toJson: viewerActivityToJson) ViewerActivityDto? viewerActivity
});


@override $StoreRefDtoCopyWith<$Res>? get store;@override $CategoryRefDtoCopyWith<$Res>? get category;@override $ShareDtoCopyWith<$Res>? get share;@override $SeoDtoCopyWith<$Res>? get seo;@override $ViewerActivityDtoCopyWith<$Res>? get viewerActivity;

}
/// @nodoc
class __$ProductDetailDtoCopyWithImpl<$Res>
    implements _$ProductDetailDtoCopyWith<$Res> {
  __$ProductDetailDtoCopyWithImpl(this._self, this._then);

  final _ProductDetailDto _self;
  final $Res Function(_ProductDetailDto) _then;

/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? slug = freezed,Object? path = freezed,Object? name = freezed,Object? description = freezed,Object? store = freezed,Object? category = freezed,Object? photos = freezed,Object? options = freezed,Object? priceSyp = freezed,Object? priceIsEstimate = freezed,Object? canPurchase = freezed,Object? available = freezed,Object? currencyListed = freezed,Object? isFavorited = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? share = freezed,Object? seo = freezed,Object? viewerActivity = freezed,}) {
  return _then(_ProductDetailDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as StoreRefDto?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryRefDto?,photos: freezed == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ProductOptionDto>?,priceSyp: freezed == priceSyp ? _self.priceSyp : priceSyp // ignore: cast_nullable_to_non_nullable
as int?,priceIsEstimate: freezed == priceIsEstimate ? _self.priceIsEstimate : priceIsEstimate // ignore: cast_nullable_to_non_nullable
as bool?,canPurchase: freezed == canPurchase ? _self.canPurchase : canPurchase // ignore: cast_nullable_to_non_nullable
as bool?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,currencyListed: freezed == currencyListed ? _self.currencyListed : currencyListed // ignore: cast_nullable_to_non_nullable
as String?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareDto?,seo: freezed == seo ? _self.seo : seo // ignore: cast_nullable_to_non_nullable
as SeoDto?,viewerActivity: freezed == viewerActivity ? _self.viewerActivity : viewerActivity // ignore: cast_nullable_to_non_nullable
as ViewerActivityDto?,
  ));
}

/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreRefDtoCopyWith<$Res>? get store {
    if (_self.store == null) {
    return null;
  }

  return $StoreRefDtoCopyWith<$Res>(_self.store!, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryRefDtoCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryRefDtoCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareDtoCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeoDtoCopyWith<$Res>? get seo {
    if (_self.seo == null) {
    return null;
  }

  return $SeoDtoCopyWith<$Res>(_self.seo!, (value) {
    return _then(_self.copyWith(seo: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerActivityDtoCopyWith<$Res>? get viewerActivity {
    if (_self.viewerActivity == null) {
    return null;
  }

  return $ViewerActivityDtoCopyWith<$Res>(_self.viewerActivity!, (value) {
    return _then(_self.copyWith(viewerActivity: value));
  });
}
}


/// @nodoc
mixin _$CategoryDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: stringOrNull) String? get slug;@JsonKey(fromJson: intOrNull) int? get parentId;@JsonKey(fromJson: photoUrlOrNull) String? get image;
/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<CategoryDto> get copyWith => _$CategoryDtoCopyWithImpl<CategoryDto>(this as CategoryDto, _$identity);

  /// Serializes this CategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.image, _this.image) || other.image == _this.image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.slug,_this.parentId,_this.image);
}

@override
String toString() {
  final _this = this as CategoryDto;
  return 'CategoryDto(id: ${_this.id}, name: ${_this.name}, slug: ${_this.slug}, parentId: ${_this.parentId}, image: ${_this.image})';
}


}

/// @nodoc
abstract mixin class $CategoryDtoCopyWith<$Res>  {
  factory $CategoryDtoCopyWith(CategoryDto value, $Res Function(CategoryDto) _then) = _$CategoryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: intOrNull) int? parentId,@JsonKey(fromJson: photoUrlOrNull) String? image
});




}
/// @nodoc
class _$CategoryDtoCopyWithImpl<$Res>
    implements $CategoryDtoCopyWith<$Res> {
  _$CategoryDtoCopyWithImpl(this._self, this._then);

  final CategoryDto _self;
  final $Res Function(CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,Object? parentId = freezed,Object? image = freezed,}) {
  return _then(CategoryDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryDto].
extension CategoryDtoPatterns on CategoryDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: intOrNull)  int? parentId, @JsonKey(fromJson: photoUrlOrNull)  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.parentId,_that.image);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: intOrNull)  int? parentId, @JsonKey(fromJson: photoUrlOrNull)  String? image)  $default,) {final _that = this;
switch (_that) {
case _CategoryDto():
return $default(_that.id,_that.name,_that.slug,_that.parentId,_that.image);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: intOrNull)  int? parentId, @JsonKey(fromJson: photoUrlOrNull)  String? image)?  $default,) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.parentId,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryDto implements CategoryDto {
  const _CategoryDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: stringOrNull) this.slug, @JsonKey(fromJson: intOrNull) this.parentId, @JsonKey(fromJson: photoUrlOrNull) this.image});
  factory _CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: stringOrNull) final  String? slug;
@override@JsonKey(fromJson: intOrNull) final  int? parentId;
@override@JsonKey(fromJson: photoUrlOrNull) final  String? image;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDtoCopyWith<_CategoryDto> get copyWith => __$CategoryDtoCopyWithImpl<_CategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,slug,parentId,image);
}

@override
String toString() {
    return 'CategoryDto(id: $id, name: $name, slug: $slug, parentId: $parentId, image: $image)';
}


}

/// @nodoc
abstract mixin class _$CategoryDtoCopyWith<$Res> implements $CategoryDtoCopyWith<$Res> {
  factory _$CategoryDtoCopyWith(_CategoryDto value, $Res Function(_CategoryDto) _then) = __$CategoryDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: intOrNull) int? parentId,@JsonKey(fromJson: photoUrlOrNull) String? image
});




}
/// @nodoc
class __$CategoryDtoCopyWithImpl<$Res>
    implements _$CategoryDtoCopyWith<$Res> {
  __$CategoryDtoCopyWithImpl(this._self, this._then);

  final _CategoryDto _self;
  final $Res Function(_CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,Object? parentId = freezed,Object? image = freezed,}) {
  return _then(_CategoryDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CityDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: stringOrNull) String? get code;@JsonKey(fromJson: boolOrNull) bool? get isActive;@JsonKey(fromJson: stringOrNull) String? get status;@JsonKey(fromJson: stringOrNull) String? get label;
/// Create a copy of CityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityDtoCopyWith<CityDto> get copyWith => _$CityDtoCopyWithImpl<CityDto>(this as CityDto, _$identity);

  /// Serializes this CityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CityDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.label, _this.label) || other.label == _this.label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CityDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.code,_this.isActive,_this.status,_this.label);
}

@override
String toString() {
  final _this = this as CityDto;
  return 'CityDto(id: ${_this.id}, name: ${_this.name}, code: ${_this.code}, isActive: ${_this.isActive}, status: ${_this.status}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $CityDtoCopyWith<$Res>  {
  factory $CityDtoCopyWith(CityDto value, $Res Function(CityDto) _then) = _$CityDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? code,@JsonKey(fromJson: boolOrNull) bool? isActive,@JsonKey(fromJson: stringOrNull) String? status,@JsonKey(fromJson: stringOrNull) String? label
});




}
/// @nodoc
class _$CityDtoCopyWithImpl<$Res>
    implements $CityDtoCopyWith<$Res> {
  _$CityDtoCopyWithImpl(this._self, this._then);

  final CityDto _self;
  final $Res Function(CityDto) _then;

/// Create a copy of CityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? code = freezed,Object? isActive = freezed,Object? status = freezed,Object? label = freezed,}) {
  return _then(CityDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CityDto].
extension CityDtoPatterns on CityDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityDto value)  $default,){
final _that = this;
switch (_that) {
case _CityDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityDto value)?  $default,){
final _that = this;
switch (_that) {
case _CityDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? code, @JsonKey(fromJson: boolOrNull)  bool? isActive, @JsonKey(fromJson: stringOrNull)  String? status, @JsonKey(fromJson: stringOrNull)  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityDto() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.isActive,_that.status,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? code, @JsonKey(fromJson: boolOrNull)  bool? isActive, @JsonKey(fromJson: stringOrNull)  String? status, @JsonKey(fromJson: stringOrNull)  String? label)  $default,) {final _that = this;
switch (_that) {
case _CityDto():
return $default(_that.id,_that.name,_that.code,_that.isActive,_that.status,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? code, @JsonKey(fromJson: boolOrNull)  bool? isActive, @JsonKey(fromJson: stringOrNull)  String? status, @JsonKey(fromJson: stringOrNull)  String? label)?  $default,) {final _that = this;
switch (_that) {
case _CityDto() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.isActive,_that.status,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CityDto implements CityDto {
  const _CityDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: stringOrNull) this.code, @JsonKey(fromJson: boolOrNull) this.isActive, @JsonKey(fromJson: stringOrNull) this.status, @JsonKey(fromJson: stringOrNull) this.label});
  factory _CityDto.fromJson(Map<String, dynamic> json) => _$CityDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: stringOrNull) final  String? code;
@override@JsonKey(fromJson: boolOrNull) final  bool? isActive;
@override@JsonKey(fromJson: stringOrNull) final  String? status;
@override@JsonKey(fromJson: stringOrNull) final  String? label;

/// Create a copy of CityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityDtoCopyWith<_CityDto> get copyWith => __$CityDtoCopyWithImpl<_CityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.status, status) || other.status == status)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,code,isActive,status,label);
}

@override
String toString() {
    return 'CityDto(id: $id, name: $name, code: $code, isActive: $isActive, status: $status, label: $label)';
}


}

/// @nodoc
abstract mixin class _$CityDtoCopyWith<$Res> implements $CityDtoCopyWith<$Res> {
  factory _$CityDtoCopyWith(_CityDto value, $Res Function(_CityDto) _then) = __$CityDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? code,@JsonKey(fromJson: boolOrNull) bool? isActive,@JsonKey(fromJson: stringOrNull) String? status,@JsonKey(fromJson: stringOrNull) String? label
});




}
/// @nodoc
class __$CityDtoCopyWithImpl<$Res>
    implements _$CityDtoCopyWith<$Res> {
  __$CityDtoCopyWithImpl(this._self, this._then);

  final _CityDto _self;
  final $Res Function(_CityDto) _then;

/// Create a copy of CityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? code = freezed,Object? isActive = freezed,Object? status = freezed,Object? label = freezed,}) {
  return _then(_CityDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PageMetaDto {

@JsonKey(fromJson: intOrNull) int? get page;@JsonKey(fromJson: intOrNull) int? get perPage;@JsonKey(fromJson: intOrNull) int? get total;@JsonKey(fromJson: intOrNull) int? get lastPage;
/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<PageMetaDto> get copyWith => _$PageMetaDtoCopyWithImpl<PageMetaDto>(this as PageMetaDto, _$identity);

  /// Serializes this PageMetaDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PageMetaDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageMetaDto&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.perPage, _this.perPage) || other.perPage == _this.perPage)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.lastPage, _this.lastPage) || other.lastPage == _this.lastPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PageMetaDto;
  return Object.hash(runtimeType,_this.page,_this.perPage,_this.total,_this.lastPage);
}

@override
String toString() {
  final _this = this as PageMetaDto;
  return 'PageMetaDto(page: ${_this.page}, perPage: ${_this.perPage}, total: ${_this.total}, lastPage: ${_this.lastPage})';
}


}

/// @nodoc
abstract mixin class $PageMetaDtoCopyWith<$Res>  {
  factory $PageMetaDtoCopyWith(PageMetaDto value, $Res Function(PageMetaDto) _then) = _$PageMetaDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? page,@JsonKey(fromJson: intOrNull) int? perPage,@JsonKey(fromJson: intOrNull) int? total,@JsonKey(fromJson: intOrNull) int? lastPage
});




}
/// @nodoc
class _$PageMetaDtoCopyWithImpl<$Res>
    implements $PageMetaDtoCopyWith<$Res> {
  _$PageMetaDtoCopyWithImpl(this._self, this._then);

  final PageMetaDto _self;
  final $Res Function(PageMetaDto) _then;

/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = freezed,Object? perPage = freezed,Object? total = freezed,Object? lastPage = freezed,}) {
  return _then(PageMetaDto(
page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,lastPage: freezed == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PageMetaDto].
extension PageMetaDtoPatterns on PageMetaDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageMetaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageMetaDto value)  $default,){
final _that = this;
switch (_that) {
case _PageMetaDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageMetaDto value)?  $default,){
final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? page, @JsonKey(fromJson: intOrNull)  int? perPage, @JsonKey(fromJson: intOrNull)  int? total, @JsonKey(fromJson: intOrNull)  int? lastPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
return $default(_that.page,_that.perPage,_that.total,_that.lastPage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? page, @JsonKey(fromJson: intOrNull)  int? perPage, @JsonKey(fromJson: intOrNull)  int? total, @JsonKey(fromJson: intOrNull)  int? lastPage)  $default,) {final _that = this;
switch (_that) {
case _PageMetaDto():
return $default(_that.page,_that.perPage,_that.total,_that.lastPage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? page, @JsonKey(fromJson: intOrNull)  int? perPage, @JsonKey(fromJson: intOrNull)  int? total, @JsonKey(fromJson: intOrNull)  int? lastPage)?  $default,) {final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
return $default(_that.page,_that.perPage,_that.total,_that.lastPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageMetaDto implements PageMetaDto {
  const _PageMetaDto({@JsonKey(fromJson: intOrNull) this.page, @JsonKey(fromJson: intOrNull) this.perPage, @JsonKey(fromJson: intOrNull) this.total, @JsonKey(fromJson: intOrNull) this.lastPage});
  factory _PageMetaDto.fromJson(Map<String, dynamic> json) => _$PageMetaDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? page;
@override@JsonKey(fromJson: intOrNull) final  int? perPage;
@override@JsonKey(fromJson: intOrNull) final  int? total;
@override@JsonKey(fromJson: intOrNull) final  int? lastPage;

/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageMetaDtoCopyWith<_PageMetaDto> get copyWith => __$PageMetaDtoCopyWithImpl<_PageMetaDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageMetaDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageMetaDto&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,page,perPage,total,lastPage);
}

@override
String toString() {
    return 'PageMetaDto(page: $page, perPage: $perPage, total: $total, lastPage: $lastPage)';
}


}

/// @nodoc
abstract mixin class _$PageMetaDtoCopyWith<$Res> implements $PageMetaDtoCopyWith<$Res> {
  factory _$PageMetaDtoCopyWith(_PageMetaDto value, $Res Function(_PageMetaDto) _then) = __$PageMetaDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? page,@JsonKey(fromJson: intOrNull) int? perPage,@JsonKey(fromJson: intOrNull) int? total,@JsonKey(fromJson: intOrNull) int? lastPage
});




}
/// @nodoc
class __$PageMetaDtoCopyWithImpl<$Res>
    implements _$PageMetaDtoCopyWith<$Res> {
  __$PageMetaDtoCopyWithImpl(this._self, this._then);

  final _PageMetaDto _self;
  final $Res Function(_PageMetaDto) _then;

/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = freezed,Object? perPage = freezed,Object? total = freezed,Object? lastPage = freezed,}) {
  return _then(_PageMetaDto(
page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,lastPage: freezed == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ProductPageDto {

@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get data;@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) PageMetaDto? get meta;
/// Create a copy of ProductPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductPageDtoCopyWith<ProductPageDto> get copyWith => _$ProductPageDtoCopyWithImpl<ProductPageDto>(this as ProductPageDto, _$identity);

  /// Serializes this ProductPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductPageDto&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.data),_this.meta);
}

@override
String toString() {
  final _this = this as ProductPageDto;
  return 'ProductPageDto(data: ${_this.data}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $ProductPageDtoCopyWith<$Res>  {
  factory $ProductPageDtoCopyWith(ProductPageDto value, $Res Function(ProductPageDto) _then) = _$ProductPageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? data,@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) PageMetaDto? meta
});


$PageMetaDtoCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ProductPageDtoCopyWithImpl<$Res>
    implements $ProductPageDtoCopyWith<$Res> {
  _$ProductPageDtoCopyWithImpl(this._self, this._then);

  final ProductPageDto _self;
  final $Res Function(ProductPageDto) _then;

/// Create a copy of ProductPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? meta = freezed,}) {
  return _then(ProductPageDto(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PageMetaDto?,
  ));
}
/// Create a copy of ProductPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $PageMetaDtoCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductPageDto].
extension ProductPageDtoPatterns on ProductPageDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductPageDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductPageDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductPageDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductPageDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)  PageMetaDto? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductPageDto() when $default != null:
return $default(_that.data,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)  PageMetaDto? meta)  $default,) {final _that = this;
switch (_that) {
case _ProductPageDto():
return $default(_that.data,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)  PageMetaDto? meta)?  $default,) {final _that = this;
switch (_that) {
case _ProductPageDto() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductPageDto implements ProductPageDto {
  const _ProductPageDto({@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) this.meta}): _data = data;
  factory _ProductPageDto.fromJson(Map<String, dynamic> json) => _$ProductPageDtoFromJson(json);

 final  List<ProductCardDto>? _data;
@override@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) final  PageMetaDto? meta;

/// Create a copy of ProductPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductPageDtoCopyWith<_ProductPageDto> get copyWith => __$ProductPageDtoCopyWithImpl<_ProductPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductPageDto&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);
}

@override
String toString() {
    return 'ProductPageDto(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$ProductPageDtoCopyWith<$Res> implements $ProductPageDtoCopyWith<$Res> {
  factory _$ProductPageDtoCopyWith(_ProductPageDto value, $Res Function(_ProductPageDto) _then) = __$ProductPageDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? data,@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) PageMetaDto? meta
});


@override $PageMetaDtoCopyWith<$Res>? get meta;

}
/// @nodoc
class __$ProductPageDtoCopyWithImpl<$Res>
    implements _$ProductPageDtoCopyWith<$Res> {
  __$ProductPageDtoCopyWithImpl(this._self, this._then);

  final _ProductPageDto _self;
  final $Res Function(_ProductPageDto) _then;

/// Create a copy of ProductPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? meta = freezed,}) {
  return _then(_ProductPageDto(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PageMetaDto?,
  ));
}

/// Create a copy of ProductPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $PageMetaDtoCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$DeliveryPromiseDto {

@JsonKey(fromJson: stringOrNull) String? get messageAr;@JsonKey(fromJson: stringOrNull) String? get updatedAt;
/// Create a copy of DeliveryPromiseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryPromiseDtoCopyWith<DeliveryPromiseDto> get copyWith => _$DeliveryPromiseDtoCopyWithImpl<DeliveryPromiseDto>(this as DeliveryPromiseDto, _$identity);

  /// Serializes this DeliveryPromiseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeliveryPromiseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryPromiseDto&&(identical(other.messageAr, _this.messageAr) || other.messageAr == _this.messageAr)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeliveryPromiseDto;
  return Object.hash(runtimeType,_this.messageAr,_this.updatedAt);
}

@override
String toString() {
  final _this = this as DeliveryPromiseDto;
  return 'DeliveryPromiseDto(messageAr: ${_this.messageAr}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $DeliveryPromiseDtoCopyWith<$Res>  {
  factory $DeliveryPromiseDtoCopyWith(DeliveryPromiseDto value, $Res Function(DeliveryPromiseDto) _then) = _$DeliveryPromiseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? messageAr,@JsonKey(fromJson: stringOrNull) String? updatedAt
});




}
/// @nodoc
class _$DeliveryPromiseDtoCopyWithImpl<$Res>
    implements $DeliveryPromiseDtoCopyWith<$Res> {
  _$DeliveryPromiseDtoCopyWithImpl(this._self, this._then);

  final DeliveryPromiseDto _self;
  final $Res Function(DeliveryPromiseDto) _then;

/// Create a copy of DeliveryPromiseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageAr = freezed,Object? updatedAt = freezed,}) {
  return _then(DeliveryPromiseDto(
messageAr: freezed == messageAr ? _self.messageAr : messageAr // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryPromiseDto].
extension DeliveryPromiseDtoPatterns on DeliveryPromiseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryPromiseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryPromiseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryPromiseDto value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryPromiseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryPromiseDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryPromiseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? messageAr, @JsonKey(fromJson: stringOrNull)  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryPromiseDto() when $default != null:
return $default(_that.messageAr,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? messageAr, @JsonKey(fromJson: stringOrNull)  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DeliveryPromiseDto():
return $default(_that.messageAr,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? messageAr, @JsonKey(fromJson: stringOrNull)  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryPromiseDto() when $default != null:
return $default(_that.messageAr,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryPromiseDto implements DeliveryPromiseDto {
  const _DeliveryPromiseDto({@JsonKey(fromJson: stringOrNull) this.messageAr, @JsonKey(fromJson: stringOrNull) this.updatedAt});
  factory _DeliveryPromiseDto.fromJson(Map<String, dynamic> json) => _$DeliveryPromiseDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? messageAr;
@override@JsonKey(fromJson: stringOrNull) final  String? updatedAt;

/// Create a copy of DeliveryPromiseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryPromiseDtoCopyWith<_DeliveryPromiseDto> get copyWith => __$DeliveryPromiseDtoCopyWithImpl<_DeliveryPromiseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryPromiseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryPromiseDto&&(identical(other.messageAr, messageAr) || other.messageAr == messageAr)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageAr,updatedAt);
}

@override
String toString() {
    return 'DeliveryPromiseDto(messageAr: $messageAr, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DeliveryPromiseDtoCopyWith<$Res> implements $DeliveryPromiseDtoCopyWith<$Res> {
  factory _$DeliveryPromiseDtoCopyWith(_DeliveryPromiseDto value, $Res Function(_DeliveryPromiseDto) _then) = __$DeliveryPromiseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? messageAr,@JsonKey(fromJson: stringOrNull) String? updatedAt
});




}
/// @nodoc
class __$DeliveryPromiseDtoCopyWithImpl<$Res>
    implements _$DeliveryPromiseDtoCopyWith<$Res> {
  __$DeliveryPromiseDtoCopyWithImpl(this._self, this._then);

  final _DeliveryPromiseDto _self;
  final $Res Function(_DeliveryPromiseDto) _then;

/// Create a copy of DeliveryPromiseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageAr = freezed,Object? updatedAt = freezed,}) {
  return _then(_DeliveryPromiseDto(
messageAr: freezed == messageAr ? _self.messageAr : messageAr // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RecommendationsDto {

@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get recentlyViewed;
/// Create a copy of RecommendationsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationsDtoCopyWith<RecommendationsDto> get copyWith => _$RecommendationsDtoCopyWithImpl<RecommendationsDto>(this as RecommendationsDto, _$identity);

  /// Serializes this RecommendationsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecommendationsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationsDto&&const DeepCollectionEquality().equals(other.recentlyViewed, _this.recentlyViewed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecommendationsDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.recentlyViewed));
}

@override
String toString() {
  final _this = this as RecommendationsDto;
  return 'RecommendationsDto(recentlyViewed: ${_this.recentlyViewed})';
}


}

/// @nodoc
abstract mixin class $RecommendationsDtoCopyWith<$Res>  {
  factory $RecommendationsDtoCopyWith(RecommendationsDto value, $Res Function(RecommendationsDto) _then) = _$RecommendationsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? recentlyViewed
});




}
/// @nodoc
class _$RecommendationsDtoCopyWithImpl<$Res>
    implements $RecommendationsDtoCopyWith<$Res> {
  _$RecommendationsDtoCopyWithImpl(this._self, this._then);

  final RecommendationsDto _self;
  final $Res Function(RecommendationsDto) _then;

/// Create a copy of RecommendationsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recentlyViewed = freezed,}) {
  return _then(RecommendationsDto(
recentlyViewed: freezed == recentlyViewed ? _self.recentlyViewed : recentlyViewed // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationsDto].
extension RecommendationsDtoPatterns on RecommendationsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationsDto value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationsDto value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? recentlyViewed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationsDto() when $default != null:
return $default(_that.recentlyViewed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? recentlyViewed)  $default,) {final _that = this;
switch (_that) {
case _RecommendationsDto():
return $default(_that.recentlyViewed);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? recentlyViewed)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationsDto() when $default != null:
return $default(_that.recentlyViewed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendationsDto implements RecommendationsDto {
  const _RecommendationsDto({@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? recentlyViewed}): _recentlyViewed = recentlyViewed;
  factory _RecommendationsDto.fromJson(Map<String, dynamic> json) => _$RecommendationsDtoFromJson(json);

 final  List<ProductCardDto>? _recentlyViewed;
@override@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get recentlyViewed {
  final value = _recentlyViewed;
  if (value == null) return null;
  if (_recentlyViewed is EqualUnmodifiableListView) return _recentlyViewed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RecommendationsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationsDtoCopyWith<_RecommendationsDto> get copyWith => __$RecommendationsDtoCopyWithImpl<_RecommendationsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationsDto&&const DeepCollectionEquality().equals(other.recentlyViewed, _recentlyViewed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_recentlyViewed));
}

@override
String toString() {
    return 'RecommendationsDto(recentlyViewed: $recentlyViewed)';
}


}

/// @nodoc
abstract mixin class _$RecommendationsDtoCopyWith<$Res> implements $RecommendationsDtoCopyWith<$Res> {
  factory _$RecommendationsDtoCopyWith(_RecommendationsDto value, $Res Function(_RecommendationsDto) _then) = __$RecommendationsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? recentlyViewed
});




}
/// @nodoc
class __$RecommendationsDtoCopyWithImpl<$Res>
    implements _$RecommendationsDtoCopyWith<$Res> {
  __$RecommendationsDtoCopyWithImpl(this._self, this._then);

  final _RecommendationsDto _self;
  final $Res Function(_RecommendationsDto) _then;

/// Create a copy of RecommendationsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recentlyViewed = freezed,}) {
  return _then(_RecommendationsDto(
recentlyViewed: freezed == recentlyViewed ? _self._recentlyViewed : recentlyViewed // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,
  ));
}


}


/// @nodoc
mixin _$HomeDto {

@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson) DeliveryPromiseDto? get deliveryPromise;@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get featured;@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get latest;@JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson) RecommendationsDto? get recommendations;
/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDtoCopyWith<HomeDto> get copyWith => _$HomeDtoCopyWithImpl<HomeDto>(this as HomeDto, _$identity);

  /// Serializes this HomeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HomeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDto&&(identical(other.deliveryPromise, _this.deliveryPromise) || other.deliveryPromise == _this.deliveryPromise)&&const DeepCollectionEquality().equals(other.featured, _this.featured)&&const DeepCollectionEquality().equals(other.latest, _this.latest)&&(identical(other.recommendations, _this.recommendations) || other.recommendations == _this.recommendations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HomeDto;
  return Object.hash(runtimeType,_this.deliveryPromise,const DeepCollectionEquality().hash(_this.featured),const DeepCollectionEquality().hash(_this.latest),_this.recommendations);
}

@override
String toString() {
  final _this = this as HomeDto;
  return 'HomeDto(deliveryPromise: ${_this.deliveryPromise}, featured: ${_this.featured}, latest: ${_this.latest}, recommendations: ${_this.recommendations})';
}


}

/// @nodoc
abstract mixin class $HomeDtoCopyWith<$Res>  {
  factory $HomeDtoCopyWith(HomeDto value, $Res Function(HomeDto) _then) = _$HomeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson) DeliveryPromiseDto? deliveryPromise,@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? featured,@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? latest,@JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson) RecommendationsDto? recommendations
});


$DeliveryPromiseDtoCopyWith<$Res>? get deliveryPromise;$RecommendationsDtoCopyWith<$Res>? get recommendations;

}
/// @nodoc
class _$HomeDtoCopyWithImpl<$Res>
    implements $HomeDtoCopyWith<$Res> {
  _$HomeDtoCopyWithImpl(this._self, this._then);

  final HomeDto _self;
  final $Res Function(HomeDto) _then;

/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryPromise = freezed,Object? featured = freezed,Object? latest = freezed,Object? recommendations = freezed,}) {
  return _then(HomeDto(
deliveryPromise: freezed == deliveryPromise ? _self.deliveryPromise : deliveryPromise // ignore: cast_nullable_to_non_nullable
as DeliveryPromiseDto?,featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,recommendations: freezed == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as RecommendationsDto?,
  ));
}
/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryPromiseDtoCopyWith<$Res>? get deliveryPromise {
    if (_self.deliveryPromise == null) {
    return null;
  }

  return $DeliveryPromiseDtoCopyWith<$Res>(_self.deliveryPromise!, (value) {
    return _then(_self.copyWith(deliveryPromise: value));
  });
}/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecommendationsDtoCopyWith<$Res>? get recommendations {
    if (_self.recommendations == null) {
    return null;
  }

  return $RecommendationsDtoCopyWith<$Res>(_self.recommendations!, (value) {
    return _then(_self.copyWith(recommendations: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeDto].
extension HomeDtoPatterns on HomeDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDto value)  $default,){
final _that = this;
switch (_that) {
case _HomeDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDto value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson)  DeliveryPromiseDto? deliveryPromise, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? featured, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? latest, @JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson)  RecommendationsDto? recommendations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDto() when $default != null:
return $default(_that.deliveryPromise,_that.featured,_that.latest,_that.recommendations);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson)  DeliveryPromiseDto? deliveryPromise, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? featured, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? latest, @JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson)  RecommendationsDto? recommendations)  $default,) {final _that = this;
switch (_that) {
case _HomeDto():
return $default(_that.deliveryPromise,_that.featured,_that.latest,_that.recommendations);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson)  DeliveryPromiseDto? deliveryPromise, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? featured, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? latest, @JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson)  RecommendationsDto? recommendations)?  $default,) {final _that = this;
switch (_that) {
case _HomeDto() when $default != null:
return $default(_that.deliveryPromise,_that.featured,_that.latest,_that.recommendations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDto implements HomeDto {
  const _HomeDto({@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson) this.deliveryPromise, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? featured, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? latest, @JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson) this.recommendations}): _featured = featured,_latest = latest;
  factory _HomeDto.fromJson(Map<String, dynamic> json) => _$HomeDtoFromJson(json);

@override@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson) final  DeliveryPromiseDto? deliveryPromise;
 final  List<ProductCardDto>? _featured;
@override@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get featured {
  final value = _featured;
  if (value == null) return null;
  if (_featured is EqualUnmodifiableListView) return _featured;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ProductCardDto>? _latest;
@override@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get latest {
  final value = _latest;
  if (value == null) return null;
  if (_latest is EqualUnmodifiableListView) return _latest;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson) final  RecommendationsDto? recommendations;

/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDtoCopyWith<_HomeDto> get copyWith => __$HomeDtoCopyWithImpl<_HomeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDto&&(identical(other.deliveryPromise, deliveryPromise) || other.deliveryPromise == deliveryPromise)&&const DeepCollectionEquality().equals(other.featured, _featured)&&const DeepCollectionEquality().equals(other.latest, _latest)&&(identical(other.recommendations, recommendations) || other.recommendations == recommendations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deliveryPromise,const DeepCollectionEquality().hash(_featured),const DeepCollectionEquality().hash(_latest),recommendations);
}

@override
String toString() {
    return 'HomeDto(deliveryPromise: $deliveryPromise, featured: $featured, latest: $latest, recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class _$HomeDtoCopyWith<$Res> implements $HomeDtoCopyWith<$Res> {
  factory _$HomeDtoCopyWith(_HomeDto value, $Res Function(_HomeDto) _then) = __$HomeDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: deliveryFromJson, toJson: deliveryToJson) DeliveryPromiseDto? deliveryPromise,@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? featured,@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? latest,@JsonKey(fromJson: recommendationsFromJson, toJson: recommendationsToJson) RecommendationsDto? recommendations
});


@override $DeliveryPromiseDtoCopyWith<$Res>? get deliveryPromise;@override $RecommendationsDtoCopyWith<$Res>? get recommendations;

}
/// @nodoc
class __$HomeDtoCopyWithImpl<$Res>
    implements _$HomeDtoCopyWith<$Res> {
  __$HomeDtoCopyWithImpl(this._self, this._then);

  final _HomeDto _self;
  final $Res Function(_HomeDto) _then;

/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryPromise = freezed,Object? featured = freezed,Object? latest = freezed,Object? recommendations = freezed,}) {
  return _then(_HomeDto(
deliveryPromise: freezed == deliveryPromise ? _self.deliveryPromise : deliveryPromise // ignore: cast_nullable_to_non_nullable
as DeliveryPromiseDto?,featured: freezed == featured ? _self._featured : featured // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,latest: freezed == latest ? _self._latest : latest // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,recommendations: freezed == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as RecommendationsDto?,
  ));
}

/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryPromiseDtoCopyWith<$Res>? get deliveryPromise {
    if (_self.deliveryPromise == null) {
    return null;
  }

  return $DeliveryPromiseDtoCopyWith<$Res>(_self.deliveryPromise!, (value) {
    return _then(_self.copyWith(deliveryPromise: value));
  });
}/// Create a copy of HomeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecommendationsDtoCopyWith<$Res>? get recommendations {
    if (_self.recommendations == null) {
    return null;
  }

  return $RecommendationsDtoCopyWith<$Res>(_self.recommendations!, (value) {
    return _then(_self.copyWith(recommendations: value));
  });
}
}


/// @nodoc
mixin _$FacetBucketDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: intOrNull) int? get count;
/// Create a copy of FacetBucketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacetBucketDtoCopyWith<FacetBucketDto> get copyWith => _$FacetBucketDtoCopyWithImpl<FacetBucketDto>(this as FacetBucketDto, _$identity);

  /// Serializes this FacetBucketDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FacetBucketDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacetBucketDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FacetBucketDto;
  return Object.hash(runtimeType,_this.id,_this.count);
}

@override
String toString() {
  final _this = this as FacetBucketDto;
  return 'FacetBucketDto(id: ${_this.id}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $FacetBucketDtoCopyWith<$Res>  {
  factory $FacetBucketDtoCopyWith(FacetBucketDto value, $Res Function(FacetBucketDto) _then) = _$FacetBucketDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: intOrNull) int? count
});




}
/// @nodoc
class _$FacetBucketDtoCopyWithImpl<$Res>
    implements $FacetBucketDtoCopyWith<$Res> {
  _$FacetBucketDtoCopyWithImpl(this._self, this._then);

  final FacetBucketDto _self;
  final $Res Function(FacetBucketDto) _then;

/// Create a copy of FacetBucketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? count = freezed,}) {
  return _then(FacetBucketDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FacetBucketDto].
extension FacetBucketDtoPatterns on FacetBucketDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacetBucketDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacetBucketDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacetBucketDto value)  $default,){
final _that = this;
switch (_that) {
case _FacetBucketDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacetBucketDto value)?  $default,){
final _that = this;
switch (_that) {
case _FacetBucketDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: intOrNull)  int? count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacetBucketDto() when $default != null:
return $default(_that.id,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: intOrNull)  int? count)  $default,) {final _that = this;
switch (_that) {
case _FacetBucketDto():
return $default(_that.id,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: intOrNull)  int? count)?  $default,) {final _that = this;
switch (_that) {
case _FacetBucketDto() when $default != null:
return $default(_that.id,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacetBucketDto implements FacetBucketDto {
  const _FacetBucketDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: intOrNull) this.count});
  factory _FacetBucketDto.fromJson(Map<String, dynamic> json) => _$FacetBucketDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: intOrNull) final  int? count;

/// Create a copy of FacetBucketDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacetBucketDtoCopyWith<_FacetBucketDto> get copyWith => __$FacetBucketDtoCopyWithImpl<_FacetBucketDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacetBucketDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacetBucketDto&&(identical(other.id, id) || other.id == id)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,count);
}

@override
String toString() {
    return 'FacetBucketDto(id: $id, count: $count)';
}


}

/// @nodoc
abstract mixin class _$FacetBucketDtoCopyWith<$Res> implements $FacetBucketDtoCopyWith<$Res> {
  factory _$FacetBucketDtoCopyWith(_FacetBucketDto value, $Res Function(_FacetBucketDto) _then) = __$FacetBucketDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: intOrNull) int? count
});




}
/// @nodoc
class __$FacetBucketDtoCopyWithImpl<$Res>
    implements _$FacetBucketDtoCopyWith<$Res> {
  __$FacetBucketDtoCopyWithImpl(this._self, this._then);

  final _FacetBucketDto _self;
  final $Res Function(_FacetBucketDto) _then;

/// Create a copy of FacetBucketDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? count = freezed,}) {
  return _then(_FacetBucketDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FacetsDto {

@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? get category;@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? get brand;@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? get store;
/// Create a copy of FacetsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacetsDtoCopyWith<FacetsDto> get copyWith => _$FacetsDtoCopyWithImpl<FacetsDto>(this as FacetsDto, _$identity);

  /// Serializes this FacetsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FacetsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacetsDto&&const DeepCollectionEquality().equals(other.category, _this.category)&&const DeepCollectionEquality().equals(other.brand, _this.brand)&&const DeepCollectionEquality().equals(other.store, _this.store));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FacetsDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.category),const DeepCollectionEquality().hash(_this.brand),const DeepCollectionEquality().hash(_this.store));
}

@override
String toString() {
  final _this = this as FacetsDto;
  return 'FacetsDto(category: ${_this.category}, brand: ${_this.brand}, store: ${_this.store})';
}


}

/// @nodoc
abstract mixin class $FacetsDtoCopyWith<$Res>  {
  factory $FacetsDtoCopyWith(FacetsDto value, $Res Function(FacetsDto) _then) = _$FacetsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? category,@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? brand,@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? store
});




}
/// @nodoc
class _$FacetsDtoCopyWithImpl<$Res>
    implements $FacetsDtoCopyWith<$Res> {
  _$FacetsDtoCopyWithImpl(this._self, this._then);

  final FacetsDto _self;
  final $Res Function(FacetsDto) _then;

/// Create a copy of FacetsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? brand = freezed,Object? store = freezed,}) {
  return _then(FacetsDto(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as List<FacetBucketDto>?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as List<FacetBucketDto>?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as List<FacetBucketDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FacetsDto].
extension FacetsDtoPatterns on FacetsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacetsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacetsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacetsDto value)  $default,){
final _that = this;
switch (_that) {
case _FacetsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacetsDto value)?  $default,){
final _that = this;
switch (_that) {
case _FacetsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? category, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? brand, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? store)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacetsDto() when $default != null:
return $default(_that.category,_that.brand,_that.store);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? category, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? brand, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? store)  $default,) {final _that = this;
switch (_that) {
case _FacetsDto():
return $default(_that.category,_that.brand,_that.store);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? category, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? brand, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? store)?  $default,) {final _that = this;
switch (_that) {
case _FacetsDto() when $default != null:
return $default(_that.category,_that.brand,_that.store);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacetsDto implements FacetsDto {
  const _FacetsDto({@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? category, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? brand, @JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson)  List<FacetBucketDto>? store}): _category = category,_brand = brand,_store = store;
  factory _FacetsDto.fromJson(Map<String, dynamic> json) => _$FacetsDtoFromJson(json);

 final  List<FacetBucketDto>? _category;
@override@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? get category {
  final value = _category;
  if (value == null) return null;
  if (_category is EqualUnmodifiableListView) return _category;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<FacetBucketDto>? _brand;
@override@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? get brand {
  final value = _brand;
  if (value == null) return null;
  if (_brand is EqualUnmodifiableListView) return _brand;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<FacetBucketDto>? _store;
@override@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? get store {
  final value = _store;
  if (value == null) return null;
  if (_store is EqualUnmodifiableListView) return _store;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of FacetsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacetsDtoCopyWith<_FacetsDto> get copyWith => __$FacetsDtoCopyWithImpl<_FacetsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacetsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacetsDto&&const DeepCollectionEquality().equals(other.category, _category)&&const DeepCollectionEquality().equals(other.brand, _brand)&&const DeepCollectionEquality().equals(other.store, _store));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_category),const DeepCollectionEquality().hash(_brand),const DeepCollectionEquality().hash(_store));
}

@override
String toString() {
    return 'FacetsDto(category: $category, brand: $brand, store: $store)';
}


}

/// @nodoc
abstract mixin class _$FacetsDtoCopyWith<$Res> implements $FacetsDtoCopyWith<$Res> {
  factory _$FacetsDtoCopyWith(_FacetsDto value, $Res Function(_FacetsDto) _then) = __$FacetsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? category,@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? brand,@JsonKey(fromJson: facetsBucketsFromJson, toJson: facetBucketsToJson) List<FacetBucketDto>? store
});




}
/// @nodoc
class __$FacetsDtoCopyWithImpl<$Res>
    implements _$FacetsDtoCopyWith<$Res> {
  __$FacetsDtoCopyWithImpl(this._self, this._then);

  final _FacetsDto _self;
  final $Res Function(_FacetsDto) _then;

/// Create a copy of FacetsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? brand = freezed,Object? store = freezed,}) {
  return _then(_FacetsDto(
category: freezed == category ? _self._category : category // ignore: cast_nullable_to_non_nullable
as List<FacetBucketDto>?,brand: freezed == brand ? _self._brand : brand // ignore: cast_nullable_to_non_nullable
as List<FacetBucketDto>?,store: freezed == store ? _self._store : store // ignore: cast_nullable_to_non_nullable
as List<FacetBucketDto>?,
  ));
}


}


/// @nodoc
mixin _$SearchInfoDto {

@JsonKey(fromJson: stringOrNull) String? get q;@JsonKey(fromJson: stringOrNull) String? get normalizedQ;@JsonKey(fromJson: stringOrNull) String? get engine;@JsonKey(fromJson: boolOrNull) bool? get degraded;
/// Create a copy of SearchInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchInfoDtoCopyWith<SearchInfoDto> get copyWith => _$SearchInfoDtoCopyWithImpl<SearchInfoDto>(this as SearchInfoDto, _$identity);

  /// Serializes this SearchInfoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SearchInfoDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchInfoDto&&(identical(other.q, _this.q) || other.q == _this.q)&&(identical(other.normalizedQ, _this.normalizedQ) || other.normalizedQ == _this.normalizedQ)&&(identical(other.engine, _this.engine) || other.engine == _this.engine)&&(identical(other.degraded, _this.degraded) || other.degraded == _this.degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchInfoDto;
  return Object.hash(runtimeType,_this.q,_this.normalizedQ,_this.engine,_this.degraded);
}

@override
String toString() {
  final _this = this as SearchInfoDto;
  return 'SearchInfoDto(q: ${_this.q}, normalizedQ: ${_this.normalizedQ}, engine: ${_this.engine}, degraded: ${_this.degraded})';
}


}

/// @nodoc
abstract mixin class $SearchInfoDtoCopyWith<$Res>  {
  factory $SearchInfoDtoCopyWith(SearchInfoDto value, $Res Function(SearchInfoDto) _then) = _$SearchInfoDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? q,@JsonKey(fromJson: stringOrNull) String? normalizedQ,@JsonKey(fromJson: stringOrNull) String? engine,@JsonKey(fromJson: boolOrNull) bool? degraded
});




}
/// @nodoc
class _$SearchInfoDtoCopyWithImpl<$Res>
    implements $SearchInfoDtoCopyWith<$Res> {
  _$SearchInfoDtoCopyWithImpl(this._self, this._then);

  final SearchInfoDto _self;
  final $Res Function(SearchInfoDto) _then;

/// Create a copy of SearchInfoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? q = freezed,Object? normalizedQ = freezed,Object? engine = freezed,Object? degraded = freezed,}) {
  return _then(SearchInfoDto(
q: freezed == q ? _self.q : q // ignore: cast_nullable_to_non_nullable
as String?,normalizedQ: freezed == normalizedQ ? _self.normalizedQ : normalizedQ // ignore: cast_nullable_to_non_nullable
as String?,engine: freezed == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String?,degraded: freezed == degraded ? _self.degraded : degraded // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchInfoDto].
extension SearchInfoDtoPatterns on SearchInfoDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchInfoDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchInfoDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchInfoDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? q, @JsonKey(fromJson: stringOrNull)  String? normalizedQ, @JsonKey(fromJson: stringOrNull)  String? engine, @JsonKey(fromJson: boolOrNull)  bool? degraded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchInfoDto() when $default != null:
return $default(_that.q,_that.normalizedQ,_that.engine,_that.degraded);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? q, @JsonKey(fromJson: stringOrNull)  String? normalizedQ, @JsonKey(fromJson: stringOrNull)  String? engine, @JsonKey(fromJson: boolOrNull)  bool? degraded)  $default,) {final _that = this;
switch (_that) {
case _SearchInfoDto():
return $default(_that.q,_that.normalizedQ,_that.engine,_that.degraded);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? q, @JsonKey(fromJson: stringOrNull)  String? normalizedQ, @JsonKey(fromJson: stringOrNull)  String? engine, @JsonKey(fromJson: boolOrNull)  bool? degraded)?  $default,) {final _that = this;
switch (_that) {
case _SearchInfoDto() when $default != null:
return $default(_that.q,_that.normalizedQ,_that.engine,_that.degraded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchInfoDto implements SearchInfoDto {
  const _SearchInfoDto({@JsonKey(fromJson: stringOrNull) this.q, @JsonKey(fromJson: stringOrNull) this.normalizedQ, @JsonKey(fromJson: stringOrNull) this.engine, @JsonKey(fromJson: boolOrNull) this.degraded});
  factory _SearchInfoDto.fromJson(Map<String, dynamic> json) => _$SearchInfoDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? q;
@override@JsonKey(fromJson: stringOrNull) final  String? normalizedQ;
@override@JsonKey(fromJson: stringOrNull) final  String? engine;
@override@JsonKey(fromJson: boolOrNull) final  bool? degraded;

/// Create a copy of SearchInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchInfoDtoCopyWith<_SearchInfoDto> get copyWith => __$SearchInfoDtoCopyWithImpl<_SearchInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchInfoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchInfoDto&&(identical(other.q, q) || other.q == q)&&(identical(other.normalizedQ, normalizedQ) || other.normalizedQ == normalizedQ)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.degraded, degraded) || other.degraded == degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,q,normalizedQ,engine,degraded);
}

@override
String toString() {
    return 'SearchInfoDto(q: $q, normalizedQ: $normalizedQ, engine: $engine, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class _$SearchInfoDtoCopyWith<$Res> implements $SearchInfoDtoCopyWith<$Res> {
  factory _$SearchInfoDtoCopyWith(_SearchInfoDto value, $Res Function(_SearchInfoDto) _then) = __$SearchInfoDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? q,@JsonKey(fromJson: stringOrNull) String? normalizedQ,@JsonKey(fromJson: stringOrNull) String? engine,@JsonKey(fromJson: boolOrNull) bool? degraded
});




}
/// @nodoc
class __$SearchInfoDtoCopyWithImpl<$Res>
    implements _$SearchInfoDtoCopyWith<$Res> {
  __$SearchInfoDtoCopyWithImpl(this._self, this._then);

  final _SearchInfoDto _self;
  final $Res Function(_SearchInfoDto) _then;

/// Create a copy of SearchInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? q = freezed,Object? normalizedQ = freezed,Object? engine = freezed,Object? degraded = freezed,}) {
  return _then(_SearchInfoDto(
q: freezed == q ? _self.q : q // ignore: cast_nullable_to_non_nullable
as String?,normalizedQ: freezed == normalizedQ ? _self.normalizedQ : normalizedQ // ignore: cast_nullable_to_non_nullable
as String?,engine: freezed == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String?,degraded: freezed == degraded ? _self.degraded : degraded // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$SearchResponseDto {

@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson) SearchInfoDto? get search;@JsonKey(fromJson: facetsFromJson, toJson: facetsToJson) FacetsDto? get facets;@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get data;@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) PageMetaDto? get meta;
/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResponseDtoCopyWith<SearchResponseDto> get copyWith => _$SearchResponseDtoCopyWithImpl<SearchResponseDto>(this as SearchResponseDto, _$identity);

  /// Serializes this SearchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SearchResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResponseDto&&(identical(other.search, _this.search) || other.search == _this.search)&&(identical(other.facets, _this.facets) || other.facets == _this.facets)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchResponseDto;
  return Object.hash(runtimeType,_this.search,_this.facets,const DeepCollectionEquality().hash(_this.data),_this.meta);
}

@override
String toString() {
  final _this = this as SearchResponseDto;
  return 'SearchResponseDto(search: ${_this.search}, facets: ${_this.facets}, data: ${_this.data}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $SearchResponseDtoCopyWith<$Res>  {
  factory $SearchResponseDtoCopyWith(SearchResponseDto value, $Res Function(SearchResponseDto) _then) = _$SearchResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson) SearchInfoDto? search,@JsonKey(fromJson: facetsFromJson, toJson: facetsToJson) FacetsDto? facets,@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? data,@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) PageMetaDto? meta
});


$SearchInfoDtoCopyWith<$Res>? get search;$FacetsDtoCopyWith<$Res>? get facets;$PageMetaDtoCopyWith<$Res>? get meta;

}
/// @nodoc
class _$SearchResponseDtoCopyWithImpl<$Res>
    implements $SearchResponseDtoCopyWith<$Res> {
  _$SearchResponseDtoCopyWithImpl(this._self, this._then);

  final SearchResponseDto _self;
  final $Res Function(SearchResponseDto) _then;

/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = freezed,Object? facets = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(SearchResponseDto(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as SearchInfoDto?,facets: freezed == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as FacetsDto?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PageMetaDto?,
  ));
}
/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchInfoDtoCopyWith<$Res>? get search {
    if (_self.search == null) {
    return null;
  }

  return $SearchInfoDtoCopyWith<$Res>(_self.search!, (value) {
    return _then(_self.copyWith(search: value));
  });
}/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FacetsDtoCopyWith<$Res>? get facets {
    if (_self.facets == null) {
    return null;
  }

  return $FacetsDtoCopyWith<$Res>(_self.facets!, (value) {
    return _then(_self.copyWith(facets: value));
  });
}/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $PageMetaDtoCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchResponseDto].
extension SearchResponseDtoPatterns on SearchResponseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchResponseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson)  SearchInfoDto? search, @JsonKey(fromJson: facetsFromJson, toJson: facetsToJson)  FacetsDto? facets, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)  PageMetaDto? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
return $default(_that.search,_that.facets,_that.data,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson)  SearchInfoDto? search, @JsonKey(fromJson: facetsFromJson, toJson: facetsToJson)  FacetsDto? facets, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)  PageMetaDto? meta)  $default,) {final _that = this;
switch (_that) {
case _SearchResponseDto():
return $default(_that.search,_that.facets,_that.data,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson)  SearchInfoDto? search, @JsonKey(fromJson: facetsFromJson, toJson: facetsToJson)  FacetsDto? facets, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson)  PageMetaDto? meta)?  $default,) {final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
return $default(_that.search,_that.facets,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResponseDto implements SearchResponseDto {
  const _SearchResponseDto({@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson) this.search, @JsonKey(fromJson: facetsFromJson, toJson: facetsToJson) this.facets, @JsonKey(fromJson: cardsFromJson, toJson: cardsToJson)  List<ProductCardDto>? data, @JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) this.meta}): _data = data;
  factory _SearchResponseDto.fromJson(Map<String, dynamic> json) => _$SearchResponseDtoFromJson(json);

@override@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson) final  SearchInfoDto? search;
@override@JsonKey(fromJson: facetsFromJson, toJson: facetsToJson) final  FacetsDto? facets;
 final  List<ProductCardDto>? _data;
@override@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) final  PageMetaDto? meta;

/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResponseDtoCopyWith<_SearchResponseDto> get copyWith => __$SearchResponseDtoCopyWithImpl<_SearchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResponseDto&&(identical(other.search, search) || other.search == search)&&(identical(other.facets, facets) || other.facets == facets)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,search,facets,const DeepCollectionEquality().hash(_data),meta);
}

@override
String toString() {
    return 'SearchResponseDto(search: $search, facets: $facets, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$SearchResponseDtoCopyWith<$Res> implements $SearchResponseDtoCopyWith<$Res> {
  factory _$SearchResponseDtoCopyWith(_SearchResponseDto value, $Res Function(_SearchResponseDto) _then) = __$SearchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: searchInfoFromJson, toJson: searchInfoToJson) SearchInfoDto? search,@JsonKey(fromJson: facetsFromJson, toJson: facetsToJson) FacetsDto? facets,@JsonKey(fromJson: cardsFromJson, toJson: cardsToJson) List<ProductCardDto>? data,@JsonKey(fromJson: pageMetaFromJson, toJson: pageMetaToJson) PageMetaDto? meta
});


@override $SearchInfoDtoCopyWith<$Res>? get search;@override $FacetsDtoCopyWith<$Res>? get facets;@override $PageMetaDtoCopyWith<$Res>? get meta;

}
/// @nodoc
class __$SearchResponseDtoCopyWithImpl<$Res>
    implements _$SearchResponseDtoCopyWith<$Res> {
  __$SearchResponseDtoCopyWithImpl(this._self, this._then);

  final _SearchResponseDto _self;
  final $Res Function(_SearchResponseDto) _then;

/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = freezed,Object? facets = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(_SearchResponseDto(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as SearchInfoDto?,facets: freezed == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as FacetsDto?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PageMetaDto?,
  ));
}

/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchInfoDtoCopyWith<$Res>? get search {
    if (_self.search == null) {
    return null;
  }

  return $SearchInfoDtoCopyWith<$Res>(_self.search!, (value) {
    return _then(_self.copyWith(search: value));
  });
}/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FacetsDtoCopyWith<$Res>? get facets {
    if (_self.facets == null) {
    return null;
  }

  return $FacetsDtoCopyWith<$Res>(_self.facets!, (value) {
    return _then(_self.copyWith(facets: value));
  });
}/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $PageMetaDtoCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$StoreDto {

@JsonKey(fromJson: intOrNull) int? get id;@JsonKey(fromJson: stringOrNull) String? get name;@JsonKey(fromJson: stringOrNull) String? get slug;@JsonKey(fromJson: stringOrNull) String? get description;@JsonKey(fromJson: stringOrNull) String? get areaLabel;@JsonKey(fromJson: intOrNull) int? get followersCount;@JsonKey(fromJson: boolOrNull) bool? get isFollowed;@JsonKey(fromJson: doubleOrNull) double? get averageRating;@JsonKey(fromJson: intOrNull) int? get reviewsCount;@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? get share;@JsonKey(fromJson: productPageFromJson, toJson: productPageToJson) ProductPageDto? get products;
/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDtoCopyWith<StoreDto> get copyWith => _$StoreDtoCopyWithImpl<StoreDto>(this as StoreDto, _$identity);

  /// Serializes this StoreDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoreDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.areaLabel, _this.areaLabel) || other.areaLabel == _this.areaLabel)&&(identical(other.followersCount, _this.followersCount) || other.followersCount == _this.followersCount)&&(identical(other.isFollowed, _this.isFollowed) || other.isFollowed == _this.isFollowed)&&(identical(other.averageRating, _this.averageRating) || other.averageRating == _this.averageRating)&&(identical(other.reviewsCount, _this.reviewsCount) || other.reviewsCount == _this.reviewsCount)&&(identical(other.share, _this.share) || other.share == _this.share)&&(identical(other.products, _this.products) || other.products == _this.products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoreDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.slug,_this.description,_this.areaLabel,_this.followersCount,_this.isFollowed,_this.averageRating,_this.reviewsCount,_this.share,_this.products);
}

@override
String toString() {
  final _this = this as StoreDto;
  return 'StoreDto(id: ${_this.id}, name: ${_this.name}, slug: ${_this.slug}, description: ${_this.description}, areaLabel: ${_this.areaLabel}, followersCount: ${_this.followersCount}, isFollowed: ${_this.isFollowed}, averageRating: ${_this.averageRating}, reviewsCount: ${_this.reviewsCount}, share: ${_this.share}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $StoreDtoCopyWith<$Res>  {
  factory $StoreDtoCopyWith(StoreDto value, $Res Function(StoreDto) _then) = _$StoreDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: stringOrNull) String? description,@JsonKey(fromJson: stringOrNull) String? areaLabel,@JsonKey(fromJson: intOrNull) int? followersCount,@JsonKey(fromJson: boolOrNull) bool? isFollowed,@JsonKey(fromJson: doubleOrNull) double? averageRating,@JsonKey(fromJson: intOrNull) int? reviewsCount,@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,@JsonKey(fromJson: productPageFromJson, toJson: productPageToJson) ProductPageDto? products
});


$ShareDtoCopyWith<$Res>? get share;$ProductPageDtoCopyWith<$Res>? get products;

}
/// @nodoc
class _$StoreDtoCopyWithImpl<$Res>
    implements $StoreDtoCopyWith<$Res> {
  _$StoreDtoCopyWithImpl(this._self, this._then);

  final StoreDto _self;
  final $Res Function(StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,Object? description = freezed,Object? areaLabel = freezed,Object? followersCount = freezed,Object? isFollowed = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? share = freezed,Object? products = freezed,}) {
  return _then(StoreDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,areaLabel: freezed == areaLabel ? _self.areaLabel : areaLabel // ignore: cast_nullable_to_non_nullable
as String?,followersCount: freezed == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int?,isFollowed: freezed == isFollowed ? _self.isFollowed : isFollowed // ignore: cast_nullable_to_non_nullable
as bool?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareDto?,products: freezed == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as ProductPageDto?,
  ));
}
/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareDtoCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPageDtoCopyWith<$Res>? get products {
    if (_self.products == null) {
    return null;
  }

  return $ProductPageDtoCopyWith<$Res>(_self.products!, (value) {
    return _then(_self.copyWith(products: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoreDto].
extension StoreDtoPatterns on StoreDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? description, @JsonKey(fromJson: stringOrNull)  String? areaLabel, @JsonKey(fromJson: intOrNull)  int? followersCount, @JsonKey(fromJson: boolOrNull)  bool? isFollowed, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: productPageFromJson, toJson: productPageToJson)  ProductPageDto? products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.areaLabel,_that.followersCount,_that.isFollowed,_that.averageRating,_that.reviewsCount,_that.share,_that.products);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? description, @JsonKey(fromJson: stringOrNull)  String? areaLabel, @JsonKey(fromJson: intOrNull)  int? followersCount, @JsonKey(fromJson: boolOrNull)  bool? isFollowed, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: productPageFromJson, toJson: productPageToJson)  ProductPageDto? products)  $default,) {final _that = this;
switch (_that) {
case _StoreDto():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.areaLabel,_that.followersCount,_that.isFollowed,_that.averageRating,_that.reviewsCount,_that.share,_that.products);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: intOrNull)  int? id, @JsonKey(fromJson: stringOrNull)  String? name, @JsonKey(fromJson: stringOrNull)  String? slug, @JsonKey(fromJson: stringOrNull)  String? description, @JsonKey(fromJson: stringOrNull)  String? areaLabel, @JsonKey(fromJson: intOrNull)  int? followersCount, @JsonKey(fromJson: boolOrNull)  bool? isFollowed, @JsonKey(fromJson: doubleOrNull)  double? averageRating, @JsonKey(fromJson: intOrNull)  int? reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson)  ShareDto? share, @JsonKey(fromJson: productPageFromJson, toJson: productPageToJson)  ProductPageDto? products)?  $default,) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.areaLabel,_that.followersCount,_that.isFollowed,_that.averageRating,_that.reviewsCount,_that.share,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreDto implements StoreDto {
  const _StoreDto({@JsonKey(fromJson: intOrNull) this.id, @JsonKey(fromJson: stringOrNull) this.name, @JsonKey(fromJson: stringOrNull) this.slug, @JsonKey(fromJson: stringOrNull) this.description, @JsonKey(fromJson: stringOrNull) this.areaLabel, @JsonKey(fromJson: intOrNull) this.followersCount, @JsonKey(fromJson: boolOrNull) this.isFollowed, @JsonKey(fromJson: doubleOrNull) this.averageRating, @JsonKey(fromJson: intOrNull) this.reviewsCount, @JsonKey(fromJson: shareFromJson, toJson: shareToJson) this.share, @JsonKey(fromJson: productPageFromJson, toJson: productPageToJson) this.products});
  factory _StoreDto.fromJson(Map<String, dynamic> json) => _$StoreDtoFromJson(json);

@override@JsonKey(fromJson: intOrNull) final  int? id;
@override@JsonKey(fromJson: stringOrNull) final  String? name;
@override@JsonKey(fromJson: stringOrNull) final  String? slug;
@override@JsonKey(fromJson: stringOrNull) final  String? description;
@override@JsonKey(fromJson: stringOrNull) final  String? areaLabel;
@override@JsonKey(fromJson: intOrNull) final  int? followersCount;
@override@JsonKey(fromJson: boolOrNull) final  bool? isFollowed;
@override@JsonKey(fromJson: doubleOrNull) final  double? averageRating;
@override@JsonKey(fromJson: intOrNull) final  int? reviewsCount;
@override@JsonKey(fromJson: shareFromJson, toJson: shareToJson) final  ShareDto? share;
@override@JsonKey(fromJson: productPageFromJson, toJson: productPageToJson) final  ProductPageDto? products;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDtoCopyWith<_StoreDto> get copyWith => __$StoreDtoCopyWithImpl<_StoreDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.areaLabel, areaLabel) || other.areaLabel == areaLabel)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.isFollowed, isFollowed) || other.isFollowed == isFollowed)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.share, share) || other.share == share)&&(identical(other.products, products) || other.products == products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,slug,description,areaLabel,followersCount,isFollowed,averageRating,reviewsCount,share,products);
}

@override
String toString() {
    return 'StoreDto(id: $id, name: $name, slug: $slug, description: $description, areaLabel: $areaLabel, followersCount: $followersCount, isFollowed: $isFollowed, averageRating: $averageRating, reviewsCount: $reviewsCount, share: $share, products: $products)';
}


}

/// @nodoc
abstract mixin class _$StoreDtoCopyWith<$Res> implements $StoreDtoCopyWith<$Res> {
  factory _$StoreDtoCopyWith(_StoreDto value, $Res Function(_StoreDto) _then) = __$StoreDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: intOrNull) int? id,@JsonKey(fromJson: stringOrNull) String? name,@JsonKey(fromJson: stringOrNull) String? slug,@JsonKey(fromJson: stringOrNull) String? description,@JsonKey(fromJson: stringOrNull) String? areaLabel,@JsonKey(fromJson: intOrNull) int? followersCount,@JsonKey(fromJson: boolOrNull) bool? isFollowed,@JsonKey(fromJson: doubleOrNull) double? averageRating,@JsonKey(fromJson: intOrNull) int? reviewsCount,@JsonKey(fromJson: shareFromJson, toJson: shareToJson) ShareDto? share,@JsonKey(fromJson: productPageFromJson, toJson: productPageToJson) ProductPageDto? products
});


@override $ShareDtoCopyWith<$Res>? get share;@override $ProductPageDtoCopyWith<$Res>? get products;

}
/// @nodoc
class __$StoreDtoCopyWithImpl<$Res>
    implements _$StoreDtoCopyWith<$Res> {
  __$StoreDtoCopyWithImpl(this._self, this._then);

  final _StoreDto _self;
  final $Res Function(_StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? slug = freezed,Object? description = freezed,Object? areaLabel = freezed,Object? followersCount = freezed,Object? isFollowed = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? share = freezed,Object? products = freezed,}) {
  return _then(_StoreDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,areaLabel: freezed == areaLabel ? _self.areaLabel : areaLabel // ignore: cast_nullable_to_non_nullable
as String?,followersCount: freezed == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int?,isFollowed: freezed == isFollowed ? _self.isFollowed : isFollowed // ignore: cast_nullable_to_non_nullable
as bool?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareDto?,products: freezed == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as ProductPageDto?,
  ));
}

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareDtoCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareDtoCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPageDtoCopyWith<$Res>? get products {
    if (_self.products == null) {
    return null;
  }

  return $ProductPageDtoCopyWith<$Res>(_self.products!, (value) {
    return _then(_self.copyWith(products: value));
  });
}
}


/// @nodoc
mixin _$PlatformDto {

@JsonKey(fromJson: stringOrNull) String? get version;
/// Create a copy of PlatformDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformDtoCopyWith<PlatformDto> get copyWith => _$PlatformDtoCopyWithImpl<PlatformDto>(this as PlatformDto, _$identity);

  /// Serializes this PlatformDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlatformDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformDto&&(identical(other.version, _this.version) || other.version == _this.version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlatformDto;
  return Object.hash(runtimeType,_this.version);
}

@override
String toString() {
  final _this = this as PlatformDto;
  return 'PlatformDto(version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $PlatformDtoCopyWith<$Res>  {
  factory $PlatformDtoCopyWith(PlatformDto value, $Res Function(PlatformDto) _then) = _$PlatformDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? version
});




}
/// @nodoc
class _$PlatformDtoCopyWithImpl<$Res>
    implements $PlatformDtoCopyWith<$Res> {
  _$PlatformDtoCopyWithImpl(this._self, this._then);

  final PlatformDto _self;
  final $Res Function(PlatformDto) _then;

/// Create a copy of PlatformDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,}) {
  return _then(PlatformDto(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformDto].
extension PlatformDtoPatterns on PlatformDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformDto value)  $default,){
final _that = this;
switch (_that) {
case _PlatformDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformDto value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformDto() when $default != null:
return $default(_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? version)  $default,) {final _that = this;
switch (_that) {
case _PlatformDto():
return $default(_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? version)?  $default,) {final _that = this;
switch (_that) {
case _PlatformDto() when $default != null:
return $default(_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformDto implements PlatformDto {
  const _PlatformDto({@JsonKey(fromJson: stringOrNull) this.version});
  factory _PlatformDto.fromJson(Map<String, dynamic> json) => _$PlatformDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? version;

/// Create a copy of PlatformDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformDtoCopyWith<_PlatformDto> get copyWith => __$PlatformDtoCopyWithImpl<_PlatformDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformDto&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version);
}

@override
String toString() {
    return 'PlatformDto(version: $version)';
}


}

/// @nodoc
abstract mixin class _$PlatformDtoCopyWith<$Res> implements $PlatformDtoCopyWith<$Res> {
  factory _$PlatformDtoCopyWith(_PlatformDto value, $Res Function(_PlatformDto) _then) = __$PlatformDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? version
});




}
/// @nodoc
class __$PlatformDtoCopyWithImpl<$Res>
    implements _$PlatformDtoCopyWith<$Res> {
  __$PlatformDtoCopyWithImpl(this._self, this._then);

  final _PlatformDto _self;
  final $Res Function(_PlatformDto) _then;

/// Create a copy of PlatformDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,}) {
  return _then(_PlatformDto(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HealthDto {

@JsonKey(fromJson: stringOrNull) String? get status;@JsonKey(fromJson: stringOrNull) String? get requestId;@JsonKey(fromJson: platformFromJson, toJson: platformToJson) PlatformDto? get platform;@JsonKey(fromJson: stringMapOrEmpty) Map<String, String>? get checks;
/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDtoCopyWith<HealthDto> get copyWith => _$HealthDtoCopyWithImpl<HealthDto>(this as HealthDto, _$identity);

  /// Serializes this HealthDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthDto&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&const DeepCollectionEquality().equals(other.checks, _this.checks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthDto;
  return Object.hash(runtimeType,_this.status,_this.requestId,_this.platform,const DeepCollectionEquality().hash(_this.checks));
}

@override
String toString() {
  final _this = this as HealthDto;
  return 'HealthDto(status: ${_this.status}, requestId: ${_this.requestId}, platform: ${_this.platform}, checks: ${_this.checks})';
}


}

/// @nodoc
abstract mixin class $HealthDtoCopyWith<$Res>  {
  factory $HealthDtoCopyWith(HealthDto value, $Res Function(HealthDto) _then) = _$HealthDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? status,@JsonKey(fromJson: stringOrNull) String? requestId,@JsonKey(fromJson: platformFromJson, toJson: platformToJson) PlatformDto? platform,@JsonKey(fromJson: stringMapOrEmpty) Map<String, String>? checks
});


$PlatformDtoCopyWith<$Res>? get platform;

}
/// @nodoc
class _$HealthDtoCopyWithImpl<$Res>
    implements $HealthDtoCopyWith<$Res> {
  _$HealthDtoCopyWithImpl(this._self, this._then);

  final HealthDto _self;
  final $Res Function(HealthDto) _then;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? requestId = freezed,Object? platform = freezed,Object? checks = freezed,}) {
  return _then(HealthDto(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PlatformDto?,checks: freezed == checks ? _self.checks : checks // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}
/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlatformDtoCopyWith<$Res>? get platform {
    if (_self.platform == null) {
    return null;
  }

  return $PlatformDtoCopyWith<$Res>(_self.platform!, (value) {
    return _then(_self.copyWith(platform: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthDto].
extension HealthDtoPatterns on HealthDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthDto value)  $default,){
final _that = this;
switch (_that) {
case _HealthDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthDto value)?  $default,){
final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? status, @JsonKey(fromJson: stringOrNull)  String? requestId, @JsonKey(fromJson: platformFromJson, toJson: platformToJson)  PlatformDto? platform, @JsonKey(fromJson: stringMapOrEmpty)  Map<String, String>? checks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that.status,_that.requestId,_that.platform,_that.checks);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? status, @JsonKey(fromJson: stringOrNull)  String? requestId, @JsonKey(fromJson: platformFromJson, toJson: platformToJson)  PlatformDto? platform, @JsonKey(fromJson: stringMapOrEmpty)  Map<String, String>? checks)  $default,) {final _that = this;
switch (_that) {
case _HealthDto():
return $default(_that.status,_that.requestId,_that.platform,_that.checks);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? status, @JsonKey(fromJson: stringOrNull)  String? requestId, @JsonKey(fromJson: platformFromJson, toJson: platformToJson)  PlatformDto? platform, @JsonKey(fromJson: stringMapOrEmpty)  Map<String, String>? checks)?  $default,) {final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that.status,_that.requestId,_that.platform,_that.checks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthDto implements HealthDto {
  const _HealthDto({@JsonKey(fromJson: stringOrNull) this.status, @JsonKey(fromJson: stringOrNull) this.requestId, @JsonKey(fromJson: platformFromJson, toJson: platformToJson) this.platform, @JsonKey(fromJson: stringMapOrEmpty)  Map<String, String>? checks}): _checks = checks;
  factory _HealthDto.fromJson(Map<String, dynamic> json) => _$HealthDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? status;
@override@JsonKey(fromJson: stringOrNull) final  String? requestId;
@override@JsonKey(fromJson: platformFromJson, toJson: platformToJson) final  PlatformDto? platform;
 final  Map<String, String>? _checks;
@override@JsonKey(fromJson: stringMapOrEmpty) Map<String, String>? get checks {
  final value = _checks;
  if (value == null) return null;
  if (_checks is EqualUnmodifiableMapView) return _checks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthDtoCopyWith<_HealthDto> get copyWith => __$HealthDtoCopyWithImpl<_HealthDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthDto&&(identical(other.status, status) || other.status == status)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.platform, platform) || other.platform == platform)&&const DeepCollectionEquality().equals(other.checks, _checks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,requestId,platform,const DeepCollectionEquality().hash(_checks));
}

@override
String toString() {
    return 'HealthDto(status: $status, requestId: $requestId, platform: $platform, checks: $checks)';
}


}

/// @nodoc
abstract mixin class _$HealthDtoCopyWith<$Res> implements $HealthDtoCopyWith<$Res> {
  factory _$HealthDtoCopyWith(_HealthDto value, $Res Function(_HealthDto) _then) = __$HealthDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? status,@JsonKey(fromJson: stringOrNull) String? requestId,@JsonKey(fromJson: platformFromJson, toJson: platformToJson) PlatformDto? platform,@JsonKey(fromJson: stringMapOrEmpty) Map<String, String>? checks
});


@override $PlatformDtoCopyWith<$Res>? get platform;

}
/// @nodoc
class __$HealthDtoCopyWithImpl<$Res>
    implements _$HealthDtoCopyWith<$Res> {
  __$HealthDtoCopyWithImpl(this._self, this._then);

  final _HealthDto _self;
  final $Res Function(_HealthDto) _then;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? requestId = freezed,Object? platform = freezed,Object? checks = freezed,}) {
  return _then(_HealthDto(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PlatformDto?,checks: freezed == checks ? _self._checks : checks // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlatformDtoCopyWith<$Res>? get platform {
    if (_self.platform == null) {
    return null;
  }

  return $PlatformDtoCopyWith<$Res>(_self.platform!, (value) {
    return _then(_self.copyWith(platform: value));
  });
}
}


/// @nodoc
mixin _$MaintenanceMessageDto {

@JsonKey(fromJson: stringOrNull) String? get ar;@JsonKey(fromJson: stringOrNull) String? get en;
/// Create a copy of MaintenanceMessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceMessageDtoCopyWith<MaintenanceMessageDto> get copyWith => _$MaintenanceMessageDtoCopyWithImpl<MaintenanceMessageDto>(this as MaintenanceMessageDto, _$identity);

  /// Serializes this MaintenanceMessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaintenanceMessageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceMessageDto&&(identical(other.ar, _this.ar) || other.ar == _this.ar)&&(identical(other.en, _this.en) || other.en == _this.en));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaintenanceMessageDto;
  return Object.hash(runtimeType,_this.ar,_this.en);
}

@override
String toString() {
  final _this = this as MaintenanceMessageDto;
  return 'MaintenanceMessageDto(ar: ${_this.ar}, en: ${_this.en})';
}


}

/// @nodoc
abstract mixin class $MaintenanceMessageDtoCopyWith<$Res>  {
  factory $MaintenanceMessageDtoCopyWith(MaintenanceMessageDto value, $Res Function(MaintenanceMessageDto) _then) = _$MaintenanceMessageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? ar,@JsonKey(fromJson: stringOrNull) String? en
});




}
/// @nodoc
class _$MaintenanceMessageDtoCopyWithImpl<$Res>
    implements $MaintenanceMessageDtoCopyWith<$Res> {
  _$MaintenanceMessageDtoCopyWithImpl(this._self, this._then);

  final MaintenanceMessageDto _self;
  final $Res Function(MaintenanceMessageDto) _then;

/// Create a copy of MaintenanceMessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ar = freezed,Object? en = freezed,}) {
  return _then(MaintenanceMessageDto(
ar: freezed == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as String?,en: freezed == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceMessageDto].
extension MaintenanceMessageDtoPatterns on MaintenanceMessageDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceMessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceMessageDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceMessageDto value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceMessageDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceMessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceMessageDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? ar, @JsonKey(fromJson: stringOrNull)  String? en)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceMessageDto() when $default != null:
return $default(_that.ar,_that.en);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? ar, @JsonKey(fromJson: stringOrNull)  String? en)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceMessageDto():
return $default(_that.ar,_that.en);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? ar, @JsonKey(fromJson: stringOrNull)  String? en)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceMessageDto() when $default != null:
return $default(_that.ar,_that.en);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenanceMessageDto implements MaintenanceMessageDto {
  const _MaintenanceMessageDto({@JsonKey(fromJson: stringOrNull) this.ar, @JsonKey(fromJson: stringOrNull) this.en});
  factory _MaintenanceMessageDto.fromJson(Map<String, dynamic> json) => _$MaintenanceMessageDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? ar;
@override@JsonKey(fromJson: stringOrNull) final  String? en;

/// Create a copy of MaintenanceMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceMessageDtoCopyWith<_MaintenanceMessageDto> get copyWith => __$MaintenanceMessageDtoCopyWithImpl<_MaintenanceMessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceMessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceMessageDto&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.en, en) || other.en == en));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ar,en);
}

@override
String toString() {
    return 'MaintenanceMessageDto(ar: $ar, en: $en)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceMessageDtoCopyWith<$Res> implements $MaintenanceMessageDtoCopyWith<$Res> {
  factory _$MaintenanceMessageDtoCopyWith(_MaintenanceMessageDto value, $Res Function(_MaintenanceMessageDto) _then) = __$MaintenanceMessageDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? ar,@JsonKey(fromJson: stringOrNull) String? en
});




}
/// @nodoc
class __$MaintenanceMessageDtoCopyWithImpl<$Res>
    implements _$MaintenanceMessageDtoCopyWith<$Res> {
  __$MaintenanceMessageDtoCopyWithImpl(this._self, this._then);

  final _MaintenanceMessageDto _self;
  final $Res Function(_MaintenanceMessageDto) _then;

/// Create a copy of MaintenanceMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ar = freezed,Object? en = freezed,}) {
  return _then(_MaintenanceMessageDto(
ar: freezed == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as String?,en: freezed == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MaintenanceWindowDto {

@JsonKey(fromJson: stringOrNull) String? get startsAt;@JsonKey(fromJson: stringOrNull) String? get endsAt;
/// Create a copy of MaintenanceWindowDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceWindowDtoCopyWith<MaintenanceWindowDto> get copyWith => _$MaintenanceWindowDtoCopyWithImpl<MaintenanceWindowDto>(this as MaintenanceWindowDto, _$identity);

  /// Serializes this MaintenanceWindowDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaintenanceWindowDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceWindowDto&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaintenanceWindowDto;
  return Object.hash(runtimeType,_this.startsAt,_this.endsAt);
}

@override
String toString() {
  final _this = this as MaintenanceWindowDto;
  return 'MaintenanceWindowDto(startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt})';
}


}

/// @nodoc
abstract mixin class $MaintenanceWindowDtoCopyWith<$Res>  {
  factory $MaintenanceWindowDtoCopyWith(MaintenanceWindowDto value, $Res Function(MaintenanceWindowDto) _then) = _$MaintenanceWindowDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? startsAt,@JsonKey(fromJson: stringOrNull) String? endsAt
});




}
/// @nodoc
class _$MaintenanceWindowDtoCopyWithImpl<$Res>
    implements $MaintenanceWindowDtoCopyWith<$Res> {
  _$MaintenanceWindowDtoCopyWithImpl(this._self, this._then);

  final MaintenanceWindowDto _self;
  final $Res Function(MaintenanceWindowDto) _then;

/// Create a copy of MaintenanceWindowDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(MaintenanceWindowDto(
startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceWindowDto].
extension MaintenanceWindowDtoPatterns on MaintenanceWindowDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceWindowDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceWindowDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceWindowDto value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceWindowDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceWindowDto value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceWindowDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? startsAt, @JsonKey(fromJson: stringOrNull)  String? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceWindowDto() when $default != null:
return $default(_that.startsAt,_that.endsAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? startsAt, @JsonKey(fromJson: stringOrNull)  String? endsAt)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceWindowDto():
return $default(_that.startsAt,_that.endsAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? startsAt, @JsonKey(fromJson: stringOrNull)  String? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceWindowDto() when $default != null:
return $default(_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenanceWindowDto implements MaintenanceWindowDto {
  const _MaintenanceWindowDto({@JsonKey(fromJson: stringOrNull) this.startsAt, @JsonKey(fromJson: stringOrNull) this.endsAt});
  factory _MaintenanceWindowDto.fromJson(Map<String, dynamic> json) => _$MaintenanceWindowDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? startsAt;
@override@JsonKey(fromJson: stringOrNull) final  String? endsAt;

/// Create a copy of MaintenanceWindowDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceWindowDtoCopyWith<_MaintenanceWindowDto> get copyWith => __$MaintenanceWindowDtoCopyWithImpl<_MaintenanceWindowDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceWindowDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceWindowDto&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startsAt,endsAt);
}

@override
String toString() {
    return 'MaintenanceWindowDto(startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceWindowDtoCopyWith<$Res> implements $MaintenanceWindowDtoCopyWith<$Res> {
  factory _$MaintenanceWindowDtoCopyWith(_MaintenanceWindowDto value, $Res Function(_MaintenanceWindowDto) _then) = __$MaintenanceWindowDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? startsAt,@JsonKey(fromJson: stringOrNull) String? endsAt
});




}
/// @nodoc
class __$MaintenanceWindowDtoCopyWithImpl<$Res>
    implements _$MaintenanceWindowDtoCopyWith<$Res> {
  __$MaintenanceWindowDtoCopyWithImpl(this._self, this._then);

  final _MaintenanceWindowDto _self;
  final $Res Function(_MaintenanceWindowDto) _then;

/// Create a copy of MaintenanceWindowDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_MaintenanceWindowDto(
startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MaintenanceDto {

@JsonKey(fromJson: boolOrNull) bool? get forced;@JsonKey(fromJson: boolOrNull) bool? get scheduled;@JsonKey(fromJson: windowFromJson, toJson: windowToJson) MaintenanceWindowDto? get window;@JsonKey(fromJson: messageFromJson, toJson: messageToJson) MaintenanceMessageDto? get message;
/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceDtoCopyWith<MaintenanceDto> get copyWith => _$MaintenanceDtoCopyWithImpl<MaintenanceDto>(this as MaintenanceDto, _$identity);

  /// Serializes this MaintenanceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaintenanceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceDto&&(identical(other.forced, _this.forced) || other.forced == _this.forced)&&(identical(other.scheduled, _this.scheduled) || other.scheduled == _this.scheduled)&&(identical(other.window, _this.window) || other.window == _this.window)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaintenanceDto;
  return Object.hash(runtimeType,_this.forced,_this.scheduled,_this.window,_this.message);
}

@override
String toString() {
  final _this = this as MaintenanceDto;
  return 'MaintenanceDto(forced: ${_this.forced}, scheduled: ${_this.scheduled}, window: ${_this.window}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $MaintenanceDtoCopyWith<$Res>  {
  factory $MaintenanceDtoCopyWith(MaintenanceDto value, $Res Function(MaintenanceDto) _then) = _$MaintenanceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: boolOrNull) bool? forced,@JsonKey(fromJson: boolOrNull) bool? scheduled,@JsonKey(fromJson: windowFromJson, toJson: windowToJson) MaintenanceWindowDto? window,@JsonKey(fromJson: messageFromJson, toJson: messageToJson) MaintenanceMessageDto? message
});


$MaintenanceWindowDtoCopyWith<$Res>? get window;$MaintenanceMessageDtoCopyWith<$Res>? get message;

}
/// @nodoc
class _$MaintenanceDtoCopyWithImpl<$Res>
    implements $MaintenanceDtoCopyWith<$Res> {
  _$MaintenanceDtoCopyWithImpl(this._self, this._then);

  final MaintenanceDto _self;
  final $Res Function(MaintenanceDto) _then;

/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? forced = freezed,Object? scheduled = freezed,Object? window = freezed,Object? message = freezed,}) {
  return _then(MaintenanceDto(
forced: freezed == forced ? _self.forced : forced // ignore: cast_nullable_to_non_nullable
as bool?,scheduled: freezed == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as bool?,window: freezed == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as MaintenanceWindowDto?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as MaintenanceMessageDto?,
  ));
}
/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenanceWindowDtoCopyWith<$Res>? get window {
    if (_self.window == null) {
    return null;
  }

  return $MaintenanceWindowDtoCopyWith<$Res>(_self.window!, (value) {
    return _then(_self.copyWith(window: value));
  });
}/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenanceMessageDtoCopyWith<$Res>? get message {
    if (_self.message == null) {
    return null;
  }

  return $MaintenanceMessageDtoCopyWith<$Res>(_self.message!, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaintenanceDto].
extension MaintenanceDtoPatterns on MaintenanceDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceDto value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceDto value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: boolOrNull)  bool? forced, @JsonKey(fromJson: boolOrNull)  bool? scheduled, @JsonKey(fromJson: windowFromJson, toJson: windowToJson)  MaintenanceWindowDto? window, @JsonKey(fromJson: messageFromJson, toJson: messageToJson)  MaintenanceMessageDto? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceDto() when $default != null:
return $default(_that.forced,_that.scheduled,_that.window,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: boolOrNull)  bool? forced, @JsonKey(fromJson: boolOrNull)  bool? scheduled, @JsonKey(fromJson: windowFromJson, toJson: windowToJson)  MaintenanceWindowDto? window, @JsonKey(fromJson: messageFromJson, toJson: messageToJson)  MaintenanceMessageDto? message)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceDto():
return $default(_that.forced,_that.scheduled,_that.window,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: boolOrNull)  bool? forced, @JsonKey(fromJson: boolOrNull)  bool? scheduled, @JsonKey(fromJson: windowFromJson, toJson: windowToJson)  MaintenanceWindowDto? window, @JsonKey(fromJson: messageFromJson, toJson: messageToJson)  MaintenanceMessageDto? message)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceDto() when $default != null:
return $default(_that.forced,_that.scheduled,_that.window,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenanceDto implements MaintenanceDto {
  const _MaintenanceDto({@JsonKey(fromJson: boolOrNull) this.forced, @JsonKey(fromJson: boolOrNull) this.scheduled, @JsonKey(fromJson: windowFromJson, toJson: windowToJson) this.window, @JsonKey(fromJson: messageFromJson, toJson: messageToJson) this.message});
  factory _MaintenanceDto.fromJson(Map<String, dynamic> json) => _$MaintenanceDtoFromJson(json);

@override@JsonKey(fromJson: boolOrNull) final  bool? forced;
@override@JsonKey(fromJson: boolOrNull) final  bool? scheduled;
@override@JsonKey(fromJson: windowFromJson, toJson: windowToJson) final  MaintenanceWindowDto? window;
@override@JsonKey(fromJson: messageFromJson, toJson: messageToJson) final  MaintenanceMessageDto? message;

/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceDtoCopyWith<_MaintenanceDto> get copyWith => __$MaintenanceDtoCopyWithImpl<_MaintenanceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceDto&&(identical(other.forced, forced) || other.forced == forced)&&(identical(other.scheduled, scheduled) || other.scheduled == scheduled)&&(identical(other.window, window) || other.window == window)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,forced,scheduled,window,message);
}

@override
String toString() {
    return 'MaintenanceDto(forced: $forced, scheduled: $scheduled, window: $window, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceDtoCopyWith<$Res> implements $MaintenanceDtoCopyWith<$Res> {
  factory _$MaintenanceDtoCopyWith(_MaintenanceDto value, $Res Function(_MaintenanceDto) _then) = __$MaintenanceDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: boolOrNull) bool? forced,@JsonKey(fromJson: boolOrNull) bool? scheduled,@JsonKey(fromJson: windowFromJson, toJson: windowToJson) MaintenanceWindowDto? window,@JsonKey(fromJson: messageFromJson, toJson: messageToJson) MaintenanceMessageDto? message
});


@override $MaintenanceWindowDtoCopyWith<$Res>? get window;@override $MaintenanceMessageDtoCopyWith<$Res>? get message;

}
/// @nodoc
class __$MaintenanceDtoCopyWithImpl<$Res>
    implements _$MaintenanceDtoCopyWith<$Res> {
  __$MaintenanceDtoCopyWithImpl(this._self, this._then);

  final _MaintenanceDto _self;
  final $Res Function(_MaintenanceDto) _then;

/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? forced = freezed,Object? scheduled = freezed,Object? window = freezed,Object? message = freezed,}) {
  return _then(_MaintenanceDto(
forced: freezed == forced ? _self.forced : forced // ignore: cast_nullable_to_non_nullable
as bool?,scheduled: freezed == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as bool?,window: freezed == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as MaintenanceWindowDto?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as MaintenanceMessageDto?,
  ));
}

/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenanceWindowDtoCopyWith<$Res>? get window {
    if (_self.window == null) {
    return null;
  }

  return $MaintenanceWindowDtoCopyWith<$Res>(_self.window!, (value) {
    return _then(_self.copyWith(window: value));
  });
}/// Create a copy of MaintenanceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenanceMessageDtoCopyWith<$Res>? get message {
    if (_self.message == null) {
    return null;
  }

  return $MaintenanceMessageDtoCopyWith<$Res>(_self.message!, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// @nodoc
mixin _$MetaStatusDto {

@JsonKey(fromJson: stringOrNull) String? get overall;@JsonKey(fromJson: boolOrNull) bool? get maintenanceActive;@JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson) MaintenanceDto? get maintenance;
/// Create a copy of MetaStatusDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetaStatusDtoCopyWith<MetaStatusDto> get copyWith => _$MetaStatusDtoCopyWithImpl<MetaStatusDto>(this as MetaStatusDto, _$identity);

  /// Serializes this MetaStatusDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MetaStatusDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetaStatusDto&&(identical(other.overall, _this.overall) || other.overall == _this.overall)&&(identical(other.maintenanceActive, _this.maintenanceActive) || other.maintenanceActive == _this.maintenanceActive)&&(identical(other.maintenance, _this.maintenance) || other.maintenance == _this.maintenance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MetaStatusDto;
  return Object.hash(runtimeType,_this.overall,_this.maintenanceActive,_this.maintenance);
}

@override
String toString() {
  final _this = this as MetaStatusDto;
  return 'MetaStatusDto(overall: ${_this.overall}, maintenanceActive: ${_this.maintenanceActive}, maintenance: ${_this.maintenance})';
}


}

/// @nodoc
abstract mixin class $MetaStatusDtoCopyWith<$Res>  {
  factory $MetaStatusDtoCopyWith(MetaStatusDto value, $Res Function(MetaStatusDto) _then) = _$MetaStatusDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? overall,@JsonKey(fromJson: boolOrNull) bool? maintenanceActive,@JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson) MaintenanceDto? maintenance
});


$MaintenanceDtoCopyWith<$Res>? get maintenance;

}
/// @nodoc
class _$MetaStatusDtoCopyWithImpl<$Res>
    implements $MetaStatusDtoCopyWith<$Res> {
  _$MetaStatusDtoCopyWithImpl(this._self, this._then);

  final MetaStatusDto _self;
  final $Res Function(MetaStatusDto) _then;

/// Create a copy of MetaStatusDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? overall = freezed,Object? maintenanceActive = freezed,Object? maintenance = freezed,}) {
  return _then(MetaStatusDto(
overall: freezed == overall ? _self.overall : overall // ignore: cast_nullable_to_non_nullable
as String?,maintenanceActive: freezed == maintenanceActive ? _self.maintenanceActive : maintenanceActive // ignore: cast_nullable_to_non_nullable
as bool?,maintenance: freezed == maintenance ? _self.maintenance : maintenance // ignore: cast_nullable_to_non_nullable
as MaintenanceDto?,
  ));
}
/// Create a copy of MetaStatusDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenanceDtoCopyWith<$Res>? get maintenance {
    if (_self.maintenance == null) {
    return null;
  }

  return $MaintenanceDtoCopyWith<$Res>(_self.maintenance!, (value) {
    return _then(_self.copyWith(maintenance: value));
  });
}
}


/// Adds pattern-matching-related methods to [MetaStatusDto].
extension MetaStatusDtoPatterns on MetaStatusDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetaStatusDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetaStatusDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetaStatusDto value)  $default,){
final _that = this;
switch (_that) {
case _MetaStatusDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetaStatusDto value)?  $default,){
final _that = this;
switch (_that) {
case _MetaStatusDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? overall, @JsonKey(fromJson: boolOrNull)  bool? maintenanceActive, @JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson)  MaintenanceDto? maintenance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetaStatusDto() when $default != null:
return $default(_that.overall,_that.maintenanceActive,_that.maintenance);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrNull)  String? overall, @JsonKey(fromJson: boolOrNull)  bool? maintenanceActive, @JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson)  MaintenanceDto? maintenance)  $default,) {final _that = this;
switch (_that) {
case _MetaStatusDto():
return $default(_that.overall,_that.maintenanceActive,_that.maintenance);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrNull)  String? overall, @JsonKey(fromJson: boolOrNull)  bool? maintenanceActive, @JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson)  MaintenanceDto? maintenance)?  $default,) {final _that = this;
switch (_that) {
case _MetaStatusDto() when $default != null:
return $default(_that.overall,_that.maintenanceActive,_that.maintenance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetaStatusDto implements MetaStatusDto {
  const _MetaStatusDto({@JsonKey(fromJson: stringOrNull) this.overall, @JsonKey(fromJson: boolOrNull) this.maintenanceActive, @JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson) this.maintenance});
  factory _MetaStatusDto.fromJson(Map<String, dynamic> json) => _$MetaStatusDtoFromJson(json);

@override@JsonKey(fromJson: stringOrNull) final  String? overall;
@override@JsonKey(fromJson: boolOrNull) final  bool? maintenanceActive;
@override@JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson) final  MaintenanceDto? maintenance;

/// Create a copy of MetaStatusDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetaStatusDtoCopyWith<_MetaStatusDto> get copyWith => __$MetaStatusDtoCopyWithImpl<_MetaStatusDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetaStatusDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetaStatusDto&&(identical(other.overall, overall) || other.overall == overall)&&(identical(other.maintenanceActive, maintenanceActive) || other.maintenanceActive == maintenanceActive)&&(identical(other.maintenance, maintenance) || other.maintenance == maintenance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,overall,maintenanceActive,maintenance);
}

@override
String toString() {
    return 'MetaStatusDto(overall: $overall, maintenanceActive: $maintenanceActive, maintenance: $maintenance)';
}


}

/// @nodoc
abstract mixin class _$MetaStatusDtoCopyWith<$Res> implements $MetaStatusDtoCopyWith<$Res> {
  factory _$MetaStatusDtoCopyWith(_MetaStatusDto value, $Res Function(_MetaStatusDto) _then) = __$MetaStatusDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrNull) String? overall,@JsonKey(fromJson: boolOrNull) bool? maintenanceActive,@JsonKey(fromJson: maintenanceFromJson, toJson: maintenanceToJson) MaintenanceDto? maintenance
});


@override $MaintenanceDtoCopyWith<$Res>? get maintenance;

}
/// @nodoc
class __$MetaStatusDtoCopyWithImpl<$Res>
    implements _$MetaStatusDtoCopyWith<$Res> {
  __$MetaStatusDtoCopyWithImpl(this._self, this._then);

  final _MetaStatusDto _self;
  final $Res Function(_MetaStatusDto) _then;

/// Create a copy of MetaStatusDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? overall = freezed,Object? maintenanceActive = freezed,Object? maintenance = freezed,}) {
  return _then(_MetaStatusDto(
overall: freezed == overall ? _self.overall : overall // ignore: cast_nullable_to_non_nullable
as String?,maintenanceActive: freezed == maintenanceActive ? _self.maintenanceActive : maintenanceActive // ignore: cast_nullable_to_non_nullable
as bool?,maintenance: freezed == maintenance ? _self.maintenance : maintenance // ignore: cast_nullable_to_non_nullable
as MaintenanceDto?,
  ));
}

/// Create a copy of MetaStatusDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenanceDtoCopyWith<$Res>? get maintenance {
    if (_self.maintenance == null) {
    return null;
  }

  return $MaintenanceDtoCopyWith<$Res>(_self.maintenance!, (value) {
    return _then(_self.copyWith(maintenance: value));
  });
}
}

// dart format on
