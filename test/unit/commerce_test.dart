import 'package:doory_mobile/data/mock/mock_fixtures.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/data/models/commerce_models.dart';
import 'package:doory_mobile/data/repositories/commerce/commerce_contracts.dart';
import 'package:doory_mobile/data/repositories/commerce/live_repositories.dart';
import 'package:doory_mobile/data/repositories/commerce/mock_repositories.dart';
import 'package:doory_mobile/features/auth/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

CartLine line({
  required int id,
  required int store,
  int? price = 1000,
  int quantity = 1,
  bool available = true,
}) {
  return CartLine(
    id: id,
    productId: id,
    productName: 'منتج $id',
    quantity: quantity,
    storeId: store,
    storeName: 'متجر $store',
    priceSyp: price,
    available: available,
  );
}

ProductCardModel card(int id, {String store = 'furn', int? price = 2500}) {
  return ProductCardModel(
    id: id,
    slug: '$id-item',
    name: 'منتج $id',
    storeName: 'متجر $store',
    storeSlug: store,
    priceSyp: price,
  );
}

void main() {
  group('CartCalculator', () {
    test('empty cart has no total', () {
      final summary = CartCalculator.summarize(
        const [],
        deliveryFeePerStoreSyp: 5000,
      );
      expect(summary.isEmpty, isTrue);
      expect(summary.grandTotalSyp, isNull);
      expect(summary.canCheckout, isFalse);
    });

    test('groups by store and charges delivery per store', () {
      final summary = CartCalculator.summarize([
        line(id: 1, store: 1, price: 1000, quantity: 2),
        line(id: 2, store: 1, price: 500),
        line(id: 3, store: 2, price: 3000),
      ], deliveryFeePerStoreSyp: 5000);
      expect(summary.storeCount, 2);
      expect(summary.itemCount, 4);
      expect(summary.itemsTotalSyp, 5500);
      expect(summary.deliveryFeeTotalSyp, 10000);
      expect(summary.grandTotalSyp, 15500);
      expect(summary.groups.first.itemsTotalSyp, 2500);
      expect(summary.canCheckout, isTrue);
    });

    test('a line without a price withholds the grand total', () {
      final summary = CartCalculator.summarize([
        line(id: 1, store: 1, price: null),
      ], deliveryFeePerStoreSyp: 5000);
      expect(summary.hasUnpricedLines, isTrue);
      expect(summary.grandTotalSyp, isNull);
      expect(summary.canCheckout, isFalse);
    });

    test('sold-out lines block checkout and are not totalled', () {
      final summary = CartCalculator.summarize([
        line(id: 1, store: 1, price: 1000),
        line(id: 2, store: 1, price: 9000, available: false),
      ], deliveryFeePerStoreSyp: 0);
      expect(summary.itemsTotalSyp, 1000);
      expect(summary.hasBlockedLines, isTrue);
      expect(summary.canCheckout, isFalse);
    });

    test('discount never exceeds the items total', () {
      final summary = CartCalculator.summarize(
        [line(id: 1, store: 1, price: 1000)],
        deliveryFeePerStoreSyp: 5000,
        coupons: const [AppliedCoupon(code: 'X', discountSyp: 99999)],
      );
      expect(summary.discountTotalSyp, 1000);
      expect(summary.grandTotalSyp, 5000);
    });
  });

  group('MockCartRepository', () {
    late MockCartRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repo = MockCartRepository(
        await SharedPreferences.getInstance(),
        simulateLatency: false,
      );
    });

    test('adding the same product and option merges quantities', () async {
      await repo.addLine(CartLineDraft(product: card(1), quantity: 2));
      final snapshot = await repo.addLine(
        CartLineDraft(product: card(1), quantity: 3),
      );
      expect(snapshot.lines, hasLength(1));
      expect(snapshot.lines.single.quantity, 5);
    });

    test('different options stay on separate lines', () async {
      await repo.addLine(
        CartLineDraft(product: card(1), quantity: 1, optionId: 10),
      );
      final snapshot = await repo.addLine(
        CartLineDraft(product: card(1), quantity: 1, optionId: 11),
      );
      expect(snapshot.lines, hasLength(2));
    });

    test('quantity zero removes the line and the cart persists', () async {
      final added = await repo.addLine(
        CartLineDraft(product: card(1), quantity: 1),
      );
      await repo.addLine(CartLineDraft(product: card(2), quantity: 1));
      final after = await repo.updateQuantity(added.lines.first.id, 0);
      expect(after.lines.map((l) => l.productId), [2]);
      final reloaded = await repo.load();
      expect(reloaded.lines.map((l) => l.productId), [2]);
    });

    test('quantity is capped at 99', () async {
      final added = await repo.addLine(
        CartLineDraft(product: card(1), quantity: 98),
      );
      final after = await repo.addLine(
        CartLineDraft(product: card(1), quantity: 5),
      );
      expect(after.lines.single.quantity, 99);
      final updated = await repo.updateQuantity(added.lines.first.id, 500);
      expect(updated.lines.single.quantity, 99);
    });

    test('the sample coupon applies 10% capped, others are rejected', () async {
      await repo.addLine(
        CartLineDraft(product: card(1, price: 50000), quantity: 1),
      );
      await expectLater(
        repo.applyCoupon('WRONG'),
        throwsA(isA<DomainRejection>()),
      );
      final applied = await repo.applyCoupon(MockFixtures.couponCode);
      expect(applied.coupons.single.discountSyp, 5000);
      await expectLater(
        repo.applyCoupon(MockFixtures.couponCode),
        throwsA(isA<DomainRejection>()),
      );
      final big = await repo.addLine(
        CartLineDraft(product: card(2, price: 1000000), quantity: 1),
      );
      expect(big.coupons.single.discountSyp, MockFixtures.couponMaxSyp);
      final removed = await repo.removeCoupon(MockFixtures.couponCode);
      expect(removed.coupons, isEmpty);
    });

    test('clear empties the cart', () async {
      await repo.addLine(CartLineDraft(product: card(1), quantity: 1));
      final cleared = await repo.clear();
      expect(cleared.lines, isEmpty);
      expect((await repo.load()).lines, isEmpty);
    });
  });

  group('Auth', () {
    test('Syrian mobile numbers normalise to E.164', () {
      expect(normalizeSyrianMobile('0944 123 456'), '+963944123456');
      expect(normalizeSyrianMobile('944123456'), '+963944123456');
      expect(normalizeSyrianMobile('+963944123456'), '+963944123456');
      expect(normalizeSyrianMobile('00963944123456'), '+963944123456');
      expect(normalizeSyrianMobile('٠٩٤٤١٢٣٤٥٦'), '+963944123456');
      expect(normalizeSyrianMobile('0311234567'), isNull);
      expect(normalizeSyrianMobile('12345'), isNull);
    });

    test('mock OTP accepts the simulation code only', () async {
      final repo = MockAuthRepository(simulateLatency: false);
      final challenge = await repo.requestOtp('+963944123456');
      expect(challenge.simulationCode, MockFixtures.otpCode);
      await expectLater(
        repo.verifyOtp('+963944123456', '000000'),
        throwsA(isA<DomainRejection>()),
      );
      final session = await repo.verifyOtp(
        '+963944123456',
        MockFixtures.otpCode,
      );
      expect(session.user.phone, '+963944123456');
      expect(session.token, isNotEmpty);
    });
  });

  group('Addresses', () {
    test('closed neighborhoods are rejected, new address is added', () async {
      final repo = MockAddressRepository(simulateLatency: false);
      final closed = MockFixtures.neighborhoods.firstWhere(
        (item) => item['is_open'] == false,
      );
      await expectLater(
        repo.save(
          BuyerAddress(
            id: 0,
            lat: 0,
            lng: 0,
            neighborhoodId: closed['id'] as int,
          ),
        ),
        throwsA(isA<DomainRejection>()),
      );
      final before = (await repo.list()).length;
      final after = await repo.save(
        const BuyerAddress(
          id: 0,
          lat: 0,
          lng: 0,
          label: 'أخرى',
          neighborhoodId: 1,
          neighborhoodName: 'الوعر',
        ),
      );
      expect(after, hasLength(before + 1));
    });

    test('deleting the default promotes another address', () async {
      final repo = MockAddressRepository(simulateLatency: false);
      final items = await repo.list();
      final def = items.firstWhere((item) => item.isDefault);
      final after = await repo.delete(def.id);
      expect(after.where((item) => item.isDefault), hasLength(1));
    });
  });

  group('Orders', () {
    test('fixtures decode with Arabic status labels', () async {
      final repo = MockOrderRepository(simulateLatency: false);
      final orders = await repo.list();
      expect(orders, isNotEmpty);
      for (final order in orders) {
        expect(order.statusLabel, OrderStatus.label(order.status));
      }
      final detail = await repo.detail(orders.first.publicId);
      expect(detail, isNotNull);
      expect(detail!.lines, isNotEmpty);
      expect(detail.history.last.toStatus, detail.summary.status);
    });

    test('filters match the backend statuses', () {
      expect(OrderFilter.awaitingPayment.matches('pending_payment'), isTrue);
      expect(OrderFilter.inProgress.matches('preparing'), isTrue);
      expect(OrderFilter.onTheWay.matches('out_for_delivery'), isTrue);
      expect(OrderFilter.delivered.matches('completed'), isTrue);
      expect(OrderFilter.closed.matches('rejected_by_supplier'), isTrue);
      expect(OrderFilter.closed.matches('paid'), isFalse);
      expect(OrderStatus.canRequestCancel('paid'), isTrue);
      expect(OrderStatus.canRequestCancel('out_for_delivery'), isFalse);
    });
  });

  group('Live repositories', () {
    test('name their endpoint until wired', () async {
      await expectLater(
        LiveCartRepository().load(),
        throwsA(
          isA<NotWiredException>().having(
            (e) => e.endpoint,
            'endpoint',
            contains('/carts'),
          ),
        ),
      );
      await expectLater(
        LiveOrderRepository().list(),
        throwsA(isA<NotWiredException>()),
      );
    });
  });

  group('Payment guide', () {
    test('lists the three backend methods with steps', () async {
      final repo = MockCheckoutRepository(simulateLatency: false);
      final guide = await repo.paymentGuide();
      expect(guide.map((m) => m.method), [
        'sham_cash',
        'syriatel_cash',
        'paymera',
      ]);
      expect(guide.every((m) => m.steps.length == 4), isTrue);
    });

    test('pickup checkout charges no delivery fee', () async {
      final repo = MockCheckoutRepository(simulateLatency: false);
      final cart = CartCalculator.summarize([
        line(id: 1, store: 1, price: 1000),
        line(id: 2, store: 2, price: 2000),
      ], deliveryFeePerStoreSyp: 5000);
      final result = await repo.previewCheckout(
        const CheckoutDraft(
          method: DeliveryMethod.pickup,
          paymentMethod: 'sham_cash',
          pickupPointId: 1,
        ),
        cart,
      );
      expect(result.sample, isTrue);
      expect(result.storeOrders, hasLength(2));
      expect(result.deliveryFeeTotalSyp, 0);
      expect(result.grandTotalSyp, 3000);
    });
  });
}
