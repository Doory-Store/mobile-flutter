/// UI models for the rebuild. Widgets read these from repositories.
class RebuildChannel {
  const RebuildChannel({
    required this.slug,
    required this.name,
    required this.image,
  });

  final String slug;
  final String name;
  final String image;
}

class RebuildBanner {
  const RebuildBanner({required this.slug, required this.image});

  final String slug;
  final String image;
}

class RebuildCategory {
  const RebuildCategory({
    required this.slug,
    required this.name,
    required this.image,
    this.parentSlug,
    this.children = const [],
  });

  final String slug;
  final String name;
  final String image;
  final String? parentSlug;
  final List<RebuildCategory> children;
}

class RebuildStore {
  const RebuildStore({
    required this.slug,
    required this.name,
    required this.image,
    this.sample = true,
  });

  final String slug;
  final String name;
  final String image;
  final bool sample;
}

class RebuildProduct {
  const RebuildProduct({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    this.brand,
    this.priceSyp,
    this.compareAtSyp,
    this.estimate = false,
    this.rating,
    this.ratingCount,
    this.colorCount,
    this.available = true,
    this.canPurchase = true,
    this.sample = true,
    this.storeSlug,
    this.categorySlug,
  });

  final int id;
  final String slug;
  final String name;
  final String image;
  final String? brand;
  final int? priceSyp;
  final int? compareAtSyp;
  final bool estimate;
  final double? rating;
  final int? ratingCount;
  final int? colorCount;
  final bool available;
  final bool canPurchase;
  final bool sample;
  final String? storeSlug;
  final String? categorySlug;

  String get ref => slug;
}

class RebuildCartLine {
  const RebuildCartLine({required this.product, required this.quantity});

  final RebuildProduct product;
  final int quantity;
}

class RebuildCart {
  const RebuildCart({this.lines = const []});

  final List<RebuildCartLine> lines;

  int get quantityTotal {
    var total = 0;
    for (final line in lines) {
      total += line.quantity;
    }
    return total;
  }
}

class RebuildHome {
  const RebuildHome({
    this.channels = const [],
    this.banners = const [],
    this.categories = const [],
    this.stores = const [],
    this.rail = const [],
    this.grid = const [],
  });

  final List<RebuildChannel> channels;
  final List<RebuildBanner> banners;
  final List<RebuildCategory> categories;
  final List<RebuildStore> stores;
  final List<RebuildProduct> rail;
  final List<RebuildProduct> grid;
}
