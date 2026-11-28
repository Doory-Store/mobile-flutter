import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/doory_strings.dart';
import '../core/routing/home_collection.dart';
import '../core/widgets/chrome.dart';
import '../data/models/catalog_models.dart';
import '../features/account/account_screen.dart';
import '../features/account/profile_screen.dart';
import '../features/addresses/address_form_screen.dart';
import '../features/addresses/addresses_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/categories/categories_landing_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/checkout/checkout_screen.dart';
import '../features/checkout/order_confirmation_screen.dart';
import '../features/debug/api_status_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/home/home_screen.dart';
import '../features/listing/collection_screen.dart';
import '../features/listing/listing_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/product/product_screen.dart';
import '../features/search/browsing_history_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/doory_shell.dart';
import '../features/store/store_screen.dart';
import '../features/support/new_ticket_screen.dart';
import '../features/support/support_screen.dart';
import 'branch_keys.dart';

List<RouteBase> browseRoutes() {
  return [
    GoRoute(
      path: 'search',
      builder: (context, state) =>
          SearchScreen(initialQuery: state.uri.queryParameters['q'] ?? ''),
    ),
    GoRoute(
      path: 'history',
      builder: (context, state) => const BrowsingHistoryScreen(),
    ),
    GoRoute(
      path: 'products',
      builder: (context, state) => CollectionScreen(
        collection: HomeCollection.parse(
          state.uri.queryParameters['collection'],
        ),
      ),
    ),
    GoRoute(
      path: 'c/:slug',
      builder: (context, state) =>
          ListingScreen(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: 'p/:ref',
      builder: (context, state) => ProductScreen(
        ref: state.pathParameters['ref']!,
        card: state.extra is ProductCardModel
            ? state.extra as ProductCardModel
            : null,
      ),
    ),
    GoRoute(
      path: 's/:slug',
      builder: (context, state) =>
          StoreScreen(slug: state.pathParameters['slug']!),
    ),
  ];
}

/// Full-screen flows above the tab bar: auth, checkout, and account pages.
List<RouteBase> flowRoutes() {
  return [
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          LoginScreen(next: state.uri.queryParameters['next']),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/order-confirmation',
      builder: (context, state) => const OrderConfirmationScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              OrderDetailScreen(publicId: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: '/addresses',
      builder: (context, state) => const AddressesScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const AddressFormScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => AddressFormScreen(
            id: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) =>
              NewTicketScreen(orderId: state.uri.queryParameters['order']),
        ),
      ],
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
          return DooryShell(
            navigationShell: navigationShell,
            location: state.uri.path,
          );
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
                builder: (context, state) => const CategoriesLandingScreen(),
                routes: [
                  GoRoute(
                    path: 'browse',
                    builder: (context, state) => CategoriesScreen(
                      initialSlug: state.uri.queryParameters['root'],
                    ),
                  ),
                  ...browseRoutes(),
                ],
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
      ...flowRoutes(),
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
