import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/l10n/pdp_strings.dart';
import 'package:doory_mobile/core/l10n/shop_strings.dart';
import 'package:doory_mobile/core/theme/doory_colors.dart';
import 'package:doory_mobile/features/product/pdp_mock.dart';
import 'package:doory_mobile/core/l10n/search_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/product/product_screen.dart';
import 'package:doory_mobile/features/search/search_screen.dart';
import 'package:doory_mobile/features/shell/doory_shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_transport.dart';

const _config = AppConfig(
  baseUrl: 'https://example.test/api/v1',
  timeout: Duration(seconds: 4),
  flavor: AppFlavor.dev,
);

Map<String, dynamic> _product() => {
  'id': 7,
  'slug': '7-zayt',
  'name': 'زيت زيتون بلدي',
  'description': 'زيت زيتون معصور على البارد من حقول حمص. ' * 8,
  'store': {'id': 3, 'name': 'بقالية أبو سليم', 'slug': 'abu-saleem'},
  'category': {'id': 12, 'name': 'زيوت وسمون', 'slug': 'grocery-oil'},
  'photos': [
    'https://example.test/storage/products/a/card.webp',
    'https://example.test/storage/products/b/card.webp',
  ],
  'options': [
    {'id': 1, 'label': '250 مل', 'available': true},
    {'id': 2, 'label': '750 مل', 'available': true},
  ],
  'price_syp': 42000,
  'can_purchase': true,
  'available': true,
  'average_rating': 3.9,
  'reviews_count': 10,
  'share': {'url': 'https://example.test/ar/p/7-zayt'},
};

Future<SharedPreferences> _prefs([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

Widget _host(SharedPreferences prefs, FakeTransport transport, Widget home) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      apiTransportProvider.overrideWith((ref) => transport),
      appConfigProvider.overrideWithValue(_config),
    ],
    child: MaterialApp(
      theme: dooryTheme(),
      locale: const Locale('ar'),
      home: Directionality(textDirection: TextDirection.rtl, child: home),
    ),
  );
}

FakeTransport _pdpTransport() => FakeTransport((path, query) async {
  if (path == '/products/7') return _product();
  throw const ApiException(ApiFailureKind.notFound, 'no');
});

