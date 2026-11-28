import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites/favorites_controller.dart';
import '../../data/models/catalog_models.dart';
import '../account/local_preferences.dart';

/// One browsed product: the card to draw, plus what history needs on top.
///
/// Snapshot v2 adds the category (for the «الفئة» filter), the price at view
/// time (for the price-drop filter), and the view time. The struck price,
/// discount percent, and brand are not on the detail payload: they come from
/// the tapped card when the shopper came from a list, and are left out after a
/// deep link.
// BACKEND: MISSING compare_at_syp / discount_percent / brand on GET /products/{id}
class HistoryEntry {
  const HistoryEntry({
    required this.card,
    this.categoryId,
    this.categoryName,
    this.viewedPriceSyp,
    this.viewedAt,
  });

  final ProductCardModel card;
  final int? categoryId;
  final String? categoryName;

  /// The price when the product page was opened; null for estimates and for
  /// v1 entries. The price-drop filter compares it with the current price.
  final int? viewedPriceSyp;
  final DateTime? viewedAt;

  int get id => card.id;

  factory HistoryEntry.fromDetail(
    ProductDetailModel product, {
    ProductCardModel? tapped,
    DateTime? now,
  }) {
    final from = tapped != null && tapped.id == product.id ? tapped : null;
    return HistoryEntry(
      card: ProductCardModel(
        id: product.id,
        slug: product.slug,
        name: product.name,
        photoUrl: product.photoUrls.isEmpty ? null : product.photoUrls.first,
        storeName: product.storeName,
        storeSlug: product.storeSlug,
        available: product.available,
        priceSyp: product.priceSyp,
        priceIsEstimate: product.priceIsEstimate,
        canPurchase: product.canPurchase,
        averageRating: product.averageRating,
        reviewsCount: product.reviewsCount,
        brandName: from?.brandName,
        brandVerified: from?.brandVerified ?? false,
        compareAtSyp: from?.compareAtSyp,
        discountPercent: from?.discountPercent,
      ),
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      viewedPriceSyp: product.priceIsEstimate ? null : product.priceSyp,
      viewedAt: now ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    ...historyCardToJson(card),
    'category_id': categoryId,
    'category_name': categoryName,
    'viewed_price_syp': viewedPriceSyp,
    'viewed_at': viewedAt?.toIso8601String(),
  };

  /// Null when the stored entry is unusable. v1 entries (no category, price,
  /// or time) load with those fields empty.
  static HistoryEntry? fromJson(Map<String, dynamic> json) {
    final card = historyCardFromJson(json);
    if (card == null) return null;
    final viewedAt = json['viewed_at'];
    return HistoryEntry(
      card: card,
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      viewedPriceSyp: (json['viewed_price_syp'] as num?)?.toInt(),
      viewedAt: viewedAt is String ? DateTime.tryParse(viewedAt) : null,
    );
  }
}

/// Whether product opens are saved. Off stops recording only: what is already
/// saved stays until the shopper deletes it. Kept on the device.
// BACKEND: MISSING server-side on/off for browsing history
class BrowsingHistoryEnabled extends Notifier<bool> {
  static const storageKey = browsingHistoryEnabledKey;

  @override
  bool build() =>
      ref.watch(sharedPreferencesProvider).getBool(storageKey) ?? true;

  Future<void> set(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(storageKey, value);
  }
}

final browsingHistoryEnabledProvider =
    NotifierProvider<BrowsingHistoryEnabled, bool>(BrowsingHistoryEnabled.new);

/// Products the shopper opened, newest first, kept on this device.
///
/// The server cannot back a history page: it only returns the last 8 viewed
/// products inside `GET /home` and `GET /products/{id}/recommendations`, with
/// no paging and no delete. So the list lives here, up to [max] entries, and is
/// saved when a product page opens (unless recording is switched off).
///
/// BACKEND: AVAILABLE POST /products/{id}/view (records a view for a signed-in
/// buyer or an `X-Guest-Key`; not wired, no new backend calls)
/// BACKEND: MISSING full history list, pagination, and delete/clear of views
/// («غير مدعوم»: «حذف الكل» only empties this device)
class BrowsingHistory extends Notifier<List<HistoryEntry>> {
  static const max = 30;

