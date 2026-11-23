import 'package:doory_mobile/app/app.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/theme/doory_typography.dart';
import 'package:doory_mobile/core/widgets/bottom_tab_bar.dart';
import 'package:doory_mobile/core/widgets/doory_button.dart';
import 'package:doory_mobile/core/widgets/list_row.dart';
import 'package:doory_mobile/core/widgets/doory_wordmark.dart';
import 'package:doory_mobile/core/widgets/product_cards.dart';
import 'package:doory_mobile/core/widgets/screen_states.dart';
import 'package:doory_mobile/core/widgets/search_pill.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/debug/component_catalog_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_transport.dart';
import '../support/p0_harness.dart';

void main() {
  testWidgets('typography scale', (tester) async {
    await pumpDoory(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) {
            final styles = <String, TextStyle>{
              'wordmark': DooryTypography.wordmark(context),
              'toolbar': DooryTypography.toolbarTitle(context),
              'section': DooryTypography.sectionTitle(context),
              'body': DooryTypography.body(context),
              'card': DooryTypography.cardTitle(context),
              'price': DooryTypography.price(context),
              'priceLarge': DooryTypography.priceLarge(context),
              'tab': DooryTypography.tabLabel(
                Theme.of(context).colorScheme.primary,
              ),
            };
            const samples = <String, String>{
              'wordmark': 'دوري',
              'toolbar': 'الرئيسية',
              'section': 'نظرة عامة',
              'body': 'هذا القسم جاهز للعرض',
              'card': 'قميص قطني',
              'price': '1,250 ل.س',
              'priceLarge': '125,000 ل.س',
              'tab': 'السلة',
            };
            return ListView(
              children: [
                for (final entry in styles.entries)
                  Text(samples[entry.key] ?? entry.key, style: entry.value),
              ],
            );
          },
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../golden/p0_typography.png'),
    );
  });

  testWidgets('chrome, cards, and states', (tester) async {
    await pumpDoory(
      tester,
      Scaffold(
        body: ListView(
          children: [
            const DooryWordmark(),
            const DooryWordmark(size: DooryWordmarkSize.display),
            const SearchPill(),
            DooryButton(label: 'متابعة', onPressed: () {}),
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                width: 193.5,
                child: ProductCardVertical(
                  ref: '1001',
                  brand: 'نور',
                  name: 'قميص قطني',
                  image: 'assets/mock/products/1001.jpg',
                  priceSyp: 125000,
                  compareAtSyp: 150000,
                  rating: 4.4,
                  ratingCount: 12,
                  colorCount: 2,
                ),
              ),
            ),
            const SizedBox(
              height: 280,
              child: EmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'سلة مشترياتك',
                message: 'أضف ما يعجبك من المتاجر، ويظهر هنا.',
              ),
            ),
          ],
        ),
      ),
    );
    final context = tester.element(find.byType(ProductCardVertical));
    await tester.runAsync(() async {
      await precacheImage(
        const AssetImage('assets/mock/products/1001.jpg'),
        context,
      );
    });
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../golden/p0_components.png'),
    );
  });

  testWidgets('large text scale', (tester) async {
    await pumpDoory(
      tester,
      const Scaffold(
        body: Align(
          alignment: AlignmentDirectional.topStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DooryWordmark(),
              SearchPill(),
              SizedBox(
                width: 193.5,
                child: ProductCardVertical(
                  ref: '1001',
                  brand: 'نور',
                  name: 'قميص قطني بأكمام طويلة',
                  image: 'assets/mock/products/1001.jpg',
                  priceSyp: 125000,
                  compareAtSyp: 150000,
                  rating: 4.4,
                  ratingCount: 12,
                ),
              ),
              ListRow(title: 'الماركة', value: 'نور'),
            ],
          ),
        ),
      ),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
    final context = tester.element(find.byType(ProductCardVertical));
    await tester.runAsync(() async {
      await precacheImage(
        const AssetImage('assets/mock/products/1001.jpg'),
        context,
      );
    });
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../golden/p0_scale_1_3.png'),
    );
  });

  testWidgets('component catalog top', (tester) async {
    await pumpDoory(tester, const ComponentCatalogScreen());
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../golden/p0_catalog.png'),
    );
  });

  testWidgets('empty home shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final transport = FakeTransport((path, query) async {
      throw const ApiException(ApiFailureKind.notFound, 'no');
    });
    tester.view.physicalSize = p0Surface;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
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
    expect(find.byType(BottomTabBar), findsOneWidget);
    expect(find.text(DooryStrings.sectionReady), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../golden/p0_shell_home.png'),
    );
  });
}
