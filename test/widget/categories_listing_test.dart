import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/catalog_strings.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/l10n/search_strings.dart';
import 'package:doory_mobile/core/theme/doory_colors.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/chrome.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/categories/categories_screen.dart';
import 'package:doory_mobile/features/categories/category_rail.dart';
import 'package:doory_mobile/features/categories/category_tile_grid.dart';
import 'package:doory_mobile/features/listing/catalog_widgets.dart';
import 'package:doory_mobile/features/listing/listing_screen.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
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

final _categories = [
  {
    'id': 3,
    'name': 'بقالة',
    'slug': 'grocery',
    'parent_id': null,
    'image': 'https://example.test/g.webp',
  },
  {
    'id': 11,
    'name': 'حبوب وبقوليات',
    'slug': 'grocery-grains',
    'parent_id': 3,
    'image': 'https://example.test/grains.webp',
  },
  {
    'id': 12,
    'name': 'زيوت وسمون',
    'slug': 'grocery-oil',
    'parent_id': 3,
    'image': 'https://example.test/oil.webp',
  },
  {'id': 7, 'name': 'منظفات', 'slug': 'cleaning', 'parent_id': null},
];

Map<String, dynamic> _product(int id, String name) => {
  'id': id,
  'slug': '$id',
  'name': name,
  'price_syp': 15000,
  'available': true,
  'can_purchase': true,
  'store_name': 'متجر',
};

Future<SharedPreferences> _prefs() {
  SharedPreferences.setMockInitialValues({});
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

FakeTransport _catalogTransport() => FakeTransport((path, query) async {
  if (path == '/categories') return _categories;
  if (path == '/products') {
    final category = query?['category'];
    final items = [
      if (category == null ||
          category == 3 ||
          category == '3' ||
          category == 12 ||
          category == '12')
        _product(521, 'زيت زيتون'),
      if (category == null ||
          category == 3 ||
          category == '3' ||
          category == 11 ||
          category == '11')
        _product(503, 'حمص'),
    ];
    return {
      'data': items,
      'meta': {
        'page': 1,
        'per_page': 24,
        'total': items.length,
        'last_page': 1,
      },
    };
  }
  throw const ApiException(ApiFailureKind.notFound, 'no');
});

void main() {
  testWidgets('categories tab shows a search pill, rail and tiles', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final prefs = await _prefs();
    await tester.pumpWidget(
      _host(prefs, _catalogTransport(), const CategoriesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DoorySearchField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.byType(CategoryRail), findsOneWidget);
    expect(find.text('بقالة'), findsWidgets);
    expect(find.text('زيوت وسمون'), findsOneWidget);
    expect(find.text(DooryStrings.viewAll), findsOneWidget);
    expect(find.byType(ShowAllCategoryTile), findsOneWidget);
  });

  testWidgets('switching the rail shows the selected root tiles', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final prefs = await _prefs();
    await tester.pumpWidget(
      _host(prefs, _catalogTransport(), const CategoriesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('زيوت وسمون'), findsOneWidget);
    await tester.tap(find.text('منظفات'));
    await tester.pumpAndSettle();
    // Cleaning has no children: only «عرض الكل».
    expect(find.text('زيوت وسمون'), findsNothing);
    expect(find.byType(ShowAllCategoryTile), findsOneWidget);
  });

  testWidgets(
    'listing pinned header, chips, unsupported sorts and price filter',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final prefs = await _prefs();
      await tester.pumpWidget(
        _host(prefs, _catalogTransport(), const ListingScreen(slug: 'grocery')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DoorySearchField), findsOneWidget);
      expect(find.textContaining('بقالة'), findsWidgets);
      expect(find.text(CatalogStrings.sort), findsOneWidget);
      expect(find.text(CatalogStrings.filter), findsOneWidget);
      expect(find.text(CatalogStrings.price), findsOneWidget);
      expect(find.text(CatalogStrings.category), findsOneWidget);
      expect(
        find.textContaining('زيت زيتون', findRichText: true),
        findsWidgets,
      );

      await tester.tap(find.text(CatalogStrings.sort));
      await tester.pumpAndSettle();
      expect(find.text(CatalogStrings.sortNewest), findsOneWidget);
      expect(find.text(CatalogStrings.sortRelevance), findsOneWidget);
      expect(find.text(CatalogStrings.unsupported), findsWidgets);

      await tester.tap(find.text(CatalogStrings.sortRelevance));
      await tester.pumpAndSettle();
      // Unsupported row does not close the sheet.
      expect(find.text(CatalogStrings.sortNewest), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text(CatalogStrings.filter));
      await tester.pumpAndSettle();
      expect(find.text(CatalogStrings.brand), findsOneWidget);
      expect(find.text(CatalogStrings.unsupported), findsWidgets);
      expect(find.text(CatalogStrings.showResultsCount(2)), findsOneWidget);
      await tester.tap(find.text(CatalogStrings.price).last);
      await tester.pumpAndSettle();
      expect(find.text(CatalogStrings.minPrice), findsWidgets);
      expect(find.textContaining('25,000'), findsWidgets);
    },
  );

  testWidgets('visual search is not wired', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final prefs = await _prefs();
    await tester.pumpWidget(
      _host(prefs, _catalogTransport(), const CategoriesScreen()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.photo_camera_outlined));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(SearchStrings.visualSearchFeature),
      findsWidgets,
    );
  });

  testWidgets('listing chip bar chips share the same height and border', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final prefs = await _prefs();
    await tester.pumpWidget(
      _host(prefs, _catalogTransport(), const ListingScreen(slug: 'grocery')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DooryFilterChip), findsNWidgets(4));
    expect(
      find.widgetWithText(DooryFilterChip, CatalogStrings.sort),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(DooryFilterChip, CatalogStrings.filter),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(DooryFilterChip, CatalogStrings.price),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(DooryFilterChip, CatalogStrings.category),
      findsOneWidget,
    );

    final boxes = tester
        .renderObjectList<RenderBox>(find.byType(DooryFilterChip))
        .toList();
    expect(boxes, isNotEmpty);
    for (final box in boxes) {
      expect(box.size.height, DooryFilterChip.height);
    }

    final materials = tester
        .widgetList<Material>(
          find.descendant(
            of: find.byType(DooryFilterChip),
            matching: find.byType(Material),
          ),
        )
        .toList();
    expect(materials, hasLength(boxes.length));
    for (final material in materials) {
      expect(material.shape, isA<StadiumBorder>());
      final side = (material.shape! as StadiumBorder).side;
      expect(side.width, DooryFilterChip.borderWidth);
      expect(side.color, DooryColors.border);
    }
  });
}
