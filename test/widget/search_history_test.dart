import 'dart:convert';

import 'package:doory_mobile/app/app.dart';
import 'package:doory_mobile/app/router.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/format/price_format.dart';
import 'package:doory_mobile/core/l10n/card_strings.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/l10n/shop_strings.dart';
import 'package:doory_mobile/core/l10n/search_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/theme/doory_colors.dart';
import 'package:doory_mobile/core/widgets/category_avatar.dart';
import 'package:doory_mobile/core/widgets/chrome.dart';
import 'package:doory_mobile/core/widgets/product_card.dart';
import 'package:doory_mobile/core/widgets/product_shelf.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/account/local_preferences.dart';
import 'package:doory_mobile/features/cart/cart_controller.dart';
import 'package:doory_mobile/features/categories/categories_landing_screen.dart';
import 'package:doory_mobile/features/categories/category_rail.dart';
import 'package:doory_mobile/features/home/home_screen.dart';
import 'package:doory_mobile/features/search/browsing_history.dart';
import 'package:doory_mobile/features/search/browsing_history_screen.dart';
import 'package:doory_mobile/features/search/history_row_card.dart';
import 'package:doory_mobile/features/search/recent_searches.dart';
import 'package:doory_mobile/features/search/recommended_shelf.dart';
import 'package:doory_mobile/features/search/search_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_transport.dart';

const _config = AppConfig(
  baseUrl: 'https://example.test/api/v1',
  timeout: Duration(seconds: 4),
  flavor: AppFlavor.dev,
);

final _categories = [
  {'id': 3, 'name': 'بقالة', 'slug': 'grocery', 'parent_id': null},
  {'id': 12, 'name': 'زيوت وسمون', 'slug': 'grocery-oil', 'parent_id': 3},
  {'id': 7, 'name': 'منظفات', 'slug': 'cleaning', 'parent_id': null},
];

Map<String, dynamic> _detail(int id) => {
  'id': id,
  'slug': '$id-item',
  'name': 'منتج $id',
  'store': {'id': 3, 'name': 'بقالية أبو سليم', 'slug': 'abu-saleem'},
  'category': {'id': 12, 'name': 'زيوت وسمون', 'slug': 'grocery-oil'},
  'photos': ['https://example.test/storage/products/$id/card.webp'],
  'options': [
    {'id': 1, 'label': '250 مل', 'available': true},
  ],
  'price_syp': 42000,
  'can_purchase': true,
  'available': true,
  'average_rating': 3.9,
  'reviews_count': 10,
  'share': {'url': 'https://example.test/ar/p/$id-item'},
};

Map<String, dynamic> _card(int id) => {
  'id': id,
  'slug': '$id-item',
  'name': 'منتج $id',
  'store_name': 'فرن الياسمين',
  'store_slug': 'furn-al-yasmin',
  'available': true,
  'price_syp': 6000,
  'can_purchase': true,
};

FakeTransport _transport({
  List<Map<String, dynamic>> featured = const [],
  List<Map<String, dynamic>> recentlyViewed = const [],
  List<Map<String, dynamic>> products = const [],
  List<String>? searches,
}) => FakeTransport((path, query) async {
  if (path == '/home') {
    return {
      'featured': featured,
      'latest': [],
      if (recentlyViewed.isNotEmpty)
        'recommendations': {'recently_viewed': recentlyViewed},
    };
  }
  if (path == '/products') {
    if (products.isEmpty) {
      throw const ApiException(ApiFailureKind.notFound, 'no');
    }
    return {
      'data': products,
      'meta': {
        'page': 1,
        'per_page': 10,
        'total': products.length,
        'last_page': 1,
      },
    };
  }
  if (path == '/categories') return _categories;
  if (path == '/meta/status') return {'maintenance_active': false};
  if (path == '/search') {
    searches?.add('${query?['q']}');
    return {
      'search': {'q': query?['q']},
      'data': [],
      'meta': {'page': 1, 'per_page': 24, 'total': 0, 'last_page': 1},
    };
  }
  final product = RegExp(r'^/products/(\d+)$').firstMatch(path);
  if (product != null) return _detail(int.parse(product.group(1)!));
  throw const ApiException(ApiFailureKind.notFound, 'no');
});

Future<SharedPreferences> _prefs([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

Future<GoRouterHandle> _pumpApp(
  WidgetTester tester,
  SharedPreferences prefs, {
  FakeTransport? transport,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final t = transport ?? _transport();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        apiTransportProvider.overrideWith((ref) => t),
        appConfigProvider.overrideWithValue(_config),
      ],
      child: const DooryApp(),
    ),
  );
  await tester.pumpAndSettle();
  return GoRouterHandle(
    ProviderScope.containerOf(tester.element(find.byType(DooryApp))),
    tester,
  );
}