Future<void> _phone(WidgetTester tester) async {
  // A short landscape 800×600 surface buries the title under a 4:5 gallery.
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  group('product page', () {
    testWidgets('shows the live product with the sticky add-to-cart bar', (
      tester,
    ) async {
      await _phone(tester);
      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _pdpTransport(), const ProductScreen(ref: '7-zayt')),
      );
      await tester.pumpAndSettle();

      expect(find.text(PdpStrings.photoCounter(1, 2)), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, PdpStrings.addToCart),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.textContaining('زيت زيتون بلدي'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('زيت زيتون بلدي'), findsWidgets);
    });

    testWidgets('add to cart with several options opens the option sheet', (
      tester,
    ) async {
      await _phone(tester);
      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _pdpTransport(), const ProductScreen(ref: '7-zayt')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, PdpStrings.addToCart));
      await tester.pumpAndSettle();
      expect(find.text(PdpStrings.optionsTitle), findsWidgets);
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('features section expands and collapses in place', (
      tester,
    ) async {
      await _phone(tester);
      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _pdpTransport(), const ProductScreen(ref: '7-zayt')),
      );
      await tester.pumpAndSettle();

      final header = find.text(PdpStrings.featuresTitle);
      await tester.scrollUntilVisible(
        header,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('بلد المنشأ'), findsNothing);
      await tester.tap(header);
      await tester.pumpAndSettle();
      expect(find.text('بلد المنشأ'), findsOneWidget);
      await tester.tap(header);
      await tester.pumpAndSettle();
      expect(find.text('بلد المنشأ'), findsNothing);
    });

    testWidgets('sections follow the Trendyol reorder', (tester) async {
      await _phone(tester);
      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _pdpTransport(), const ProductScreen(ref: '7-zayt')),
      );
      await tester.pumpAndSettle();

      final pdpScroll = find
          .descendant(
            of: find.byType(ProductScreen),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection != AxisDirection.left &&
                  widget.axisDirection != AxisDirection.right,
            ),
          )
          .first;

      final markers = <String, Finder>{
        'seller': find.text(PdpStrings.followers(PdpMock.sellerFollowers)),
        'campaigns': find.text(PdpStrings.campaignsTitle),
        'delivery': find.text(PdpMock.expectedDelivery),
        'shipping': find.text(PdpStrings.shippingTitle),
        'commitments': find.text(PdpStrings.commitmentsTitle),
        'returns': find.text(PdpStrings.freeReturn),
        'priceAlert': find.text(PdpStrings.priceDropAlert),
        'stockAlert': find.text(PdpStrings.backInStockAlert),
        'features': find.text(PdpStrings.featuresTitle),
      };

      final seen = <String>[];
      final state = tester.state<ScrollableState>(pdpScroll);
      final viewport =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      for (var y = 0.0; ; y += 80) {
        final target = y.clamp(0.0, state.position.maxScrollExtent);
        state.position.jumpTo(target);
        await tester.pump();
        final batch = <({String key, double dy})>[];
        for (final entry in markers.entries) {
          if (seen.contains(entry.key)) continue;
          if (entry.value.evaluate().isEmpty) continue;
          final dy = tester.getTopLeft(entry.value).dy;
          final height = tester.getSize(entry.value).height;
          if (dy + height > 0 && dy < viewport) {
            batch.add((key: entry.key, dy: dy));
          }
        }
        batch.sort((a, b) => a.dy.compareTo(b.dy));
        seen.addAll(batch.map((e) => e.key));
        if (seen.length == markers.length) break;
        if (target == state.position.maxScrollExtent) break;
      }

      expect(seen, [
        'seller',
        'campaigns',
        'delivery',
        'shipping',
        'commitments',
        'returns',
        'priceAlert',
        'stockAlert',
        'features',
      ]);
      expect(find.text(ShopStrings.priceDropAlert), findsNothing);
    });

    testWidgets('alert rows toggle on the device and colour missing copy', (
      tester,
    ) async {
      await _phone(tester);
      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _pdpTransport(), const ProductScreen(ref: '7-zayt')),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text(PdpStrings.expectedDelivery),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      final date = tester.widget<Text>(find.text(PdpMock.expectedDelivery));
      expect(date.style?.color, DooryColors.backendMissing);

      await tester.scrollUntilVisible(
        find.text(PdpStrings.priceDropAlert),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byType(Switch), findsNWidgets(2));
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();
      expect(find.text(ShopStrings.priceWatchOn), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch).first).value, isTrue);
    });

    testWidgets('sticky notify uses the on-device stock watch', (tester) async {
      await _phone(tester);
      final prefs = await _prefs();
      final product = _product()..['available'] = false;
      await tester.pumpWidget(
        _host(
          prefs,
          FakeTransport((path, query) async {
            if (path == '/products/7') return product;
            throw const ApiException(ApiFailureKind.notFound, 'no');
          }),
          const ProductScreen(ref: '7-zayt'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(OutlinedButton, PdpStrings.notifyMe),
      );
      await tester.pumpAndSettle();
      expect(find.text(PdpStrings.stockWatchOn), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text(PdpStrings.backInStockAlert),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.widget<Switch>(find.byType(Switch).at(1)).value, isTrue);
    });

    testWidgets('share opens a sheet with the product link', (tester) async {
      await _phone(tester);
      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _pdpTransport(), const ProductScreen(ref: '7-zayt')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(PdpStrings.share).first);
      await tester.pumpAndSettle();
      expect(find.text(PdpStrings.shareTitle), findsOneWidget);
      expect(find.text('https://example.test/ar/p/7-zayt'), findsOneWidget);
    });
  });

  group('search', () {
    testWidgets('landing lists recent searches and «مسح» clears them', (
      tester,
    ) async {
      final prefs = await _prefs({
        'doory.mock.recent-searches.v1': ['عباية', 'اكسسوارات'],
      });
      final transport = FakeTransport((path, query) async {
        if (path == '/categories') return [];
        throw const ApiException(ApiFailureKind.notFound, 'no');
      });
      await tester.pumpWidget(
        _host(prefs, transport, const SearchScreen(initialQuery: '')),
      );
      await tester.pumpAndSettle();

      expect(find.text(SearchStrings.historyTitle), findsOneWidget);
      expect(find.text('عباية'), findsOneWidget);
      expect(find.text('اكسسوارات'), findsOneWidget);
      await tester.tap(find.text(SearchStrings.clearHistory));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.clearHistoryConfirm), findsOneWidget);
      await tester.tap(find.text(DooryStrings.cancel));
      await tester.pumpAndSettle();
      expect(find.text('عباية'), findsOneWidget);
      await tester.tap(find.text(SearchStrings.clearHistory));
      await tester.pumpAndSettle();
      await tester.tap(find.text(SearchStrings.historyDelete));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.historyTitle), findsNothing);
      expect(find.text('عباية'), findsNothing);
      expect(prefs.getStringList('doory.mock.recent-searches.v1'), isEmpty);
    });

    testWidgets('a popular chip runs the search and lands in history', (
      tester,
    ) async {
      final prefs = await _prefs();
      final queries = <String>[];
      final transport = FakeTransport((path, query) async {
        if (path == '/categories') return [];
        if (path == '/search') {
          queries.add('${query?['q']}');
          return {
            'search': {'q': query?['q']},
            'data': [],
            'meta': {'page': 1, 'per_page': 24, 'total': 0, 'last_page': 1},
          };
        }
        throw const ApiException(ApiFailureKind.notFound, 'no');
      });
      await tester.pumpWidget(
        _host(prefs, transport, const SearchScreen(initialQuery: '')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('خبز'));
      await tester.pumpAndSettle();
      expect(queries, ['خبز']);
      expect(find.text(SearchStrings.noResultsFor('خبز')), findsOneWidget);
      expect(prefs.getStringList('doory.mock.recent-searches.v1'), ['خبز']);
    });
  });

  test('the tab bar hides on product pages only', () {
    expect(hidesTabBar('/p/7-zayt'), isTrue);
    expect(hidesTabBar('/categories/p/7'), isTrue);
    expect(hidesTabBar('/'), isFalse);
    expect(hidesTabBar('/search'), isFalse);
    expect(hidesTabBar('/categories/c/oil'), isFalse);
    expect(hidesTabBar('/account/products'), isFalse);
  });
}
