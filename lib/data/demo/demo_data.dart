import '../models/catalog_models.dart';

/// Labelled fixtures. Repositories use these only when the host is unreachable.
abstract final class DemoData {
  static const bread = ProductCardModel(
    id: 4,
    slug: '4-khbz-tnor',
    name: 'خبز تنور بلدي',
    storeName: 'فرن الياسمين',
    storeSlug: 'furn-al-yasmin',
    priceSyp: 6000,
    sample: true,
  );

  static const oil = ProductCardModel(
    id: 10,
    slug: '10-zyt-zyton',
    name: 'زيت زيتون بلدي',
    storeName: 'بقالية أبو سليم',
    storeSlug: 'baqqaliyat-abu-saleem',
    priceSyp: 85000,
    priceIsEstimate: true,
    sample: true,
  );

  static const sweets = ProductCardModel(
    id: 13,
    slug: '13-bklao',
    name: 'بقلاوة بالفستق',
    storeName: 'حلويات الشام',
    storeSlug: 'halawiyat-al-sham',
    priceSyp: 45000,
    sample: true,
  );

  static const categories = [
    CategoryNode(
      id: 2,
      name: 'مخبوزات',
      slug: 'bakery',
      children: [
        CategoryNode(id: 9, name: 'خبز', slug: 'bakery-bread'),
        CategoryNode(id: 10, name: 'معجنات', slug: 'bakery-pastry'),
      ],
    ),
    CategoryNode(id: 3, name: 'بقالة', slug: 'grocery'),
    CategoryNode(id: 6, name: 'حلويات', slug: 'sweets'),
  ];

  static const home = HomeContent(
    deliveryMessage: 'عادةً في نفس اليوم داخل حمص',
    featured: [bread, sweets],
    latest: [oil, bread],
    sample: true,
  );

  static ProductPage? listingFor(String? slug) {
    final items = switch (slug) {
      'bakery' || 'bakery-bread' || 'bakery-pastry' => [bread],
      'grocery' => [oil],
      'sweets' => [sweets],
      'furn-al-yasmin' => [bread],
      _ => null,
    };
    if (items == null) return null;
    return ProductPage(
      items: items,
      meta: PageInfo(page: 1, perPage: 24, total: items.length, lastPage: 1),
      sample: true,
    );
  }

  static SearchPage? searchFor(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;
    final hits = [bread, oil, sweets]
        .where(
          (item) => item.name.contains(trimmed) || trimmed.contains('تجريبي'),
        )
        .toList();
    if (hits.isEmpty && trimmed.length < 2) return null;
    final items = hits.isEmpty ? const <ProductCardModel>[] : hits;
    return SearchPage(
      query: trimmed,
      items: items,
      meta: PageInfo(page: 1, perPage: 24, total: items.length, lastPage: 1),
      degraded: false,
      categoryFacets: const [CategoryFacet(id: 9, count: 1, name: 'خبز')],
      sample: true,
    );
  }

  static ProductDetailModel? product(int id) {
    const details = <int, ProductDetailModel>{
      4: ProductDetailModel(
        id: 4,
        slug: '4-khbz-tnor',
        name: 'خبز تنور بلدي',
        description: 'ربطة خبز تنور. هذه عينة للتطوير عندما يتعذر الاتصال.',
        storeId: 4,
        storeName: 'فرن الياسمين',
        storeSlug: 'furn-al-yasmin',
        categoryId: 9,
        categoryName: 'خبز',
        categorySlug: 'bakery-bread',
        options: [
          ProductOptionModel(
            id: 1,
            label: 'ربطة صغيرة',
            available: true,
            lowStock: false,
          ),
        ],
        priceSyp: 6000,
        shareUrl: 'https://doory.elogyc.com/ar/p/4-khbz-tnor',
        sample: true,
      ),
    };
    return details[id];
  }

  static StoreModel? store(String slug) {
    if (slug == 'furn-al-yasmin') {
      return const StoreModel(
        slug: 'furn-al-yasmin',
        id: 4,
        name: 'فرن الياسمين',
        description: 'متجر تجريبي في حمص.',
        areaLabel: 'الإنشاءات',
        products: [bread],
        sample: true,
      );
    }
    return StoreModel(
      slug: slug,
      name: 'متجر تجريبي',
      description: 'تعذّر تحميل المتجر، وهذه عينة معلّمة.',
      products: const [bread, oil],
      sample: true,
    );
  }
}
