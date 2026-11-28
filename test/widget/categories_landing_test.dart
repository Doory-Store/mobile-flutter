import 'package:cached_network_image/cached_network_image.dart';
import 'package:doory_mobile/app/app.dart';
import 'package:doory_mobile/app/router.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/chrome.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/categories/categories_landing_screen.dart';
import 'package:doory_mobile/features/categories/category_rail.dart';
import 'package:flutter/services.dart';
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
  {'id': 11, 'name': 'حبوب وبقوليات', 'slug': 'grocery-grains', 'parent_id': 3},
  {'id': 12, 'name': 'زيوت وسمون', 'slug': 'grocery-oil', 'parent_id': 3},
  {'id': 7, 'name': 'منظفات', 'slug': 'cleaning', 'parent_id': null},
  {'id': 8, 'name': 'عناية شخصية', 'slug': 'care', 'parent_id': null},
];

FakeTransport _transport() => FakeTransport((path, query) async {
  return switch (path) {
    '/home' => {'featured': [], 'latest': []},
    '/categories' => _categories,
    '/meta/status' => {'maintenance_active': false},
    '/products' => {
      'data': [],
      'meta': {'page': 1, 'per_page': 24, 'total': 0, 'last_page': 1},
    },
    _ => throw const ApiException(ApiFailureKind.notFound, 'no'),
  };
});

Future<SharedPreferences> _prefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final prefs = await _prefs();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        apiTransportProvider.overrideWith((ref) => _transport()),
        appConfigProvider.overrideWithValue(_config),
      ],
      child: const DooryApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(DooryStrings.tabCategories));
  await tester.pumpAndSettle();
}

String? _selectedRail(WidgetTester tester) {
  final selected = tester
      .widgetList<CategoryRailItem>(find.byType(CategoryRailItem))
      .where((item) => item.selected);
  return selected.isEmpty ? null : selected.single.node.slug;
}

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

  testWidgets('landing shows the header and one card per root, no rail', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text(DooryStrings.allCategories), findsOneWidget);
    expect(find.byType(CategoryLandingCard), findsNWidgets(3));
    expect(find.text('بقالة'), findsOneWidget);
    expect(find.text('منظفات'), findsOneWidget);
    // Children are not cards, and the rail is not the tab root any more.
    expect(find.text('زيوت وسمون'), findsNothing);
    expect(find.byType(CategoryRail), findsNothing);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    // «جديد» stays hidden until the server sends a flag.
    expect(find.text(DooryStrings.newBadge), findsNothing);

    final card = tester.getSize(find.byType(CategoryLandingCard).first);
    expect(card.height, 87);
    expect(card.width, closeTo((390 - 48) / 2, 0.5));
  });

  testWidgets('tapping a card opens the rail with that root selected', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('منظفات'));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryRail), findsOneWidget);
    expect(_selectedRail(tester), 'cleaning');
  });

  testWidgets(
    'a child slug selects its parent, an unknown slug the first root',
    (tester) async {
      await _pumpApp(tester);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(DooryApp)),
      ).read(routerProvider);

      router.go('/categories/browse?root=grocery-oil');
      await tester.pumpAndSettle();
      expect(_selectedRail(tester), 'grocery');

      router.go('/categories/browse?root=care');
      await tester.pumpAndSettle();
      expect(_selectedRail(tester), 'care');

      router.go('/categories/browse?root=nope');
      await tester.pumpAndSettle();
      expect(_selectedRail(tester), 'grocery');
    },
  );

  testWidgets('back from the rail returns to the landing', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('منظفات'));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryRail), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryRail), findsNothing);
    expect(find.text(DooryStrings.allCategories), findsOneWidget);
    expect(find.byType(CategoryLandingCard), findsNWidgets(3));
  });

  testWidgets('the deep link /categories/c/:slug still opens the listing', (
    tester,
  ) async {
    await _pumpApp(tester);
    final router = ProviderScope.containerOf(
      tester.element(find.byType(DooryApp)),
    ).read(routerProvider);

    router.go('/categories/c/grocery');
    await tester.pumpAndSettle();
    expect(find.byType(CategoryRail), findsNothing);
    expect(find.byType(CategoryLandingCard), findsNothing);
    expect(find.byType(DoorySearchField), findsOneWidget);
  });

  testWidgets('a card without an image shows the title only', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: dooryTheme(),
        locale: const Locale('ar'),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 181,
                  height: 87,
                  child: CategoryLandingCard(
                    node: const CategoryNode(
                      id: 1,
                      name: 'منظفات',
                      slug: 'cleaning',
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('منظفات'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('a failed image falls back to the title only', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: dooryTheme(),
        locale: const Locale('ar'),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 181,
                  height: 87,
                  child: CategoryLandingCard(
                    node: const CategoryNode(
                      id: 1,
                      name: 'منظفات',
                      slug: 'cleaning',
                      imageUrl: 'https://invalid.invalid/x.webp',
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    // The cache manager can't hit the network in tests, so call the error
    // builder directly: a failed image renders nothing, the title stays.
    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    final fallback = image.errorWidget!(
      tester.element(find.byType(CachedNetworkImage)),
      image.imageUrl,
      Exception('404'),
    );
    expect(fallback, isA<SizedBox>());
    expect((fallback as SizedBox).child, isNull);
    expect(fallback.key, const ValueKey('landing-card-no-image'));
    expect(find.text('منظفات'), findsOneWidget);
  });
}
