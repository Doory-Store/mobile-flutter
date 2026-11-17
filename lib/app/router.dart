import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/doory_strings.dart';
import '../core/widgets/chrome.dart';
import '../features/account/account_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/debug/api_status_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/home/home_screen.dart';
import '../features/listing/listing_screen.dart';
import '../features/product/product_screen.dart';
import '../features/search/search_screen.dart';
import '../features/shell/doory_shell.dart';
import '../features/store/store_placeholder_screen.dart';
import 'branch_keys.dart';

List<RouteBase> browseRoutes() {
  return [
    GoRoute(
      path: 'search',
      builder: (context, state) =>
          SearchScreen(initialQuery: state.uri.queryParameters['q'] ?? ''),
    ),
    GoRoute(
      path: 'c/:slug',
      builder: (context, state) =>
          ListingScreen(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: 'p/:ref',
      builder: (context, state) =>
          ProductScreen(ref: state.pathParameters['ref']!),
    ),
    GoRoute(
      path: 's/:slug',
      builder: (context, state) =>
          StorePlaceholderScreen(slug: state.pathParameters['slug']!),
    ),
  ];
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const _MissingPage(),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DooryShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: branchNavigatorKeys[0],
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
                routes: browseRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: branchNavigatorKeys[1],
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
                routes: browseRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: branchNavigatorKeys[2],
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesScreen(),
                routes: browseRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: branchNavigatorKeys[3],
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
                routes: browseRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: branchNavigatorKeys[4],
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'status',
                    builder: (context, state) => const ApiStatusScreen(),
                  ),
                  ...browseRoutes(),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = buildRouter();
  ref.onDispose(router.dispose);
  return router;
});

class _MissingPage extends StatelessWidget {
  const _MissingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const StatusMessage(title: DooryStrings.notFoundPage),
    );
  }
}
