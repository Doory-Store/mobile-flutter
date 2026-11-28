import 'package:doory_mobile/data/models/buyer_dto.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mapCard keeps the card fields GET /products already returns', () {
    // Trimmed from a live GET /products item (2026-11-26).
    final dto = ProductCardDto.fromJson({
      'id': 521,
      'slug': '521-zyt-zyton',
      'name': 'زيت زيتون، 750 مل',
      'photo': 'https://doory.elogyc.com/storage/products/x/card.webp',
      'store_name': 'متجر 1',
      'store_slug': 'store-01',
      'available': true,
      'price_syp': 42000,
      'price_is_estimate': false,
      'can_purchase': true,
      'is_favorited': false,
      'average_rating': 3.9,
      'reviews_count': 10,
      'brand_id': 11,
      'brand_name': 'دار المونة',
      'brand_verified': true,
      'compare_at_syp': 52500,
      'discount_percent': 20,
      'badges': [
        {'code': 'local_product', 'label': 'منتج محلي'},
      ],
      'viewer_activity': {
        'metric': 'unique_viewers',
        'count': 18,
        'window_hours': 24,
        'as_of': '2026-11-25T12:09:41+03:00',
      },
    });

    final card = mapCard(dto)!;

    expect(card.brandName, 'دار المونة');
    expect(card.brandVerified, isTrue);
    expect(card.compareAtSyp, 52500);
    expect(card.discountPercent, 20);
    expect(card.badgeLabels, ['منتج محلي']);
    expect(card.viewers?.count, 18);
    expect(card.viewers?.windowHours, 24);
  });

  test(
    'mapCard leaves the extra fields empty when /home featured omits them',
    () {
      final dto = ProductCardDto.fromJson({
        'id': 7,
        'slug': '7-bread',
        'name': 'خبز',
        'price_syp': 6000,
        'average_rating': null,
        'reviews_count': 0,
      });

      final card = mapCard(dto)!;

      expect(card.brandName, isNull);
      expect(card.brandVerified, isFalse);
      expect(card.compareAtSyp, isNull);
      expect(card.discountPercent, isNull);
      expect(card.badgeLabels, isEmpty);
      expect(card.viewers, isNull);
    },
  );
}