class GoRouterHandle {
  GoRouterHandle(this.container, this._tester);

  final ProviderContainer container;
  final WidgetTester _tester;

  /// Location of the page on top (pushes do not change the router's base).
  String get path =>
      GoRouterState.of(_tester.element(find.byType(Scaffold).last)).uri.path;

  void go(String location) => container.read(routerProvider).go(location);
}

HistoryEntry _entry(
  int id, {
  int? categoryId,
  String? categoryName,
  int? viewedPriceSyp,
  int? compareAtSyp,
  int? discountPercent,
  double? rating,
  bool canPurchase = true,
}) => HistoryEntry(
  card: ProductCardModel(
    id: id,
    slug: '$id-item',
    name: 'منتج $id',
    storeName: 'بقالية أبو سليم',
    priceSyp: 5000,
    canPurchase: canPurchase,
    averageRating: rating,
    reviewsCount: rating == null ? 0 : 12,
    compareAtSyp: compareAtSyp,
    discountPercent: discountPercent,
  ),
  categoryId: categoryId,
  categoryName: categoryName,
  viewedPriceSyp: viewedPriceSyp,
  viewedAt: DateTime(2026, 11, 1),
);

double _y(WidgetTester tester, Finder finder) =>
    tester.getTopLeft(finder.first).dy;

bool _cairoLoaded = false;

