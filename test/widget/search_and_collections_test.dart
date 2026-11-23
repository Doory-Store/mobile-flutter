import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doory_mobile/app/app.dart';
import 'package:doory_mobile/app/router.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/core/network/api_transport.dart';
import 'package:doory_mobile/core/routing/home_collection.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/repositories/providers.dart';
import 'package:doory_mobile/features/search/search_screen.dart';
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

Map<String, dynamic> _card(int id, String name) => {
  'id': id,
  'slug': '$id-item',
  'name': name,
  'store_name': 'فرن الياسمين',
  'store_slug': 'furn-al-yasmin',
  'available': true,
  'price_syp': 6000,
  'can_purchase': true,
};

Map<String, dynamic> _page(List<Map<String, dynamic>> items) => {
  'data': items,
  'meta': {'page': 1, 'per_page': 24, 'total': items.length, 'last_page': 1},
};

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

/// Captures the URL Dio builds, so the test sees the wire encoding.
class _CaptureAdapter implements HttpClientAdapter {
  Uri? lastUri;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastUri = options.uri;
    return ResponseBody.fromString(
      jsonEncode({
        'search': {'q': options.uri.queryParameters['q']},
        'data': [_card(10, 'زيت زيتون بلدي')],
        'meta': {'page': 1, 'per_page': 24, 'total': 1, 'last_page': 1},
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  testWidgets(
    'search field takes Arabic, keeps the composing region, and searches it',
    (tester) async {
      final prefs = await _prefs();
      final queries = <String>[];
      final transport = FakeTransport((path, query) async {
        if (path == '/categories') return [];
        if (path == '/search') {
          queries.add('${query?['q']}');
          return {
            'search': {'q': query?['q']},
            'data': [_card(10, 'زيت زيتون بلدي')],
            'meta': {'page': 1, 'per_page': 24, 'total': 1, 'last_page': 1},
          };
        }
        throw const ApiException(ApiFailureKind.notFound, 'no');
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            apiTransportProvider.overrideWith((ref) => transport),
            appConfigProvider.overrideWithValue(_config),
          ],
          child: MaterialApp(
            theme: dooryTheme(),
            locale: const Locale('ar'),
            home: const SearchScreen(initialQuery: ''),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.showKeyboard(find.byType(TextField));
      // An Arabic keyboard sends a word with an open composing region.
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'زيت',
          selection: TextSelection.collapsed(offset: 3),
          composing: TextRange(start: 0, end: 3),
        ),
      );
      await tester.pump();
      final field = tester.widget<TextField>(find.byType(TextField));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(field.controller!.text, 'زيت');
      expect(
        field.controller!.value.composing,
        const TextRange(start: 0, end: 3),
      );
      expect(queries, ['زيت']);
      expect(find.text('زيت زيتون بلدي'), findsOneWidget);

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'زيت زيتون',
          selection: TextSelection.collapsed(offset: 9),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(field.controller!.text, 'زيت زيتون');
      expect(queries.last, 'زيت زيتون');
    },
  );

  test('an Arabic query is percent-encoded as UTF-8 on the wire', () async {
    final adapter = _CaptureAdapter();
    final dio = buildDio(_config)..httpClientAdapter = adapter;
    final transport = DioApiTransport(_config, dio: dio);
    await transport.get('/search', query: {'q': 'زيت زيتون', 'page': 1});
    final uri = adapter.lastUri!;
    expect(uri.path, '/api/v1/search');
    expect(uri.query, contains('q=%D8%B2%D9%8A%D8%AA'));
    expect(uri.queryParameters['q'], 'زيت زيتون');
  });

  test('home collections round-trip through the route key', () {
    for (final collection in HomeCollection.values) {
      expect(HomeCollection.parse(collection.key), collection);
    }
    expect(HomeCollection.parse(null), HomeCollection.latest);
  });

  testWidgets('every «عرض الكل» on home opens a populated listing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final prefs = await _prefs();
    final productQueries = <Map<String, dynamic>?>[];
    final transport = FakeTransport((path, query) async {
      return switch (path) {
        '/home' => {
          'featured': [_card(4, 'خبز تنور بلدي'), _card(13, 'بقلاوة بالفستق')],
          'latest': [_card(30, 'حليب طازج')],
        },
        '/categories' => [],
        '/meta/status' => {'maintenance_active': false},
        '/products' => () {
          productQueries.add(query);
          return _page([
            _card(30, 'حليب طازج'),
            _card(31, 'لبنة بلدية'),
            _card(32, 'زيت زيتون بلدي'),
          ]);
        }(),
        _ => throw const ApiException(ApiFailureKind.notFound, 'no'),
      };
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          apiTransportProvider.overrideWith((ref) => transport),
          appConfigProvider.overrideWithValue(_config),
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

    final viewAll = find.widgetWithText(TextButton, DooryStrings.viewAll);
    expect(viewAll, findsNWidgets(2));
    for (final element in viewAll.evaluate()) {
      expect((element.widget as TextButton).onPressed, isNotNull);
    }

    // «وصل حديثًا» pages the whole catalog.
    await tester.tap(viewAll.at(1));
    await tester.pumpAndSettle();
    expect(find.text(DooryStrings.latest), findsOneWidget);
    expect(productQueries, isNotEmpty);
    expect(productQueries.last!.containsKey('category'), isFalse);
    expect(find.text('لبنة بلدية'), findsOneWidget);
    expect(find.text(DooryStrings.emptyCategory), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // «مختارات» lists every featured card from the home feed.
    await tester.tap(viewAll.at(0));
    await tester.pumpAndSettle();
    expect(find.text(DooryStrings.featured), findsOneWidget);
    expect(find.text('خبز تنور بلدي'), findsOneWidget);
    expect(find.text('بقلاوة بالفستق'), findsOneWidget);
  });
}
