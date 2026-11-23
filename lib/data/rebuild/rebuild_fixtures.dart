import 'rebuild_models.dart';

/// Sample catalog for later phases. Widgets must not import this file.
abstract final class RebuildFixtures {
  static const channels = <RebuildChannel>[
    RebuildChannel(
      slug: 'women',
      name: 'نساء',
      image: 'assets/mock/channels/women.jpg',
    ),
    RebuildChannel(
      slug: 'men',
      name: 'رجال',
      image: 'assets/mock/channels/men.jpg',
    ),
    RebuildChannel(
      slug: 'kids',
      name: 'أطفال',
      image: 'assets/mock/channels/kids.jpg',
    ),
    RebuildChannel(
      slug: 'home',
      name: 'المنزل',
      image: 'assets/mock/channels/home.jpg',
    ),
  ];

  static const banners = <RebuildBanner>[
    RebuildBanner(
      slug: 'categories',
      image: 'assets/mock/banners/categories.jpg',
    ),
    RebuildBanner(slug: 'stores', image: 'assets/mock/banners/stores.jpg'),
  ];

  static const categories = <RebuildCategory>[
    RebuildCategory(
      slug: 'women',
      name: 'أزياء نسائية',
      image: 'assets/mock/categories/women.jpg',
      children: [
        RebuildCategory(
          slug: 'dresses',
          name: 'فساتين',
          image: 'assets/mock/categories/women.jpg',
          parentSlug: 'women',
        ),
        RebuildCategory(
          slug: 'tops',
          name: 'بلوزات',
          image: 'assets/mock/categories/women.jpg',
          parentSlug: 'women',
        ),
      ],
    ),
    RebuildCategory(
      slug: 'men',
      name: 'أزياء رجالية',
      image: 'assets/mock/categories/men.jpg',
      children: [
        RebuildCategory(
          slug: 'shirts',
          name: 'قمصان',
          image: 'assets/mock/categories/men.jpg',
          parentSlug: 'men',
        ),
      ],
    ),
    RebuildCategory(
      slug: 'kids',
      name: 'أطفال',
      image: 'assets/mock/categories/kids.jpg',
    ),
    RebuildCategory(
      slug: 'home',
      name: 'المنزل',
      image: 'assets/mock/categories/home.jpg',
    ),
  ];

  static const stores = <RebuildStore>[
    RebuildStore(
      slug: 'noor',
      name: 'نور',
      image: 'assets/mock/stores/noor.jpg',
    ),
    RebuildStore(
      slug: 'bayt-al-ward',
      name: 'بيت الورد',
      image: 'assets/mock/stores/bayt-al-ward.jpg',
    ),
    RebuildStore(
      slug: 'souq-homs',
      name: 'سوق حمص',
      image: 'assets/mock/stores/souq-homs.jpg',
    ),
  ];

  static const products = <RebuildProduct>[
    RebuildProduct(
      id: 1001,
      slug: '1001-cotton-shirt',
      name: 'قميص قطني بأكمام طويلة',
      brand: 'نور',
      image: 'assets/mock/products/1001.jpg',
      priceSyp: 125000,
      compareAtSyp: 150000,
      rating: 4.4,
      ratingCount: 2009,
      colorCount: 3,
      storeSlug: 'noor',
      categorySlug: 'shirts',
    ),
    RebuildProduct(
      id: 1002,
      slug: '1002-day-dress',
      name: 'فستان يومي بقصة مستقيمة',
      brand: 'بيت الورد',
      image: 'assets/mock/products/1002.jpg',
      priceSyp: 89000,
      storeSlug: 'bayt-al-ward',
      categorySlug: 'dresses',
    ),
    RebuildProduct(
      id: 1003,
      slug: '1003-trainers',
      name: 'حذاء رياضي خفيف',
      brand: 'سوق حمص',
      image: 'assets/mock/products/1003.jpg',
      priceSyp: 210000,
      compareAtSyp: 240000,
      rating: 4,
      ratingCount: 18,
      colorCount: 2,
      storeSlug: 'souq-homs',
      categorySlug: 'men',
    ),
    RebuildProduct(
      id: 1004,
      slug: '1004-glass-jug',
      name: 'إبريق زجاجي',
      brand: 'نور',
      image: 'assets/mock/products/1004.jpg',
      storeSlug: 'noor',
      categorySlug: 'home',
    ),
    RebuildProduct(
      id: 1005,
      slug: '1005-wool-blanket',
      name: 'بطانية صوف',
      brand: 'بيت الورد',
      image: 'assets/mock/products/1005.jpg',
      priceSyp: 75000,
      estimate: true,
      storeSlug: 'bayt-al-ward',
      categorySlug: 'home',
    ),
    RebuildProduct(
      id: 1006,
      slug: '1006-shoulder-bag',
      name: 'حقيبة كتف',
      brand: 'سوق حمص',
      image: 'assets/mock/products/1006.jpg',
      priceSyp: 64000,
      available: false,
      canPurchase: false,
      storeSlug: 'souq-homs',
      categorySlug: 'women',
    ),
    RebuildProduct(
      id: 1007,
      slug: '1007-table-lamp',
      name: 'مصباح طاولة',
      brand: 'نور',
      image: 'assets/mock/products/1007.jpg',
      priceSyp: 54000,
      rating: 5,
      storeSlug: 'noor',
      categorySlug: 'home',
    ),
    RebuildProduct(
      id: 1008,
      slug: '1008-kids-set',
      name: 'طقم أطفال قطني',
      brand: 'بيت الورد',
      image: 'assets/mock/products/1008.jpg',
      priceSyp: 43000,
      compareAtSyp: 43000,
      colorCount: 1,
      storeSlug: 'bayt-al-ward',
      categorySlug: 'kids',
    ),
  ];

  static final cart = RebuildCart(
    lines: [
      RebuildCartLine(product: products[0], quantity: 2),
      RebuildCartLine(product: products[2], quantity: 1),
    ],
  );

  static final favorites = <RebuildProduct>[products[0], products[5]];

  static final home = RebuildHome(
    channels: channels,
    banners: banners,
    categories: categories,
    stores: stores,
    rail: [products[1], products[4], products[7]],
    grid: products,
  );
}