  /// Snapshot v2 (category, price at view time, view time).
  static String get storageKey => 'doory.mock.$browsingHistoryKey.v2';

  /// v1 lists are read once when v2 is absent, then replaced by v2.
  static String get legacyStorageKey => 'doory.mock.$browsingHistoryKey.v1';

  @override
  List<HistoryEntry> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw =
        prefs.getString(storageKey) ?? prefs.getString(legacyStorageKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return [
        for (final item in decoded)
          if (item is Map)
            ?HistoryEntry.fromJson(Map<String, dynamic>.from(item)),
      ].take(max).toList();
    } on FormatException {
      return const [];
    }
  }

  /// Puts [entry] first, drops an older copy, and keeps [max]. Does nothing
  /// while recording is off.
  Future<void> record(HistoryEntry entry) async {
    if (!ref.read(browsingHistoryEnabledProvider)) return;
    final next = [
      entry,
      for (final item in state)
        if (item.id != entry.id) item,
    ].take(max).toList();
    await _save(next);
  }

  Future<void> remove(int id) => _save([
    for (final item in state)
      if (item.id != id) item,
  ]);

  /// Puts a deleted [entry] back at [index] («تراجع»).
  Future<void> restore(HistoryEntry entry, int index) {
    if (state.any((item) => item.id == entry.id)) return Future.value();
    final next = [...state]..insert(index.clamp(0, state.length), entry);
    return _save(next.take(max).toList());
  }

  Future<void> clear() => _save(const []);

  Future<void> _save(List<HistoryEntry> next) async {
    state = next;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      storageKey,
      jsonEncode([for (final entry in next) entry.toJson()]),
    );
    await prefs.remove(legacyStorageKey);
  }
}

final browsingHistoryProvider =
    NotifierProvider<BrowsingHistory, List<HistoryEntry>>(BrowsingHistory.new);

Map<String, dynamic> historyCardToJson(ProductCardModel card) => {
  'id': card.id,
  'slug': card.slug,
  'name': card.name,
  'photo': card.photoUrl,
  'store_name': card.storeName,
  'store_slug': card.storeSlug,
  'available': card.available,
  'price_syp': card.priceSyp,
  'price_is_estimate': card.priceIsEstimate,
  'can_purchase': card.canPurchase,
  'average_rating': card.averageRating,
  'reviews_count': card.reviewsCount,
  'brand_name': card.brandName,
  'brand_verified': card.brandVerified,
  'compare_at_syp': card.compareAtSyp,
  'discount_percent': card.discountPercent,
};

/// Null when the stored entry is unusable, so one bad row never hides the rest.
ProductCardModel? historyCardFromJson(Map<String, dynamic> json) {
  final id = json['id'];
  final name = json['name'];
  if (id is! int || name is! String) return null;
  return ProductCardModel(
    id: id,
    slug: json['slug'] is String ? json['slug'] as String : '',
    name: name,
    photoUrl: json['photo'] as String?,
    storeName: json['store_name'] as String?,
    storeSlug: json['store_slug'] as String?,
    available: json['available'] as bool? ?? true,
    priceSyp: (json['price_syp'] as num?)?.toInt(),
    priceIsEstimate: json['price_is_estimate'] as bool? ?? false,
    canPurchase: json['can_purchase'] as bool? ?? true,
    averageRating: (json['average_rating'] as num?)?.toDouble(),
    reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
    brandName: json['brand_name'] as String?,
    brandVerified: json['brand_verified'] as bool? ?? false,
    compareAtSyp: (json['compare_at_syp'] as num?)?.toInt(),
    discountPercent: (json['discount_percent'] as num?)?.toInt(),
  );
}
