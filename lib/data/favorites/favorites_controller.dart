import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/catalog_models.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('SharedPreferences must be overridden at startup');
});

class FavoritesController extends Notifier<List<ProductCardModel>> {
  static const storageKey = 'doory.favorites.v1';

  @override
  List<ProductCardModel> build() => _read();

  bool contains(int id) => state.any((item) => item.id == id);

  Future<void> toggle(ProductCardModel product) async {
    final exists = contains(product.id);
    final next = [
      if (!exists) product,
      for (final item in state)
        if (item.id != product.id) item,
    ];
    state = next;
    await ref
        .read(sharedPreferencesProvider)
        .setString(
          storageKey,
          jsonEncode([for (final item in next) _encode(item)]),
        );
  }

  List<ProductCardModel> _read() {
    final raw = ref.watch(sharedPreferencesProvider).getString(storageKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final items = <ProductCardModel>[];
      for (final entry in decoded) {
        if (entry is! Map) continue;
        final card = _decode(entry);
        if (card != null) items.add(card);
      }
      return items;
    } catch (_) {
      return const [];
    }
  }

  static Map<String, Object?> _encode(ProductCardModel item) {
    return {
      'id': item.id,
      'slug': item.slug,
      'name': item.name,
      'photo': item.photoUrl,
      'store_name': item.storeName,
      'store_slug': item.storeSlug,
      'available': item.available,
      'price_syp': item.priceSyp,
      'price_is_estimate': item.priceIsEstimate,
      'can_purchase': item.canPurchase,
      'average_rating': item.averageRating,
      'reviews_count': item.reviewsCount,
    };
  }

  static ProductCardModel? _decode(Map<dynamic, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! int || name is! String || name.isEmpty) return null;
    final slug = json['slug'];
    return ProductCardModel(
      id: id,
      slug: slug is String && slug.isNotEmpty ? slug : '$id',
      name: name,
      photoUrl: json['photo'] is String ? json['photo'] as String : null,
      storeName: json['store_name'] is String
          ? json['store_name'] as String
          : null,
      storeSlug: json['store_slug'] is String
          ? json['store_slug'] as String
          : null,
      available: json['available'] is bool ? json['available'] as bool : true,
      priceSyp: json['price_syp'] is int ? json['price_syp'] as int : null,
      priceIsEstimate: json['price_is_estimate'] == true,
      canPurchase: json['can_purchase'] is bool
          ? json['can_purchase'] as bool
          : true,
      averageRating: json['average_rating'] is num
          ? (json['average_rating'] as num).toDouble()
          : null,
      reviewsCount: json['reviews_count'] is int
          ? json['reviews_count'] as int
          : 0,
    );
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesController, List<ProductCardModel>>(
      FavoritesController.new,
    );