Future<void> _ensureCairo() async {
  if (_cairoLoaded) return;
  final loader = FontLoader('Cairo');
  for (final asset in [
    'assets/fonts/Cairo-Regular.ttf',
    'assets/fonts/Cairo-SemiBold.ttf',
    'assets/fonts/Cairo-Bold.ttf',
  ]) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
  _cairoLoaded = true;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _ensureCairo();
  });

  group('read-only search fields', () {
    testWidgets('Home, the categories landing, and the rail open search', (
      tester,
    ) async {
      final app = await _pumpApp(tester, await _prefs());

      final home = tester.widget<DoorySearchField>(
        find.byType(DoorySearchField),
      );
      expect(home.readOnly, isTrue);
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      expect(find.byType(SearchScreen), findsOneWidget);
      expect(app.path, '/search');
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.text(DooryStrings.tabCategories));
      await tester.pumpAndSettle();
      expect(find.byType(CategoriesLandingScreen), findsOneWidget);
      expect(
        tester.widget<DoorySearchField>(find.byType(DoorySearchField)).readOnly,
        isTrue,
      );
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      expect(find.byType(SearchScreen), findsOneWidget);
      expect(app.path, '/categories/search');
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // The rail page keeps the same read-only pill.
      await tester.tap(find.text('منظفات'));
      await tester.pumpAndSettle();
      expect(find.byType(CategoryRail), findsOneWidget);
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      expect(find.byType(SearchScreen), findsOneWidget);
    });
  });

  group('search landing', () {
    Future<GoRouterHandle> openSearch(
      WidgetTester tester, [
      Map<String, Object> prefs = const {},
    ]) async {
      final app = await _pumpApp(tester, await _prefs(prefs));
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      return app;
    }

    testWidgets(
      '«عمليات بحث مقترحة» replaces «البحث الشائع» with a red label',
      (tester) async {
        await openSearch(tester);

        expect(find.text('عمليات بحث مقترحة'), findsOneWidget);
        expect(find.text('البحث الشائع'), findsNothing);
        final label = tester.widget<Text>(find.text(SearchStrings.unsupported));
        expect(label.style?.color, DooryColors.backendMissing);
        expect(label.style?.fontSize, 11);
        // Fixed sample pills in one horizontal row.
        expect(popularSearches, hasLength(8));
        expect(popularSearches.last, 'مكسرات');
        for (final term in ['زيت زيتون', 'خبز']) {
          expect(find.text(term), findsOneWidget);
        }
        final pill = tester.getSize(
          find
              .ancestor(of: find.text('خبز'), matching: find.byType(Material))
              .first,
        );
        expect(pill.height, 30);
      },
    );

    testWidgets('a suggested pill runs that search', (tester) async {
      final searches = <String>[];
      final prefs = await _prefs();
      await _pumpApp(tester, prefs, transport: _transport(searches: searches));
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('خبز'));
      await tester.pumpAndSettle();
      expect(searches, ['خبز']);
    });

    testWidgets('category chips open that root in the rail page', (
      tester,
    ) async {
      final app = await openSearch(tester);

      expect(find.text(SearchStrings.browseCategories), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(CategoryChip),
          matching: find.text('منظفات'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CategoryRail), findsOneWidget);
      expect(app.path, '/categories/browse');
      final selected = tester
          .widgetList<CategoryRailItem>(find.byType(CategoryRailItem))
          .where((item) => item.selected)
          .single;
      expect(selected.node.slug, 'cleaning');
      // Back lands on «كل الفئات».
      await tester.tap(find.byTooltip(SearchStrings.back));
      await tester.pumpAndSettle();
      expect(find.byType(CategoriesLandingScreen), findsOneWidget);
    });

    final recentRows = find.byWidgetPredicate(
      (w) => w is Text && RegExp(r'^بحث \d+$').hasMatch(w.data ?? ''),
    );

    List<Map<String, dynamic>> miniProducts() => [
      {
        ..._card(11),
        'compare_at_syp': 10000,
        'discount_percent': 20,
        'price_syp': 8000,
      },
      _card(12),
      _card(13),
    ];

    Future<GoRouterHandle> openIdle(
      WidgetTester tester, {
      int recents = 0,
      int history = 0,
      bool recommended = true,
    }) async {
      final app = await _pumpApp(
        tester,
        await _prefs(),
        transport: _transport(products: recommended ? miniProducts() : []),
      );
      for (var i = 1; i <= recents; i++) {
        await app.container.read(recentSearchesProvider.notifier).add('بحث $i');
      }
      for (var i = 1; i <= history; i++) {
        await app.container
            .read(browsingHistoryProvider.notifier)
            .record(_entry(i));
      }
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      return app;
    }

    testWidgets(
      'sections follow the round-1 order, with the new shelves last',
      (tester) async {
        await openIdle(tester, recents: 4, history: 2);

        expect(find.text(SearchStrings.historyTitle), findsOneWidget);
        expect(find.text(SearchStrings.clearHistory), findsOneWidget);
        expect(find.text(SearchStrings.showMore), findsNothing);
        expect(recentRows, findsNWidgets(4));
        final order = [
          _y(tester, find.text(SearchStrings.historyTitle)),
          _y(tester, find.text('بحث 4')),
          _y(
            tester,
            find.text(SearchStrings.popularTitle, skipOffstage: false),
          ),
          _y(
            tester,
            find.text(SearchStrings.browseCategories, skipOffstage: false),
          ),
          _y(
            tester,
            find.byKey(
              const ValueKey('search-history-shelf'),
              skipOffstage: false,
            ),
          ),
          _y(
            tester,
            find.byKey(
              const ValueKey('recommended-shelf'),
              skipOffstage: false,
            ),
          ),
        ];
        expect(order, orderedEquals([...order]..sort()));
        expect(order.toSet(), hasLength(order.length));
      },
    );

    testWidgets('the flat bar has no magnifier and the new hint', (
      tester,
    ) async {
      await openIdle(tester);

      expect(find.text(SearchStrings.hint), findsOneWidget);
      expect(SearchStrings.hint, 'البحث عن ماركة، أو منتج، أو فئة');
      expect(find.byIcon(Icons.search), findsNothing);
      expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    });

    testWidgets('five recents show four, then «عرض المزيد» reveals all', (
      tester,
    ) async {
      await openIdle(tester, recents: 5);

      expect(find.text(SearchStrings.historyTitle), findsOneWidget);
      expect(find.text(SearchStrings.clearHistory), findsOneWidget);
      expect(recentRows, findsNWidgets(4));
      final more = find.byKey(const ValueKey('search-show-more'));
      expect(more, findsOneWidget);
      expect(tester.getSize(more).height, 56);
      expect(find.text(SearchStrings.showMore), findsOneWidget);
      expect(find.text('بحث 1'), findsNothing);

      await tester.tap(more);
      await tester.pumpAndSettle();
      expect(recentRows, findsNWidgets(5));
      expect(find.text('بحث 1'), findsOneWidget);
      expect(more, findsNothing);
    });

    testWidgets('four recents show no «عرض المزيد»', (tester) async {
      await openIdle(tester, recents: 4);
      expect(recentRows, findsNWidgets(4));
      expect(find.text(SearchStrings.showMore), findsNothing);
    });

    testWidgets('«مسح» asks before clearing', (tester) async {
      await openIdle(tester, recents: 4);

      final row = tester.getSize(
        find
            .ancestor(of: find.text('بحث 4'), matching: find.byType(InkWell))
            .first,
      );
      expect(row.height, 55);

      await tester.tap(find.text(SearchStrings.clearHistory));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.clearHistoryConfirm), findsOneWidget);
      await tester.tap(find.text(DooryStrings.cancel));
      await tester.pumpAndSettle();
      expect(recentRows, findsNWidgets(4));

      await tester.tap(find.text(SearchStrings.clearHistory));
      await tester.pumpAndSettle();
      await tester.tap(find.text(SearchStrings.historyDelete));
      await tester.pumpAndSettle();
      expect(recentRows, findsNothing);
      expect(find.text(SearchStrings.historyTitle), findsNothing);
    });

    testWidgets('the history shelf: thumbnails, newest first, links', (
      tester,
    ) async {
      final app = await openIdle(tester, history: 12);

      final shelf = find.byKey(const ValueKey('search-history-shelf'));
      expect(
        find.descendant(
          of: shelf,
          matching: find.text(SearchStrings.browsingHistory),
        ),
        findsOneWidget,
      );
      // At most 10, newest first, image only (no names).
      final thumbs = find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey &&
            '${(w.key! as ValueKey).value}'.startsWith('history-thumb-'),
        skipOffstage: false,
      );
      expect(thumbs, findsAtLeastNWidgets(5));
      final list = tester.widget<ListView>(
        find.descendant(of: shelf, matching: find.byType(ListView)),
      );
      expect(
        (list.childrenDelegate as SliverChildBuilderDelegate)
            .estimatedChildCount,
        19, // 10 thumbnails + 9 separators
      );
      final first = find.byKey(const ValueKey('history-thumb-12'));
      expect(tester.getSize(first), const Size(70, 105));
      expect(find.byKey(const ValueKey('history-thumb-2')), findsNothing);
      expect(find.text('منتج 12'), findsNothing);

      await tester.tap(first);
      await tester.pumpAndSettle();
      expect(app.path, '/p/12-item');
    });

    testWidgets('«عرض الكل» on the shelf opens the history page', (
      tester,
    ) async {
      final app = await openIdle(tester, history: 2);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('search-history-shelf')),
          matching: find.byType(ViewAllLink),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BrowsingHistoryScreen), findsOneWidget);
      expect(app.path, '/history');
    });

    testWidgets('the history shelf is hidden when nothing was opened', (
      tester,
    ) async {
      await openIdle(tester);
      expect(find.byKey(const ValueKey('search-history-shelf')), findsNothing);
    });

    testWidgets('«قطع لك خصيصًا»: red label, 98×145 cards, discount strip', (
      tester,
    ) async {
      await openIdle(tester);

      final shelf = find.byKey(const ValueKey('recommended-shelf'));
      expect(find.text(SearchStrings.recommendedTitle), findsOneWidget);
      final label = tester.widget<Text>(
        find.descendant(
          of: shelf,
          matching: find.text(SearchStrings.unsupported),
        ),
      );
      expect(label.style?.color, DooryColors.backendMissing);
      expect(label.style?.fontSize, 11);
      final cards = find.descendant(
        of: shelf,
        matching: find.byWidgetPredicate(
          (w) => w is SizedBox && w.width == 98 && w.height == 145,
        ),
      );
      expect(cards, findsNWidgets(3));
      // Only the discounted card has the strip.
      expect(find.text(SearchStrings.discountStrip(20)), findsOneWidget);
      final strip = tester.getSize(
        find
            .ancestor(
              of: find.text(SearchStrings.discountStrip(20)),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(strip.height, 16);
    });

    testWidgets('«قطع لك خصيصًا» is hidden when the sample list is empty', (
      tester,
    ) async {
      await openIdle(tester, recommended: false);
      expect(find.byKey(const ValueKey('recommended-shelf')), findsNothing);
    });

    testWidgets('«عرض الكل» of the recommended shelf keeps the red label', (
      tester,
    ) async {
      await openIdle(tester);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('recommended-shelf')),
          matching: find.byType(ViewAllLink),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RecommendedCollectionScreen), findsOneWidget);
      expect(find.text(SearchStrings.unsupported), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(3));
    });

    testWidgets('a mini card opens the product page', (tester) async {
      final app = await openIdle(tester);
      await tester.tap(find.text(SearchStrings.discountStrip(20)));
      await tester.pumpAndSettle();
      expect(app.path, '/p/11-item');
    });

    testWidgets('typing shows loading, then rows; the arrow only fills', (
      tester,
    ) async {
      final searches = <String>[];
      await _pumpApp(
        tester,
        await _prefs(),
        transport: _transport(searches: searches),
      );
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'خب');
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const ValueKey('suggestions-loading')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const ValueKey('suggestions-loading')), findsNothing);
      expect(find.text(SearchStrings.relatedTitle), findsOneWidget);

      await tester.tap(find.byTooltip(SearchStrings.fillSuggestion).last);
      await tester.pump(const Duration(milliseconds: 400));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'خبز',
      );
      expect(searches, isEmpty);
    });

    testWidgets('typing something unknown shows the no-match note', (
      tester,
    ) async {
      await _pumpApp(tester, await _prefs());
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'ققققق');
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('suggestions-empty')), findsOneWidget);
    });

    testWidgets('no results shows the note and the home products', (
      tester,
    ) async {
      final prefs = await _prefs();
      await _pumpApp(
        tester,
        prefs,
        transport: _transport(featured: [_card(4), _card(5)]),
      );
      await tester.tap(find.byType(DoorySearchField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'غيرموجود');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.noResultsFor('غيرموجود')), findsOneWidget);
      expect(find.byType(ProductCard), findsWidgets);
    });
  });

  group('browsing history', () {
    test('records newest first, de-dupes, and caps at 30', () async {
      final prefs = await _prefs();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);
      final history = container.read(browsingHistoryProvider.notifier);

      for (var id = 1; id <= 35; id++) {
        await history.record(_entry(id));
      }
      var items = container.read(browsingHistoryProvider);
      expect(items, hasLength(30));
      expect(items.first.id, 35);
      expect(items.last.id, 6);

      await history.record(_entry(20));
      items = container.read(browsingHistoryProvider);
      expect(items, hasLength(30));
      expect(items.first.id, 20);
      expect(items.where((item) => item.id == 20), hasLength(1));

      // It survives a restart.
      final again = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(again.dispose);
      expect(again.read(browsingHistoryProvider).first.id, 20);
      expect(again.read(browsingHistoryProvider), hasLength(30));

      await history.clear();
      expect(container.read(browsingHistoryProvider), isEmpty);
      expect(prefs.getString(BrowsingHistory.storageKey), '[]');
    });

    testWidgets('opening a product page saves a v2 snapshot', (tester) async {
      final prefs = await _prefs();
      final app = await _pumpApp(tester, prefs);

      app.go('/p/7-item');
      await tester.pumpAndSettle();
      app.go('/p/9-item');
      await tester.pumpAndSettle();

      final items = app.container.read(browsingHistoryProvider);
      expect([for (final item in items) item.id], [9, 7]);
      final first = items.first;
      expect(first.card.name, 'منتج 9');
      expect(first.card.photoUrl, contains('/9/card.webp'));
      expect(first.categoryId, 12);
      expect(first.categoryName, 'زيوت وسمون');
      expect(first.viewedPriceSyp, 42000);
      expect(first.viewedAt, isNotNull);
      // A deep link has no tapped card: no struck price, discount, or brand.
      expect(first.card.compareAtSyp, isNull);
      expect(first.card.discountPercent, isNull);
      expect(first.card.brandName, isNull);
      expect(BrowsingHistory.storageKey, endsWith('.v2'));
      expect(prefs.getString(BrowsingHistory.storageKey), contains('"id":9'));
      expect(
        prefs.getString(BrowsingHistory.storageKey),
        contains('"category_id":12'),
      );
    });

    test('a detail snapshot takes discount and brand from the tapped card', () {
      const detail = ProductDetailModel(
        id: 5,
        slug: '5-item',
        name: 'منتج 5',
        priceSyp: 8000,
        categoryId: 12,
        categoryName: 'زيوت وسمون',
      );
      const tapped = ProductCardModel(
        id: 5,
        slug: '5-item',
        name: 'منتج 5',
        priceSyp: 8000,
        compareAtSyp: 10000,
        discountPercent: 20,
        brandName: 'ماركة',
        brandVerified: true,
      );
      final withCard = HistoryEntry.fromDetail(detail, tapped: tapped);
      expect(withCard.card.compareAtSyp, 10000);
      expect(withCard.card.discountPercent, 20);
      expect(withCard.card.brandName, 'ماركة');
      expect(withCard.card.brandVerified, isTrue);
      // A card of another product is ignored.
      final other = HistoryEntry.fromDetail(
        detail,
        tapped: const ProductCardModel(
          id: 6,
          slug: '6-item',
          name: 'آخر',
          compareAtSyp: 99,
        ),
      );
      expect(other.card.compareAtSyp, isNull);
    });

    test(
      'v1 entries load (no category, price, or time) and migrate on save',
      () async {
        final v1 = jsonEncode([
          {'id': 3, 'slug': '3-item', 'name': 'قديم 3', 'price_syp': 1000},
          {'id': 'bad'},
          {'id': 2, 'slug': '2-item', 'name': 'قديم 2'},
        ]);
        final prefs = await _prefs({BrowsingHistory.legacyStorageKey: v1});
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        final items = container.read(browsingHistoryProvider);
        expect([for (final e in items) e.id], [3, 2]);
        expect(items.first.categoryId, isNull);
        expect(items.first.viewedPriceSyp, isNull);
        expect(items.first.viewedAt, isNull);
        expect(items.first.card.name, 'قديم 3');

        await container
            .read(browsingHistoryProvider.notifier)
            .record(_entry(9));
        expect(prefs.getString(BrowsingHistory.legacyStorageKey), isNull);
        final saved =
            jsonDecode(prefs.getString(BrowsingHistory.storageKey)!) as List;
        expect(saved, hasLength(3));
        expect((saved.first as Map)['id'], 9);
        expect((saved[1] as Map)['category_id'], isNull);
      },
    );

    test('clearing writes v2 so a v1 list does not come back', () async {
      final prefs = await _prefs({
        BrowsingHistory.legacyStorageKey: jsonEncode([
          {'id': 3, 'name': 'قديم'},
        ]),
      });
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);
      await container.read(browsingHistoryProvider.notifier).clear();
      final again = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(again.dispose);
      expect(again.read(browsingHistoryProvider), isEmpty);
    });
  });

  group('history page', () {
    Future<GoRouterHandle> openHistory(
      WidgetTester tester,
      List<HistoryEntry> entries, {
      bool enabled = true,
      FakeTransport? transport,
    }) async {
      final app = await _pumpApp(
        tester,
        await _prefs({if (!enabled) browsingHistoryEnabledKey: false}),
        transport: transport,
      );
      for (final entry in entries) {
        await app.container
            .read(browsingHistoryProvider.notifier)
            .record(entry);
      }
      app.go('/account/history');
      await tester.pumpAndSettle();
      return app;
    }

    final three = [
      _entry(
        1,
        categoryId: 12,
        categoryName: 'زيوت وسمون',
        viewedPriceSyp: 50000,
        compareAtSyp: 9000,
        discountPercent: 45,
        rating: 4.5,
      ),
      _entry(2, categoryId: 5, categoryName: 'منظفات', viewedPriceSyp: 42000),
      _entry(3, categoryId: 12, categoryName: 'زيوت وسمون'),
    ];

    testWidgets('lists rows newest first with the Trendyol row content', (
      tester,
    ) async {
      await openHistory(tester, three);

      expect(find.text(SearchStrings.browsingHistory), findsOneWidget);
      expect(find.byType(HistoryRowCard), findsNWidgets(3));
      expect(find.byType(ProductCard), findsNothing);
      expect(
        _y(tester, find.text('منتج 3')),
        lessThan(_y(tester, find.text('منتج 2'))),
      );
      expect(
        _y(tester, find.text('منتج 2')),
        lessThan(_y(tester, find.text('منتج 1'))),
      );

      final title = tester.widget<Text>(find.text('منتج 3'));
      expect(title.style?.color, DooryColors.textSecondary);
      expect(title.style?.fontSize, 14);
      expect(title.maxLines, 1);
      // Image 82×116 at the start.
      expect(
        tester.getSize(find.byKey(const ValueKey('history-row-image')).first),
        const Size(82, 116),
      );
      // Discount badge, struck old price, and the rating row on row 1 only.
      expect(find.byKey(const ValueKey('history-row-badge')), findsOneWidget);
      expect(find.text(CardStrings.discountBadge(45)), findsOneWidget);
      expect(find.byKey(const ValueKey('history-row-struck')), findsOneWidget);
      expect(find.text(CardStrings.reviewCount(12)), findsOneWidget);
      expect(find.byIcon(Icons.star), findsWidgets);
      // The add-to-cart button is 113×33 at least.
      final button = tester.getSize(
        find.byKey(const ValueKey('history-row-add')).first,
      );
      expect(button.width, greaterThanOrEqualTo(113));
      expect(button.height, 33);
      expect(find.text(DooryStrings.addToCart), findsNWidgets(3));
      // Unsupported coupon line / ribbon are not drawn.
      expect(find.text('تم تطبيق الكوبون'), findsNothing);
      expect(find.text('العروض المميزة'), findsNothing);
    });

    testWidgets('the switch card, «حذف الكل» in the bar, and the info dialog', (
      tester,
    ) async {
      await openHistory(tester, three);

      expect(
        tester
            .getSize(find.byKey(const ValueKey('history-switch-card')))
            .height,
        48,
      );
      expect(find.text(SearchStrings.historySwitchLabel), findsOneWidget);
      expect(find.text(SearchStrings.historyDeleteAll), findsOneWidget);
      expect(find.text(SearchStrings.clearHistory), findsNothing);

      await tester.tap(find.byKey(const ValueKey('history-info')));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.historyInfoTitle), findsOneWidget);
      expect(find.text(SearchStrings.historyInfoBody), findsOneWidget);
      final note = tester.widget<Text>(
        find.byKey(const ValueKey('history-info-local-note')),
      );
      expect(note.style?.color, DooryColors.backendMissing);
      expect(note.style?.fontSize, 11);
      await tester.tap(find.text(DooryStrings.close));
      await tester.pumpAndSettle();
    });

    testWidgets('«حذف الكل» asks, keeps on cancel, and empties on delete', (
      tester,
    ) async {
      await openHistory(tester, three);

      await tester.tap(find.text(SearchStrings.historyDeleteAll));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.historyClearTitle), findsOneWidget);
      expect(find.text(SearchStrings.historyClearBody), findsOneWidget);
      final note = tester.widget<Text>(
        find.byKey(const ValueKey('history-local-only-note')),
      );
      expect(note.style?.color, DooryColors.backendMissing);

      await tester.tap(find.text(DooryStrings.cancel));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryRowCard), findsNWidgets(3));

      await tester.tap(find.text(SearchStrings.historyDeleteAll));
      await tester.pumpAndSettle();
      await tester.tap(find.text(SearchStrings.historyDelete));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryRowCard), findsNothing);
      expect(find.text(SearchStrings.historyEmpty), findsOneWidget);
      expect(find.text(SearchStrings.historyEmptyHint), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      // Nothing left to delete; the switch card stays.
      expect(find.text(SearchStrings.historyDeleteAll), findsNothing);
      expect(find.byKey(const ValueKey('history-switch-card')), findsOneWidget);
    });

    testWidgets('the switch stops recording, keeps saved items, asks first', (
      tester,
    ) async {
      final app = await openHistory(tester, three);
      final enabled = browsingHistoryEnabledProvider;
      expect(app.container.read(enabled), isTrue);

      // Cancel keeps it on.
      await tester.tap(find.byKey(const ValueKey('history-switch')));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.historySwitchOffTitle), findsOneWidget);
      expect(find.text(SearchStrings.historySwitchOffBody), findsOneWidget);
      await tester.tap(find.text(DooryStrings.cancel));
      await tester.pumpAndSettle();
      expect(app.container.read(enabled), isTrue);
      expect(find.byKey(const ValueKey('history-paused')), findsNothing);

      // Confirm turns it off, with a note under the card.
      await tester.tap(find.byKey(const ValueKey('history-switch')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(SearchStrings.historySwitchOff));
      await tester.pumpAndSettle();
      expect(app.container.read(enabled), isFalse);
      expect(find.text(SearchStrings.historyPaused), findsOneWidget);
      expect(find.byType(HistoryRowCard), findsNWidgets(3));
      expect(
        app.container
            .read(sharedPreferencesProvider)
            .getBool(browsingHistoryEnabledKey),
        isFalse,
      );

      // Opening a product no longer records; saved items stay.
      app.go('/p/9-item');
      await tester.pumpAndSettle();
      expect(
        [for (final e in app.container.read(browsingHistoryProvider)) e.id],
        [3, 2, 1],
      );

      // Back on: no dialog, recording resumes.
      app.go('/account/history');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('history-switch')));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.historySwitchOffTitle), findsNothing);
      expect(app.container.read(enabled), isTrue);
      expect(find.text(SearchStrings.historyPaused), findsNothing);
      app.go('/p/10-item');
      await tester.pumpAndSettle();
      expect(app.container.read(browsingHistoryProvider).first.id, 10);
    });

    testWidgets('a paused history stays paused after a restart', (
      tester,
    ) async {
      await openHistory(tester, three, enabled: false);
      expect(find.text(SearchStrings.historyPaused), findsOneWidget);
    });

    testWidgets('the category chip filters by category with counts', (
      tester,
    ) async {
      await openHistory(tester, three);

      await tester.tap(find.byKey(const ValueKey('history-chip-category')));
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.categoryAll), findsOneWidget);
      expect(find.text('(3)'), findsOneWidget);
      expect(find.text('(2)'), findsOneWidget);
      expect(find.text('(1)'), findsOneWidget);

      await tester.tap(find.text('منظفات'));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryRowCard), findsOneWidget);
      expect(find.text('منتج 2'), findsOneWidget);
      // The chip shows the chosen category.
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('history-chip-category')),
          matching: find.text('منظفات'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'the price-drop chip keeps only entries priced below the viewed price',
      (tester) async {
        await openHistory(tester, three);

        await tester.tap(find.byKey(const ValueKey('history-chip-drop')));
        await tester.pumpAndSettle();
        // Live price is 42,000: entry 1 (viewed at 50,000) dropped, entry 2
        // (42,000) did not, entry 3 has no stored price.
        expect(find.byType(HistoryRowCard), findsOneWidget);
        expect(find.text('منتج 1'), findsOneWidget);
        expect(find.text(CardStrings.discountBadge(16)), findsOneWidget);
        expect(find.text(formatSypDigits(50000)), findsOneWidget);
        expect(find.text(formatSyp(42000)), findsOneWidget);

        // Chip is selected: primarySubtle fill.
        final chip = tester.widget<Material>(
          find
              .descendant(
                of: find.byKey(const ValueKey('history-chip-drop')),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(chip.color, DooryColors.primarySubtle);

        // With a category that has no dropped product: empty state and a way out.
        await tester.tap(find.byKey(const ValueKey('history-chip-category')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('منظفات'));
        await tester.pumpAndSettle();
        expect(find.text(SearchStrings.filteredEmpty), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('history-clear-filter')));
        await tester.pumpAndSettle();
        expect(find.byType(HistoryRowCard), findsNWidgets(3));
      },
    );

    testWidgets('trash removes a row at once; «تراجع» puts it back', (
      tester,
    ) async {
      await openHistory(tester, three);

      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('history-row-2')),
          matching: find.byKey(const ValueKey('history-row-delete')),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const ValueKey('history-row-2')), findsNothing);
      expect(find.text(SearchStrings.rowDeleted), findsOneWidget);

      await tester.tap(find.text(ShopStrings.undo));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('history-row-2')), findsOneWidget);
      expect(find.byType(HistoryRowCard), findsNWidgets(3));
      // Back at its place, between 3 and 1.
      expect(
        _y(tester, find.text('منتج 3')),
        lessThan(_y(tester, find.text('منتج 2'))),
      );
      expect(
        _y(tester, find.text('منتج 2')),
        lessThan(_y(tester, find.text('منتج 1'))),
      );
    });

    testWidgets('the heart saves to favourites', (tester) async {
      final app = await openHistory(tester, three);

      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('history-row-1')),
          matching: find.byKey(const ValueKey('history-row-favorite')),
        ),
      );
      await tester.pumpAndSettle();
      expect(app.container.read(favoritesProvider).map((c) => c.id), [1]);
      expect(find.text(ShopStrings.addedToFavorites), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('«إضافة إلى السلة» adds one unit and offers «عرض السلة»', (
      tester,
    ) async {
      final app = await openHistory(tester, [_entry(5)]);

      await tester.tap(find.byKey(const ValueKey('history-row-add')));
      await tester.pumpAndSettle();
      expect(find.text(ShopStrings.addedToCart(1)), findsOneWidget);
      expect(find.text(ShopStrings.viewCart), findsOneWidget);
      expect(app.container.read(cartCountProvider), 1);
    });

    testWidgets(
      'an unavailable product shows «غير متوفر» instead of the button',
      (tester) async {
        await openHistory(tester, [_entry(5, canPurchase: false)]);

        expect(find.byKey(const ValueKey('history-row-add')), findsNothing);
        expect(
          find.byKey(const ValueKey('history-row-unavailable')),
          findsOneWidget,
        );
        expect(find.text(SearchStrings.rowUnavailable), findsOneWidget);
      },
    );

    testWidgets(
      'a row opens the product and keeps the tapped card’s discount',
      (tester) async {
        final app = await openHistory(tester, three);

        await tester.tap(find.text('منتج 1'));
        await tester.pumpAndSettle();
        expect(app.path, '/account/p/1-item');
        final first = app.container.read(browsingHistoryProvider).first;
        expect(first.id, 1);
        expect(first.card.compareAtSyp, 9000);
        expect(first.card.discountPercent, 45);
      },
    );

    testWidgets('Home «شاهدته مؤخرًا» «عرض الكل» opens the local history', (
      tester,
    ) async {
      final app = await _pumpApp(
        tester,
        await _prefs(),
        transport: _transport(recentlyViewed: [_card(21), _card(22)]),
      );
      final shelf = find.ancestor(
        of: find.text(DooryStrings.recentlyViewed),
        matching: find.byType(ProductShelf),
      );
      await tester.ensureVisible(shelf.first);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: shelf.first,
          matching: find.text(DooryStrings.viewAll),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BrowsingHistoryScreen), findsOneWidget);
      expect(app.path, '/history');
    });

    testWidgets('the empty state sends the shopper to Home', (tester) async {
      final app = await _pumpApp(tester, await _prefs());
      app.go('/account/history');
      await tester.pumpAndSettle();
      expect(find.text(SearchStrings.historyEmpty), findsOneWidget);

      await tester.tap(find.text(SearchStrings.startShopping));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(app.path, '/');
    });

    testWidgets('the Account list entry opens the history page', (
      tester,
    ) async {
      final app = await _pumpApp(tester, await _prefs());
      await tester.tap(find.text(DooryStrings.tabAccount));
      await tester.pumpAndSettle();

      await tester.tap(find.text(SearchStrings.browsingHistory));
      await tester.pumpAndSettle();
      expect(find.byType(BrowsingHistoryScreen), findsOneWidget);
      expect(app.path, '/account/history');
    });
  });
}
