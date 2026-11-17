import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

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

void pushProduct(BuildContext context, String ref) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/p/$ref');
}

void pushCategory(BuildContext context, String slug) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/c/$slug');
}

void pushStore(BuildContext context, String slug) {
  final prefix = currentTabPrefix(context);
  context.push('$prefix/s/$slug');
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
