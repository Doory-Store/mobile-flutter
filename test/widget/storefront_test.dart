import 'package:doory_mobile/app/app.dart';
import 'package:doory_mobile/app/router.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/chrome.dart';
import 'package:doory_mobile/core/widgets/product_card.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/core/widgets/bottom_tab_bar.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/search/search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_transport.dart';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

void main() {
  testWidgets(
    'product card shows the price, hides a missing amount, and labels samples',
    (tester) async {
      final prefs = await _prefs();
      Future<void> pump(ProductCardModel product) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
            child: MaterialApp(
              theme: dooryTheme(),
              home: Scaffold(body: ProductCard(product: product, width: 180)),
            ),
          ),
        );
      }

      await pump(
        const ProductCardModel(
          id: 4,
          slug: '4-bread',
          name: 'خبز تنور',
          priceSyp: 6000,
          priceIsEstimate: true,
          sample: true,
        ),
      );
      expect(find.text('خبز تنور'), findsOneWidget);
      expect(find.textContaining('6,000'), findsOneWidget);
      expect(find.text(DooryStrings.estimate), findsOneWidget);
      expect(find.text(DooryStrings.demo), findsOneWidget);

      await pump(const ProductCardModel(id: 5, slug: '5-x', name: 'بدون سعر'));
      expect(find.text('بدون سعر'), findsOneWidget);
      expect(find.textContaining('ل.س'), findsNothing);
    },
  );

  testWidgets('maintenance banner shows the Arabic window copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: dooryTheme(),
        home: const Scaffold(body: MaintenanceBanner(message: 'صيانة مجدولة')),
      ),
    );
    expect(find.text('صيانة مجدولة'), findsOneWidget);
  });

  testWidgets('bottom bar declares Home first so RTL puts it on the right', (
    tester,
  ) async {
    final prefs = await _prefs();
    final transport = FakeTransport((path, query) async {
      return switch (path) {
        '/home' => {'featured': [], 'latest': []},
        '/categories' => [],
        '/meta/status' => {'maintenance_active': false},
        _ => throw const ApiException(ApiFailureKind.notFound, 'no'),
      };
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          apiTransportProvider.overrideWith((ref) => transport),
          appConfigProvider.overrideWithValue(
            const AppConfig(
              baseUrl: 'https://example.test/api/v1',
              timeout: Duration(seconds: 4),
              flavor: AppFlavor.dev,
            ),
          ),
        ],
        child: const DooryApp(),
      ),
    );
    await tester.pumpAndSettle();
    final bar = tester.widget<BottomTabBar>(find.byType(BottomTabBar));
    expect(bar.current, DooryTab.home);
    expect(DooryTab.values, [
      DooryTab.home,
      DooryTab.categories,
      DooryTab.favorites,
      DooryTab.cart,
      DooryTab.account,
    ]);
    expect(find.text(DooryStrings.tabHome), findsWidgets);
    expect(find.text(DooryStrings.tabCategories), findsWidgets);
    expect(find.text(DooryStrings.tabFavorites), findsWidgets);
    expect(find.text(DooryStrings.tabCart), findsWidgets);
    expect(find.text(DooryStrings.tabAccount), findsWidgets);
    expect(find.text(DooryStrings.sectionReady), findsOneWidget);
  });

  testWidgets('an unreachable home shows a labelled fixture and a retry', (
    tester,
  ) async {
    final prefs = await _prefs();
    final transport = FakeTransport((path, query) async {
      throw const ApiException(ApiFailureKind.network, 'down');
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          apiTransportProvider.overrideWith((ref) => transport),
          appConfigProvider.overrideWithValue(
            const AppConfig(
              baseUrl: 'https://example.test/api/v1',
              timeout: Duration(seconds: 4),
              flavor: AppFlavor.dev,
            ),
          ),
          routerProvider.overrideWith((ref) {
            final router = buildRouter(legacyStorefront: true);
            ref.onDispose(router.dispose);
            return router;
          }),
        ],
        child: const DooryApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(DooryStrings.demo), findsWidgets);
    expect(find.text('خبز تنور بلدي'), findsWidgets);
    expect(find.text(DooryStrings.retry), findsWidgets);
  });

  testWidgets('a rejected home does not swap in sample products', (
    tester,
  ) async {
    final prefs = await _prefs();
    final transport = FakeTransport((path, query) async {
      if (path == '/home') {
        throw const ApiException(
          ApiFailureKind.validation,
          'البيانات غير صالحة',
        );
      }
      if (path == '/categories') return [];
      return {'maintenance_active': false};
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          apiTransportProvider.overrideWith((ref) => transport),
          appConfigProvider.overrideWithValue(
            const AppConfig(
              baseUrl: 'https://example.test/api/v1',
              timeout: Duration(seconds: 4),
              flavor: AppFlavor.dev,
            ),
          ),
          routerProvider.overrideWith((ref) {
            final router = buildRouter(legacyStorefront: true);
            ref.onDispose(router.dispose);
            return router;
          }),
        ],
        child: const DooryApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('البيانات غير صالحة'), findsOneWidget);
    expect(find.text('خبز تنور بلدي'), findsNothing);
    expect(find.text(DooryStrings.demo), findsNothing);
  });

  testWidgets(
    'empty search stays local and a degraded response is labelled quietly',
    (tester) async {
      final prefs = await _prefs();
      final transport = FakeTransport((path, query) async {
        if (path == '/categories') {
          return [
            {'id': 9, 'name': 'خبز', 'slug': 'bakery-bread', 'parent_id': null},
          ];
        }
        if (path == '/search') {
          return {
            'search': {
              'q': query?['q'],
              'degraded': true,
              'engine': 'database',
            },
            'facets': {
              'category': [
                {'id': 9, 'count': 1},
              ],
            },
            'data': [],
            'meta': {'page': 1, 'per_page': 24, 'total': 0, 'last_page': 1},
          };
        }
        throw const ApiException(ApiFailureKind.notFound, 'no');
      });

      Widget app(String query) {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            apiTransportProvider.overrideWith((ref) => transport),
            appConfigProvider.overrideWithValue(
              const AppConfig(
                baseUrl: 'https://example.test/api/v1',
                timeout: Duration(seconds: 4),
                flavor: AppFlavor.dev,
              ),
            ),
          ],
          child: MaterialApp(
            theme: dooryTheme(),
            locale: const Locale('ar'),
            home: SearchScreen(initialQuery: query),
          ),
        );
      }

      await tester.pumpWidget(app(''));
      await tester.pumpAndSettle();
      expect(find.text(DooryStrings.emptySearch), findsOneWidget);
      expect(transport.calls.where((path) => path == '/search'), isEmpty);

      transport.calls.clear();
      await tester.pumpWidget(app('خبز'));
      await tester.pumpAndSettle();
      expect(transport.calls, contains('/search'));
      expect(find.text(DooryStrings.degraded), findsOneWidget);
      expect(find.text(DooryStrings.noResults), findsOneWidget);
    },
  );
}
