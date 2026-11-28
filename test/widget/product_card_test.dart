import 'package:doory_mobile/core/format/price_format.dart';
import 'package:doory_mobile/core/l10n/card_strings.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/theme/doory_colors.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/product_card.dart';
import 'package:doory_mobile/core/widgets/product_shelf.dart';
import 'package:doory_mobile/core/widgets/social_proof_ticker.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/features/listing/catalog_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _full = ProductCardModel(
  id: 521,
  slug: '521-oil',
  name: 'زيت زيتون، 1 لتر',
  storeName: 'متجر 1',
  brandName: 'دار المونة',
  brandVerified: true,
  priceSyp: 54000,
  compareAtSyp: 67500,
  discountPercent: 20,
  averageRating: 4.5,
  reviewsCount: 4,
  viewers: ViewerActivity(count: 96, windowHours: 24),
  badgeLabels: ['منتج محلي'],
);

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

Future<void> _pump(WidgetTester tester, Widget child) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        theme: dooryTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

Color? _textColor(WidgetTester tester, Finder finder) {
  final text = tester.widget<Text>(finder);
  return text.style?.color;
}

double _top(WidgetTester tester, Finder finder) => tester.getTopLeft(finder).dy;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _ensureCairo();
  });

  testWidgets('card follows the Doory web order, top to bottom', (
    tester,
  ) async {
    await _pump(tester, const ProductCard(product: _full, width: 180));

    final brand = find.textContaining('دار المونة', findRichText: true);
    final rating = find.text('4.5');
    final discount = find.text(CardStrings.netDiscountPlaceholder);
    final price = find.textContaining('54,000');
    final badge = find.text(CardStrings.discountBadge(20));

    expect(brand, findsOneWidget);
    expect(
      find.textContaining('زيت زيتون، 1 لتر', findRichText: true),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    expect(
      find.textContaining(CardStrings.viewersLead, findRichText: true),
      findsNothing,
    );
    expect(rating, findsOneWidget);
    expect(find.text('(4)'), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(discount, findsOneWidget);
    expect(find.text(CardStrings.netDiscount(20)), findsNothing);
    expect(price, findsOneWidget);
    expect(find.textContaining('67,500'), findsOneWidget);
    expect(badge, findsOneWidget);
    expect(find.text('منتج محلي'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    // Home / default card: no favorites count line.
    expect(find.byKey(const ValueKey('card-favorites-count')), findsNothing);

    // The ticker and the long «شخصاً أضافوه» line stay on the product page.
    expect(find.byType(SocialProofTicker), findsNothing);
    expect(
      find.textContaining(
        CardStrings.favoritedBy(CardStrings.sampleFavoritesCount),
      ),
      findsNothing,
    );
    expect(find.byType(FittedBox), findsNothing);

    // RTL: badge (right) then price then struck old price (left).
    expect(
      tester.getTopLeft(badge).dx,
      greaterThan(tester.getTopLeft(price).dx),
    );
    expect(
      tester.getTopLeft(price).dx,
      greaterThan(tester.getTopLeft(find.textContaining('67,500')).dx),
    );

    final image = tester.getBottomLeft(find.byType(AspectRatio)).dy;
    expect(image, lessThanOrEqualTo(_top(tester, brand)));
    expect(_top(tester, brand), lessThan(_top(tester, rating)));
    expect(_top(tester, rating), lessThan(_top(tester, discount)));
    expect(_top(tester, discount), lessThan(_top(tester, price)));
  });

  testWidgets('server-missing pieces are red, live pieces are not', (
    tester,
  ) async {
    await _pump(tester, const ProductCard(product: _full, width: 180));

    // BACKEND: MISSING — no per-card promo label or photo-review flag.
    expect(
      _textColor(tester, find.text(CardStrings.netDiscountPlaceholder)),
      DooryColors.backendMissing,
    );
    final camera = tester.widget<Icon>(
      find.byIcon(Icons.photo_camera_outlined),
    );
    expect(camera.color, DooryColors.backendMissing);

    // Live fields render in their normal colours.
    final price = _textColor(tester, find.textContaining('54,000'));
    expect(price, isNot(DooryColors.backendMissing));
    expect(
      _textColor(tester, find.textContaining('67,500')),
      DooryColors.textSecondary,
    );
    expect(
      _textColor(tester, find.text('4.5')),
      isNot(DooryColors.backendMissing),
    );
    expect(
      _textColor(tester, find.text('(4)')),
      isNot(DooryColors.backendMissing),
    );
  });

  testWidgets('live pieces collapse when the item has no data for them', (
    tester,
  ) async {
    await _pump(
      tester,
      const ProductCard(
        product: ProductCardModel(
          id: 9,
          slug: '9-bread',
          name: 'خبز تنور',
          storeName: 'مخبز الحي',
          priceSyp: 6000,
        ),
        width: 180,
      ),
    );

    expect(
      find.textContaining('مخبز الحي', findRichText: true),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.verified), findsNothing);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    // No rating, so no photo-review camera either.
    expect(find.byIcon(Icons.photo_camera_outlined), findsNothing);
    expect(find.textContaining('6,000'), findsOneWidget);
    expect(find.textContaining('%'), findsNothing);
    expect(find.textContaining('67,500'), findsNothing);
    expect(find.byKey(const ValueKey('card-favorites-count')), findsNothing);
    // The red net-discount marker still shows so the gap stays visible.
    expect(find.text(CardStrings.netDiscountPlaceholder), findsOneWidget);
  });

  testWidgets('sold-out shows its status and still has no views line', (
    tester,
  ) async {
    await _pump(
      tester,
      ProductCard(product: _full.copyWithAvailable(false), width: 180),
    );
    expect(find.text(DooryStrings.soldOut), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget); // heart only
  });

  testWidgets(
    'current price stays in full; old price ellipsizes on a narrow card',
    (tester) async {
      await _pump(
        tester,
        ProductCard(
          product: _full.copyWithPrices(
            priceSyp: 54000,
            compareAtSyp: 123456789,
          ),
          width: 140,
        ),
      );

      final current = find.textContaining('54,000');
      final old = find.textContaining('123,456,789');
      expect(current, findsOneWidget);
      expect(old, findsOneWidget);
      expect(tester.takeException(), isNull);

      final currentText = tester.widget<Text>(current);
      expect(currentText.overflow, isNot(TextOverflow.ellipsis));
      final oldText = tester.widget<Text>(old);
      expect(oldText.overflow, TextOverflow.ellipsis);
      expect(oldText.maxLines, 1);

      expect(_ellipsized(tester, current), isFalse);
      expect(_ellipsized(tester, old), isTrue);
    },
  );

  testWidgets('favorites count is off unless the listing flag is set', (
    tester,
  ) async {
    await _pump(tester, const ProductCard(product: _full, width: 180));
    expect(find.byKey(const ValueKey('card-favorites-count')), findsNothing);
    expect(find.textContaining('ألف'), findsNothing);
  });

  testWidgets('listing card shows a red compact sample under the title', (
    tester,
  ) async {
    await _pump(
      tester,
      const ProductCard(product: _full, width: 180, showFavorites: true),
    );
    final count = find.byKey(const ValueKey('card-favorites-count'));
    expect(count, findsOneWidget);
    expect(find.text(formatCompactCount(1247)), findsOneWidget);
    expect(find.textContaining('ألف'), findsOneWidget);
    expect(
      _textColor(tester, find.text(formatCompactCount(1247))),
      DooryColors.backendMissing,
    );
    expect(
      tester
          .widget<Text>(find.text(formatCompactCount(1247)))
          .style
          ?.fontWeight,
      FontWeight.w700,
    );
    expect(
      _top(tester, find.textContaining('دار المونة', findRichText: true)),
      lessThan(_top(tester, count)),
    );
    expect(_top(tester, count), lessThan(_top(tester, find.text('4.5'))));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('zero favorites keeps the 14 dp slot empty', (tester) async {
    await _pump(
      tester,
      ProductCard(
        product: _full.copyWithFavorites(0),
        width: 180,
        showFavorites: true,
      ),
    );
    final count = find.byKey(const ValueKey('card-favorites-count'));
    expect(count, findsOneWidget);
    expect(tester.getSize(count).height, 14);
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.textContaining('ألف'), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('a live favorites count is not red', (tester) async {
    await _pump(
      tester,
      ProductCard(
        product: _full.copyWithFavorites(12),
        width: 180,
        showFavorites: true,
      ),
    );
    expect(find.byKey(const ValueKey('card-favorites-count')), findsOneWidget);
    expect(find.text(formatCompactCount(12)), findsOneWidget);
    expect(
      _textColor(tester, find.text(formatCompactCount(12))),
      isNot(DooryColors.backendMissing),
    );
  });

  testWidgets('no discount shows the current price only', (tester) async {
    await _pump(
      tester,
      const ProductCard(
        product: ProductCardModel(
          id: 9,
          slug: '9-bread',
          name: 'خبز تنور',
          priceSyp: 6000,
        ),
        width: 180,
      ),
    );
    expect(find.textContaining('6,000'), findsOneWidget);
    expect(find.textContaining('67,500'), findsNothing);
    expect(find.text(CardStrings.discountBadge(20)), findsNothing);
  });

  testWidgets('listing grid with favorites fits at 390 without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await _pump(
      tester,
      CustomScrollView(
        slivers: [
          ProductGridSliver(
            showFavorites: true,
            items: [for (var i = 0; i < 4; i++) _full.copyWithId(700 + i)],
          ),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
    final card = tester.getSize(find.byType(ProductCard).first);
    expect(
      card.height,
      closeTo(
        ProductCardMetrics.cardHeight(card.width, 1, showFavorites: true),
        0.5,
      ),
    );
  });

  for (final size in const [Size(390, 844), Size(360, 740)]) {
    for (final textScale in const [1.0, 1.3]) {
      testWidgets(
        'shelf and grid fit without overflow at ${size.width.toInt()} wide, '
        '×$textScale text',
        (tester) async {
          tester.view.physicalSize = size * 3;
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);

          await _pump(
            tester,
            Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScale)),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ProductShelf(
                        title: 'مميز',
                        products: [
                          for (var i = 0; i < 6; i++) _full.copyWithId(600 + i),
                        ],
                      ),
                    ),
                    ProductGridSliver(
                      items: [
                        for (var i = 0; i < 4; i++) _full.copyWithId(700 + i),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);

          // Shelf: the card is 0.335 of the width and 2.7–2.8 cards show.
          final shelf = find.byType(ProductShelf);
          final cards = find.descendant(
            of: shelf,
            matching: find.byType(ProductCard),
          );
          final cardSize = tester.getSize(cards.first);
          expect(
            cardSize.width,
            closeTo(
              ProductCardMetrics.shelfCardWidth(size.width, textScale),
              0.5,
            ),
          );
          final visible =
              (size.width - ProductCardMetrics.gap) /
              (cardSize.width + ProductCardMetrics.gap);
          if (textScale == 1.0) {
            expect(visible, inInclusiveRange(2.7, 2.85));
          } else {
            // Cards widen so the full current price still fits.
            expect(visible, inInclusiveRange(2.1, 2.7));
          }
          final rects = [
            for (final e in cards.evaluate())
              tester.getRect(find.byWidget(e.widget)),
          ];
          final whole = rects.where(
            (r) => r.left >= 0 && r.right <= size.width,
          );
          final cut = rects.where(
            (r) =>
                r.left < size.width && r.right > size.width ||
                r.left < 0 && r.right > 0,
          );
          expect(whole.length, 2);
          expect(cut.length, 1);

          // Grid: two columns of ~0.47 of the width, photo 2:3.
          final grid = find.descendant(
            of: find.byType(ProductGridSliver),
            matching: find.byType(ProductCard),
          );
          final cell = tester.getSize(grid.first);
          expect(cell.width, closeTo((size.width - 24) / 2, 0.5));
          if (textScale == 1.0) {
            expect(cell.height, lessThan(size.height * 0.5));
          }
          expect(
            cell.height,
            closeTo(ProductCardMetrics.cardHeight(cell.width, textScale), 0.5),
          );
          final photo = tester.getSize(
            find
                .descendant(of: grid.first, matching: find.byType(AspectRatio))
                .first,
          );
          expect(photo.width / photo.height, closeTo(2 / 3, 0.01));
        },
      );
    }
  }
}

bool _ellipsized(WidgetTester tester, Finder finder) {
  final render = tester.renderObject(finder);
  RenderParagraph? paragraph;
  if (render is RenderParagraph) {
    paragraph = render;
  } else {
    render.visitChildren((child) {
      if (child is RenderParagraph) paragraph = child;
    });
  }
  assert(paragraph != null, 'No RenderParagraph for $finder');
  final box = paragraph!;
  return box.computeMaxIntrinsicWidth(double.infinity) > box.size.width + 0.5;
}

extension on ProductCardModel {
  ProductCardModel copyWithPrices({
    required int priceSyp,
    required int compareAtSyp,
  }) => ProductCardModel(
    id: id,
    slug: slug,
    name: name,
    brandName: brandName,
    brandVerified: brandVerified,
    priceSyp: priceSyp,
    compareAtSyp: compareAtSyp,
    discountPercent: discountPercent,
    averageRating: averageRating,
    reviewsCount: reviewsCount,
    viewers: viewers,
    badgeLabels: badgeLabels,
    favoritesCount: favoritesCount,
  );

  ProductCardModel copyWithFavorites(int? count) => ProductCardModel(
    id: id,
    slug: slug,
    name: name,
    brandName: brandName,
    brandVerified: brandVerified,
    priceSyp: priceSyp,
    compareAtSyp: compareAtSyp,
    discountPercent: discountPercent,
    averageRating: averageRating,
    reviewsCount: reviewsCount,
    viewers: viewers,
    badgeLabels: badgeLabels,
    favoritesCount: count,
  );

  ProductCardModel copyWithAvailable(bool value) => ProductCardModel(
    id: id,
    slug: slug,
    name: name,
    brandName: brandName,
    brandVerified: brandVerified,
    priceSyp: priceSyp,
    compareAtSyp: compareAtSyp,
    discountPercent: discountPercent,
    averageRating: averageRating,
    reviewsCount: reviewsCount,
    viewers: viewers,
    available: value,
  );

  ProductCardModel copyWithId(int newId) => ProductCardModel(
    id: newId,
    slug: '$newId',
    name: name,
    brandName: brandName,
    brandVerified: brandVerified,
    priceSyp: priceSyp,
    compareAtSyp: compareAtSyp,
    discountPercent: discountPercent,
    averageRating: averageRating,
    reviewsCount: reviewsCount,
    viewers: viewers,
    badgeLabels: badgeLabels,
    sample: true,
  );
}
