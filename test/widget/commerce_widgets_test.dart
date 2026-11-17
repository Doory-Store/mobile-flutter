import 'package:doory_mobile/core/l10n/doory_strings.dart';
import 'package:doory_mobile/core/l10n/shop_strings.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/quantity_stepper.dart';
import 'package:doory_mobile/core/widgets/ui_kit.dart';
import 'package:doory_mobile/data/favorites/favorites_controller.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/data/repositories/commerce/commerce_contracts.dart';
import 'package:doory_mobile/data/repositories/commerce/commerce_providers.dart';
import 'package:doory_mobile/data/repositories/commerce/mock_repositories.dart';
import 'package:doory_mobile/features/account/account_screen.dart';
import 'package:doory_mobile/features/cart/cart_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: dooryTheme(),
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    ),
  );
}

void main() {
  testWidgets('empty cart shows the empty state', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      wrap(
        const CartScreen(),
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(ShopStrings.cartEmptyTitle), findsOneWidget);
  });

  testWidgets('cart lists lines with totals and the sample label', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = MockCartRepository(prefs, simulateLatency: false);
    await repo.addLine(
      const CartLineDraft(
        product: ProductCardModel(
          id: 7,
          slug: '7-bread',
          name: 'خبز صاج',
          storeName: 'فرن الياسمين',
          storeSlug: 'furn-al-yasmin',
          priceSyp: 6000,
        ),
        quantity: 2,
      ),
    );
    await tester.pumpWidget(
      wrap(
        const CartScreen(),
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          cartRepositoryProvider.overrideWithValue(repo),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('خبز صاج'), findsOneWidget);
    expect(find.text('فرن الياسمين'), findsOneWidget);
    expect(find.text(DooryStrings.demo), findsWidgets);
    expect(find.text(ShopStrings.proceedToCheckout), findsOneWidget);
    expect(find.byType(QuantityStepper), findsOneWidget);
    // 2 × 6,000 + 5,000 delivery.
    expect(find.textContaining('17,000'), findsWidgets);
  });

  testWidgets('guest account shows the login action', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      wrap(
        const AccountScreen(),
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(ShopStrings.welcomeGuest), findsOneWidget);
    expect(find.text(ShopStrings.login), findsOneWidget);
    expect(find.text(ShopStrings.myOrders), findsOneWidget);
  });

  testWidgets('server-only actions explain they are not wired', (tester) async {
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showNotWired(context, feature: 'إرسال الطلب'),
              child: const Text('go'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.text(DooryStrings.notWiredTitle), findsOneWidget);
    expect(find.textContaining('إرسال الطلب'), findsOneWidget);
  });

  testWidgets('stepper turns into delete at the minimum', (tester) async {
    var removed = false;
    var value = 1;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Center(
              child: QuantityStepper(
                value: value,
                onChanged: (next) => setState(() => value = next),
                onRemove: () => removed = true,
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(value, 2);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.delete_outline));
    expect(removed, isTrue);
  });
}
