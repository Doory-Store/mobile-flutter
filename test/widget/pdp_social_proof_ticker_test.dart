import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/card_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/theme/doory_colors.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/social_proof_ticker.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/product/product_screen.dart';
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

Map<String, dynamic> _product({bool withViewers = true}) => {
  'id': 7,
  'slug': '7-zayt',
  'name': 'زيت زيتون بلدي',
  'photos': ['https://example.test/storage/products/a/card.webp'],
  'price_syp': 42000,
  'can_purchase': true,
  'available': true,
  'average_rating': 3.9,
  'reviews_count': 10,
  if (withViewers)
    'viewer_activity': {
      'metric': 'unique_viewers',
      'count': 96,
      'window_hours': 24,
    },
};

final _viewersText = CardStrings.viewers(96, 24);
final _favoritesText = CardStrings.favoritedBy(
  CardStrings.sampleFavoritesCount,
);

Finder _line(String plain) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().contains(plain),
);

Color? _paintedColor(RichText rich) {
  Color? found;
  void visit(InlineSpan span, TextStyle? inherited) {
    if (span is! TextSpan) return;
    final style = span.style == null
        ? inherited
        : (inherited?.merge(span.style) ?? span.style);
    if (span.text != null && span.text!.contains('شخصاً')) {
      found = style?.color;
    }
    for (final child in span.children ?? const <InlineSpan>[]) {
      visit(child, style);
    }
  }

  visit(rich.text, null);
  return found;
}

/// Loads the product page without [WidgetTester.pumpAndSettle], which would
/// hang on the ticker's periodic clock.
Future<SocialProofClock> _pumpPdp(
  WidgetTester tester, {
  bool withViewers = true,
  bool disableAnimations = false,
  bool tickerMode = true,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final clock = SocialProofClock();
  addTearDown(clock.dispose);
  tester.view.physicalSize = const Size(390, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final transport = FakeTransport((path, query) async {
    if (path == '/products/7') return _product(withViewers: withViewers);
    throw const ApiException(ApiFailureKind.notFound, 'no');
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        apiTransportProvider.overrideWith((ref) => transport),
        appConfigProvider.overrideWithValue(_config),
        socialProofClockProvider.overrideWithValue(clock),
      ],
      child: MaterialApp(
        theme: dooryTheme(),
        locale: const Locale('ar'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: disableAnimations),
          child: child!,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TickerMode(
            enabled: tickerMode,
            child: const ProductScreen(ref: '7-zayt'),
          ),
        ),
      ),
    ),
  );
  // A few frames for the async product load; never pumpAndSettle (the
  // periodic clock would never go idle when two messages are present).
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump();
  return clock;
}

void main() {
  testWidgets('PDP ticker cycles viewers → favorites → viewers every 2 s', (
    tester,
  ) async {
    await _pumpPdp(tester);
    expect(find.byType(SocialProofTicker), findsOneWidget);
    expect(_line(_viewersText), findsOneWidget);
    expect(_line(_favoritesText), findsNothing);

    await tester.pump(const Duration(milliseconds: 1900));
    expect(_line(_favoritesText), findsNothing);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    final incoming = tester.getTopLeft(_line(_favoritesText)).dy;
    final outgoing = tester.getTopLeft(_line(_viewersText)).dy;
    expect(incoming, lessThan(outgoing));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_line(_viewersText), findsNothing);
    expect(_line(_favoritesText), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_line(_viewersText), findsOneWidget);
    expect(_line(_favoritesText), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the favorites message is red and tagged as sample data', (
    tester,
  ) async {
    await _pumpPdp(tester, withViewers: false);
    expect(find.byType(SocialProofTicker), findsOneWidget);
    final rich = tester.widget<RichText>(_line(_favoritesText));
    expect(_paintedColor(rich), DooryColors.backendMissing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the viewers message is not red', (tester) async {
    await _pumpPdp(tester);
    final rich = tester.widget<RichText>(_line(_viewersText));
    expect(_paintedColor(rich), isNot(DooryColors.backendMissing));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('one message stays static and never starts the clock', (
    tester,
  ) async {
    final clock = await _pumpPdp(tester, withViewers: false);
    await tester.pump(const Duration(seconds: 7));
    expect(_line(_favoritesText), findsOneWidget);
    expect(_line(_viewersText), findsNothing);
    expect(clock.value, 0);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('reduced motion shows the first message, static', (tester) async {
    final clock = await _pumpPdp(tester, disableAnimations: true);
    await tester.pump(const Duration(seconds: 7));
    expect(_line(_viewersText), findsOneWidget);
    expect(_line(_favoritesText), findsNothing);
    expect(clock.value, 0);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a hidden route or tab (TickerMode off) pauses the ticker', (
    tester,
  ) async {
    final clock = await _pumpPdp(tester, tickerMode: false);
    await tester.pump(const Duration(seconds: 7));
    expect(_line(_viewersText), findsOneWidget);
    expect(clock.value, 0);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('unmounting the product page leaves no timer behind', (
    tester,
  ) async {
    final clock = await _pumpPdp(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(clock.value, 1);
    expect(_line(_favoritesText), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    final stopped = clock.value;
    await tester.pump(const Duration(seconds: 10));
    expect(clock.value, stopped);
  });
}
