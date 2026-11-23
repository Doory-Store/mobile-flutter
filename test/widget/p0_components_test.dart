import 'package:doory_mobile/app/router.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/widgets/bottom_tab_bar.dart';
import 'package:doory_mobile/core/widgets/doory_app_bar.dart';
import 'package:doory_mobile/core/widgets/doory_button.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/doory_chip.dart';
import 'package:doory_mobile/core/widgets/doory_sheet.dart';
import 'package:doory_mobile/core/widgets/doory_image.dart';
import 'package:doory_mobile/core/widgets/list_row.dart';
import 'package:doory_mobile/core/widgets/price_block.dart';
import 'package:doory_mobile/core/widgets/product_cards.dart';
import 'package:doory_mobile/core/widgets/search_pill.dart';
import 'package:doory_mobile/features/debug/component_catalog_screen.dart';
import 'package:doory_mobile/features/shell/tab_root_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/p0_harness.dart';

void main() {
  testWidgets('search pill is 38 dp and the app bar is 56', (tester) async {
    await pumpDoory(
      tester,
      const Scaffold(
        appBar: DooryAppBar(
          variant: DooryAppBarVariant.search,
          search: SearchPill(text: 'قميص', mode: SearchPillMode.active),
        ),
        body: SizedBox.shrink(),
      ),
    );
    expect(tester.getSize(find.byType(DooryAppBar)).height, 56);
    expect(tester.getSize(find.byKey(SearchPill.visualKey)).height, 38);
    expect(find.text('قميص'), findsOneWidget);
  });

  testWidgets('button faces keep the measured heights', (tester) async {
    await pumpDoory(
      tester,
      Scaffold(
        body: Column(
          children: [
            for (final size in DooryButtonSize.values)
              DooryButton(label: 'متابعة', size: size, onPressed: () {}),
          ],
        ),
      ),
    );
    final faces = tester.widgetList<DooryButtonFace>(
      find.byType(DooryButtonFace),
    );
    expect(faces.map((face) => face.height).toList(), [36, 40, 45, 48, 53]);
  });

  testWidgets('chip paint is 30 dp and a disabled chip does not fire', (
    tester,
  ) async {
    var taps = 0;
    await pumpDoory(
      tester,
      Scaffold(
        body: DooryChip(label: 'قطن', enabled: false, onTap: () => taps++),
      ),
    );
    expect(tester.getSize(find.byKey(DooryChip.visualKey)).height, 30);
    expect(tester.getSize(find.byType(DooryChip)).height, 48);
    await tester.tap(find.text('قطن'));
    expect(taps, 0);
  });

  testWidgets('list chevron follows the reading direction', (tester) async {
    await pumpDoory(
      tester,
      Scaffold(
        body: ListRow(title: 'طلباتي', onTap: () {}),
      ),
    );
    expect(tester.getSize(find.byType(ListRow)).height, 56);
    final icon = tester.widget<Icon>(find.byIcon(Icons.chevron_right));
    expect(icon.icon?.matchTextDirection, isTrue);
  });

  testWidgets('a missing price takes no space and a card keeps 2:3', (
    tester,
  ) async {
    var opens = 0;
    var hearts = 0;
    await pumpDoory(
      tester,
      Scaffold(
        body: Column(
          children: [
            const PriceBlock(priceSyp: null),
            SizedBox(
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
                onTap: () => opens++,
                onFavorite: () => hearts++,
              ),
            ),
          ],
        ),
      ),
    );
    final hidden = find.byWidgetPredicate(
      (widget) => widget is PriceBlock && widget.priceSyp == null,
    );
    expect(tester.getSize(hidden).height, 0);
    final image = tester.getSize(find.byType(DooryImage));
    expect(image.width, closeTo(193.5, 1));
    expect(image.height / image.width, closeTo(1.5, 0.02));
    expect(find.text('خصم 17٪'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border));
    expect(hearts, 1);
    expect(opens, 0);
    await tester.tap(find.textContaining('قميص قطني'));
    expect(opens, 1);
  });

  testWidgets('rail cards stay 137 dp and large text does not overflow', (
    tester,
  ) async {
    await pumpDoory(
      tester,
      const Scaffold(
        body: ProductCardRail(
          ref: '1002',
          name: 'فستان يومي بقصة مستقيمة وطويلة جدًا للاختبار',
          brand: 'بيت الورد',
          priceSyp: 89000,
        ),
      ),
      textScale: 1.3,
    );
    expect(tester.getSize(find.byType(ProductCardRail)).width, 137);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab bar is 56 dp and the cart badge caps at 99+', (
    tester,
  ) async {
    await pumpDoory(
      tester,
      Scaffold(
        body: const SizedBox.expand(),
        bottomNavigationBar: BottomTabBar(
          current: DooryTab.cart,
          cartCount: 120,
          onSelect: (_) {},
        ),
      ),
    );
    expect(tester.getSize(find.byType(BottomTabBar)).height, 56);
    expect(find.text('\u206699+\u2069'), findsOneWidget);
    expect(find.text(DooryStrings.tabHome), findsOneWidget);
  });

  testWidgets('sort sheet opens over the catalog route in debug', (
    tester,
  ) async {
    expect(debugRoutes(), isNotEmpty);
    await pumpDoory(tester, const ComponentCatalogScreen());
    final sheet = find.byKey(ComponentCatalogScreen.sheetKey);
    for (var i = 0; i < 12 && sheet.evaluate().isEmpty; i++) {
      await tester.drag(
        find.byKey(ComponentCatalogScreen.listKey),
        const Offset(0, -450),
      );
      await tester.pump();
    }
    await tester.tap(find.widgetWithText(DooryButton, 'الفرز'));
    await tester.pumpAndSettle();
    expect(find.text('الأنسب'), findsWidgets);
    expect(find.text('الأقل سعراً'), findsWidgets);
  });

  testWidgets('a two-line row grows at 1.3x instead of overflowing', (
    tester,
  ) async {
    await pumpDoory(
      tester,
      const Scaffold(
        body: ListRow(title: 'الماركة', value: 'نور'),
      ),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ListRow)).height, greaterThan(56));
  });

  testWidgets('the chip target includes the padding above the pill', (
    tester,
  ) async {
    var taps = 0;
    await pumpDoory(
      tester,
      Scaffold(
        body: DooryChip(label: 'قطن', onTap: () => taps++),
      ),
    );
    final rect = tester.getRect(find.byType(DooryChip));
    await tester.tapAt(rect.topCenter + const Offset(0, 4));
    expect(taps, 1);
  });

  testWidgets('controls announce their label once', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpDoory(
      tester,
      Scaffold(
        body: Column(
          children: [
            DooryChip(label: 'قطن', onTap: () {}),
            DooryButton(label: 'متابعة', onPressed: () {}),
            const ListRow(title: 'الماركة', value: 'نور'),
          ],
        ),
        bottomNavigationBar: BottomTabBar(
          current: DooryTab.cart,
          cartCount: 3,
          onSelect: (_) {},
        ),
      ),
    );
    expect(tester.getSemantics(find.byType(DooryChip)).label, 'قطن');
    expect(tester.getSemantics(find.byType(DooryButton)).label, 'متابعة');
    expect(tester.getSemantics(find.byType(ListRow)).label, 'الماركة، نور');
    expect(
      tester.getSemantics(find.bySemanticsLabel('السلة، 3 منتجات')).label,
      'السلة، 3 منتجات',
    );
    handle.dispose();
  });

  testWidgets('sort rows keep the radio at the start and stay 49 dp', (
    tester,
  ) async {
    await pumpDoory(
      tester,
      const Scaffold(
        body: Column(
          children: [
            ListRow(
              title: 'الأنسب',
              variant: ListRowVariant.radioLeading,
              selected: true,
              showDivider: true,
            ),
            ListRow(
              title: 'حذف',
              trailing: ListRowTrailing.radio,
              selected: true,
            ),
          ],
        ),
      ),
    );
    final leading = find.widgetWithText(ListRow, 'الأنسب');
    final trailing = find.widgetWithText(ListRow, 'حذف');
    expect(tester.getSize(leading).height, 49);
    expect(tester.getSize(trailing).height, 56);
    final leadingRadio = tester.getCenter(
      find.descendant(of: leading, matching: find.byType(DooryRadioMark)),
    );
    final leadingTitle = tester.getCenter(find.text('الأنسب'));
    expect(leadingRadio.dx, greaterThan(leadingTitle.dx));
    final endRadio = tester.getCenter(
      find.descendant(of: trailing, matching: find.byType(DooryRadioMark)),
    );
    final endTitle = tester.getCenter(find.text('حذف'));
    expect(endRadio.dx, lessThan(endTitle.dx));
  });

  testWidgets('the sort sheet header is 49 dp with a 14 dp close glyph', (
    tester,
  ) async {
    await pumpDoory(
      tester,
      const Scaffold(
        body: DoorySheet(
          title: 'الفرز',
          child: ListRow(
            title: 'الأنسب',
            variant: ListRowVariant.radioLeading,
            selected: true,
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(DoorySheet.headerKey)).height, 49);
    expect(tester.widget<Icon>(find.byIcon(Icons.close)).size, 14);
    expect(tester.getSize(find.byType(ListRow)).height, 49);
  });

  testWidgets('app bars start below a 46 dp status bar', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = p0Surface;
    tester.view.padding = const FakeViewPadding(top: 46);
    tester.view.viewPadding = const FakeViewPadding(top: 46);
    addTearDown(tester.view.reset);

    Future<void> pump(Widget home) async {
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dooryTheme(),
          locale: const Locale('ar'),
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
          home: home,
        ),
      );
      await tester.pumpAndSettle();
    }

    await pump(
      const Scaffold(
        appBar: DooryAppBar(title: 'الفئات', showBack: false),
        body: SizedBox.shrink(),
      ),
    );
    expect(tester.getSize(find.byType(DooryAppBar)).height, 102);
    expect(tester.getTopLeft(find.text('الفئات')).dy, greaterThanOrEqualTo(46));

    await pump(const TabRootScreen(tab: DooryTab.home));
    expect(tester.getTopLeft(find.text('دوري')).dy, greaterThanOrEqualTo(46));
  });
}
