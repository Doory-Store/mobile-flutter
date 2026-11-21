import '../l10n/doory_strings.dart';

/// Home shelves that open a full listing from «عرض الكل».
///
/// [key] travels in the `collection` query parameter of the `products` route,
/// so a shelf link survives a cold start or a shared deep link.
enum HomeCollection {
  featured('featured', DooryStrings.featured),
  latest('latest', DooryStrings.latest),
  recentlyViewed('recent', DooryStrings.recentlyViewed);

  const HomeCollection(this.key, this.title);

  final String key;
  final String title;

  static HomeCollection parse(String? raw) {
    for (final collection in values) {
      if (collection.key == raw) return collection;
    }
    return HomeCollection.latest;
  }
}

/// Listing key for the whole catalog: `GET /products` without a category.
const allProductsKey = '*';
