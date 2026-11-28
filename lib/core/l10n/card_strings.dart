/// Product card copy (Trendyol-style card, Doory web order). Formal MSA.
abstract final class CardStrings {
  static const verified = 'علامة تجارية موثّقة';

  static const viewersLead = 'شاهده ';
  static String viewersTail(int hours) => ' شخصاً خلال آخر $hours ساعة';
  static String viewers(int count, int hours) =>
      '$viewersLead$count${viewersTail(hours)}';

  static String reviewCount(int count) => '($count)';
  static const photoReviews = 'تقييمات بالصور';

  static const netDiscountPlaceholder = 'خصم صافٍ';
  static String netDiscount(int percent) =>
      '$netDiscountPlaceholder \u2066$percent%\u2069';

  static String discountBadge(int percent) => '\u2066-$percent%\u2069';
  static String instead(String oldPrice, int percent) =>
      'بدلًا من $oldPrice، خصم $percent%';

  /// Placeholder favorites count shown in red until the server sends one.
  static const sampleFavoritesCount = 25;

  /// Listing-card sample (BACKEND: MISSING). Formats as «1.2 ألف».
  static const sampleListingFavoritesCount = 1247;

  /// «25 شخصاً أضافوه إلى المفضلة».
  static String favoritedBy(int count) => '$count شخصاً أضافوه إلى المفضلة';
}
