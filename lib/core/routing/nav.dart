import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/catalog_models.dart';
import 'home_collection.dart';

/// Prefix of the tab that owns [path], or empty when the route sits on Home.
String tabPrefixFrom(String path) {
  const roots = <String>['/categories', '/favorites', '/cart', '/account'];
  for (final root in roots) {
    if (path == root || path.startsWith('$root/')) return root;
  }
  return '';
}

String currentTabPrefix(BuildContext context) {
  return tabPrefixFrom(GoRouterState.of(context).uri.path);
}

/// Opens the product page. The tapped [card] travels as the route `extra`, so
/// browsing history can keep its struck price, discount, and brand (they are
/// not on the detail payload). A deep link has no card.
void pushProduct(BuildContext context, String ref, {ProductCardModel? card}) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/p/$ref', extra: card);
}

void pushCategory(BuildContext context, String slug) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/c/$slug');
}

/// Opens the rail page (`CategoriesScreen`) with [slug]'s root selected.
void pushCategoryBrowse(BuildContext context, String slug) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/browse?root=${Uri.encodeQueryComponent(slug)}');
}

/// Opens the rail page from any tab. `browse` lives only under `/categories`,
/// so this switches to that tab (its landing stays underneath, so back works).
void goCategoryBrowse(BuildContext context, String slug) {
  context.go('/categories/browse?root=${Uri.encodeQueryComponent(slug)}');
}

void pushHistory(BuildContext context) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/history');
}

void pushStore(BuildContext context, String slug) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/s/$slug');
}

void pushCollection(BuildContext context, HomeCollection collection) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/products?collection=${collection.key}');
}

void pushSearch(BuildContext context, [String query = '']) {
  final prefix = currentTabPrefix(context);
  final trimmed = query.trim();
  final location = trimmed.isEmpty
      ? '$prefix/search'
      : '$prefix/search?q=${Uri.encodeQueryComponent(trimmed)}';
  context.push(location);
}

void replaceSearch(BuildContext context, String query) {
  final prefix = currentTabPrefix(context);
  final trimmed = query.trim();
  final location = trimmed.isEmpty
      ? '$prefix/search'
      : '$prefix/search?q=${Uri.encodeQueryComponent(trimmed)}';
  final current = GoRouterState.of(context).uri;
  final currentQ = current.queryParameters['q'] ?? '';
  if (current.path == '$prefix/search' && currentQ == trimmed) return;
  context.replace(location);
}

void goTabRoot(BuildContext context) {
  final prefix = currentTabPrefix(context);
  context.go(prefix.isEmpty ? '/' : prefix);
}
