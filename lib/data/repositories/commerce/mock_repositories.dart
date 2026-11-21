import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../mock/mock_fixtures.dart';
import '../../models/commerce_models.dart';
import 'commerce_contracts.dart';

/// Simulated latency for every Mock repository. Tests set this to
/// [Duration.zero] so no timer outlives a widget tree.
Duration mockLatency = MockFixtures.latency;

Future<void> _delay() async {
  if (mockLatency == Duration.zero) return;
  await Future<void>.delayed(mockLatency);
}

/// Cart kept on the device so it survives restarts while `/carts` is unwired.
class MockCartRepository implements CartRepository {
  MockCartRepository(this._prefs, {this.simulateLatency = true});

  static const storageKey = 'doory.mock.cart.v1';

  final SharedPreferences _prefs;
  final bool simulateLatency;

  @override
  bool get isSample => true;

  @override
  int get deliveryFeePerStoreSyp => MockFixtures.deliveryFeePerStoreSyp;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  CartSnapshot _read() {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return const CartSnapshot();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const CartSnapshot();
      final lines = [
        if (decoded['lines'] is List)
          for (final item in decoded['lines'] as List)
            if (item is Map) CartLine.fromJson(Map<String, dynamic>.from(item)),
      ];
      final coupons = [
        if (decoded['coupons'] is List)
          for (final item in decoded['coupons'] as List)
            if (item is Map && item['code'] is String)
              AppliedCoupon(
                code: item['code'] as String,
                discountSyp: (item['discount_syp'] as num?)?.toInt() ?? 0,
              ),
      ];
      return CartSnapshot(lines: lines, coupons: _reprice(lines, coupons));
    } catch (_) {
      return const CartSnapshot();
    }
  }

  Future<CartSnapshot> _write(CartSnapshot snapshot) async {
    final repriced = CartSnapshot(
      lines: snapshot.lines,
      coupons: _reprice(snapshot.lines, snapshot.coupons),
    );
    await _prefs.setString(
      storageKey,
      jsonEncode({
        'lines': [for (final line in repriced.lines) line.toJson()],
        'coupons': [
          for (final coupon in repriced.coupons)
            {'code': coupon.code, 'discount_syp': coupon.discountSyp},
        ],
      }),
    );
    return repriced;
  }

  /// The sample coupon is a percentage of the items, capped.
  static List<AppliedCoupon> _reprice(
    List<CartLine> lines,
    List<AppliedCoupon> coupons,
  ) {
    if (lines.isEmpty) return const [];
    var items = 0;
    for (final line in lines) {
      if (line.purchasable) items += line.lineTotalSyp ?? 0;
    }
    return [
      for (final coupon in coupons)
        AppliedCoupon(
          code: coupon.code,
          discountSyp: min(
            items * MockFixtures.couponPercent ~/ 100,
            MockFixtures.couponMaxSyp,
          ),
        ),
    ];
  }

  @override
  Future<CartSnapshot> load() async => _read();

  @override
  Future<CartSnapshot> addLine(CartLineDraft draft) async {
    await _wait();
    final current = _read();
    final product = draft.product;
    final lines = [...current.lines];
    final index = lines.indexWhere(
      (line) => line.sameItem(product.id, draft.optionId),
    );
    if (index >= 0) {
      final merged = min(99, lines[index].quantity + draft.quantity);
      lines[index] = lines[index].copyWith(quantity: merged);
    } else {
      final nextId = lines.fold<int>(0, (top, line) => max(top, line.id)) + 1;
      final storeKey = product.storeSlug ?? product.storeName ?? 'store';
      lines.add(
        CartLine(
          id: nextId,
          productId: product.id,
          productRef: product.ref,
          productName: product.name,
          quantity: draft.quantity.clamp(1, 99),
          storeId: draft.storeId ?? storeKey.hashCode.abs(),
          storeName: product.storeName ?? 'متجر',
          storeSlug: product.storeSlug,
          productOptionId: draft.optionId,
          optionLabel: draft.optionLabel,
          photoUrl: product.photoUrl,
          priceSyp: product.priceSyp,
          priceIsEstimate: product.priceIsEstimate,
          available: product.available,
          canPurchase: product.canPurchase,
        ),
      );
    }
    return _write(CartSnapshot(lines: lines, coupons: current.coupons));
  }

  @override
  Future<CartSnapshot> updateQuantity(int lineId, int quantity) async {
    await _wait();
    final current = _read();
    final lines = <CartLine>[];
    for (final line in current.lines) {
      if (line.id != lineId) {
        lines.add(line);
      } else if (quantity > 0) {
        lines.add(line.copyWith(quantity: quantity.clamp(1, 99)));
      }
    }
    return _write(CartSnapshot(lines: lines, coupons: current.coupons));
  }

  @override
  Future<CartSnapshot> removeLine(int lineId) async {
    await _wait();
    final current = _read();
    return _write(
      CartSnapshot(
        lines: [
          for (final line in current.lines)
            if (line.id != lineId) line,
        ],
        coupons: current.coupons,
      ),
    );
  }

  @override
  Future<CartSnapshot> applyCoupon(String code) async {
    await _wait();
    final current = _read();
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty) {
      throw const DomainRejection('أدخل رمز القسيمة.');
    }
    if (current.lines.isEmpty) {
      throw const DomainRejection('أضف منتجات إلى السلة قبل تطبيق القسيمة.');
    }
    if (normalized != MockFixtures.couponCode) {
      throw const DomainRejection('رمز القسيمة غير صالح أو منتهي الصلاحية.');
    }
    if (current.coupons.any((coupon) => coupon.code == normalized)) {
      throw const DomainRejection('هذه القسيمة مطبّقة بالفعل.');
    }
    return _write(
      CartSnapshot(
        lines: current.lines,
        coupons: [
          ...current.coupons,
          AppliedCoupon(code: normalized, discountSyp: 0),
        ],
      ),
    );
  }

  @override
  Future<CartSnapshot> removeCoupon(String code) async {
    await _wait();
    final current = _read();
    return _write(
      CartSnapshot(
        lines: current.lines,
        coupons: [
          for (final coupon in current.coupons)
            if (coupon.code != code) coupon,
        ],
      ),
    );
  }

  @override
  Future<CartSnapshot> clear() async {
    await _prefs.remove(storageKey);
    return const CartSnapshot();
  }
}

/// OTP accepts [MockFixtures.otpCode] for any valid Syrian mobile number.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.simulateLatency = true});

  final bool simulateLatency;
  BuyerUser? _user;

  @override
  bool get isSample => true;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  @override
  Future<OtpChallenge> requestOtp(String phone) async {
    await _wait();
    return OtpChallenge.fromJson(phone, {
      'expires_in': 300,
      'simulation_code': MockFixtures.otpCode,
    });
  }

  @override
  Future<BuyerSession> verifyOtp(String phone, String code) async {
    await _wait();
    if (code.trim() != MockFixtures.otpCode) {
      throw const DomainRejection('الرمز غير صحيح. تحقّق منه ثم أعد المحاولة.');
    }
    final session = BuyerSession.fromJson(MockFixtures.tokenFor(phone));
    _user = session.user;
    return session;
  }

  @override
  Future<BuyerUser> updateName(String name) async {
    await _wait();
    final trimmed = name.trim();
    if (trimmed.length < 2) {
      throw const DomainRejection('أدخل اسمًا من حرفين على الأقل.');
    }
    final next = (_user ?? const BuyerUser(id: 1, phone: '', name: ''))
        .copyWith(name: trimmed);
    _user = next;
    return next;
  }

  @override
  Future<void> logout() async {
    _user = null;
  }
}

class MockAddressRepository implements AddressRepository {
  MockAddressRepository({this.simulateLatency = true})
    : _items = [
        for (final item in MockFixtures.addresses) BuyerAddress.fromJson(item),
      ];

  final bool simulateLatency;
  final List<BuyerAddress> _items;

  @override
  bool get isSample => true;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  List<BuyerAddress> get _snapshot => List.unmodifiable(_items);

  @override
  Future<List<BuyerAddress>> list() async {
    await _wait();
    return _snapshot;
  }

  @override
  Future<List<Neighborhood>> neighborhoods({int cityId = 1}) async {
    await _wait();
    return [
      for (final item in MockFixtures.neighborhoods)
        if (item['city_id'] == cityId) Neighborhood.fromJson(item),
    ];
  }

  @override
  Future<List<BuyerAddress>> save(BuyerAddress address) async {
    await _wait();
    final hood = MockFixtures.neighborhoods.firstWhere(
      (item) => item['id'] == address.neighborhoodId,
      orElse: () => const {},
    );
    if (hood.isEmpty) {
      throw const DomainRejection('اختر الحي.');
    }
    if (hood['is_open'] != true) {
      throw const DomainRejection('العنوان خارج مناطق التوصيل الحالية.');
    }
    final first = _items.isEmpty;
    if (address.id == 0) {
      final nextId =
          _items.fold<int>(100, (top, item) => max(top, item.id)) + 1;
      _items.add(address.copyWith(id: nextId, isDefault: first));
    } else {
      final index = _items.indexWhere((item) => item.id == address.id);
      if (index < 0) throw const DomainRejection('لم نجد هذا العنوان.');
      _items[index] = address.copyWith(isDefault: _items[index].isDefault);
    }
    return _snapshot;
  }

  @override
  Future<List<BuyerAddress>> delete(int id) async {
    await _wait();
    final removed = _items.where((item) => item.id == id).toList();
    _items.removeWhere((item) => item.id == id);
    if (removed.any((item) => item.isDefault) && _items.isNotEmpty) {
      _items[0] = _items[0].copyWith(isDefault: true);
    }
    return _snapshot;
  }

  @override
  Future<List<BuyerAddress>> setDefault(int id) async {
    await _wait();
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isDefault: _items[i].id == id);
    }
    return _snapshot;
  }
}

class MockCheckoutRepository implements CheckoutRepository {
  MockCheckoutRepository({this.simulateLatency = true});

  final bool simulateLatency;

  @override
  bool get isSample => true;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  @override
  Map<String, String> get receivingAccounts => MockFixtures.paymentAccounts;

  @override
  Future<List<PaymentMethodGuide>> paymentGuide() async {
    await _wait();
    return [
      for (final item in MockFixtures.paymentGuide['methods'] as List)
        PaymentMethodGuide.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  @override
  Future<List<DeliverySlot>> deliverySlots() async {
    await _wait();
    return [
      for (final item in MockFixtures.deliverySlots)
        DeliverySlot.fromJson(item),
    ];
  }

  @override
  Future<List<PickupPoint>> pickupPoints() async {
    await _wait();
    return [
      for (final item in MockFixtures.pickupPoints) PickupPoint.fromJson(item),
    ];
  }

  @override
  Future<CheckoutResult> previewCheckout(
    CheckoutDraft draft,
    CartSummary cart,
  ) async {
    await _wait();
    final random = Random();
    String uuid() {
      const hex = '0123456789abcdef';
      String part(int n) =>
          List.generate(n, (_) => hex[random.nextInt(16)]).join();
      return '${part(8)}-${part(4)}-4${part(3)}-a${part(3)}-${part(12)}';
    }

    final pickup = draft.method == DeliveryMethod.pickup;
    final perStore = pickup ? 0 : cart.deliveryFeePerStoreSyp;
    final storeOrders = [
      for (final group in cart.groups)
        {
          'public_id': uuid(),
          'store_name': group.storeName,
          'status': 'pending_payment',
          'items_total_syp': group.itemsTotalSyp,
          'delivery_fee_syp': perStore,
        },
    ];
    final delivery = perStore * cart.groups.length;
    final items = cart.itemsTotalSyp ?? 0;
    return CheckoutResult.fromJson({
      'public_id': uuid(),
      'status': 'pending_payment',
      'payment_status': 'unpaid',
      'delivery_fee_per_store_syp': perStore,
      'delivery_fee_total_syp': delivery,
      'items_total_syp': items,
      'grand_total_syp': items - cart.discountTotalSyp + delivery,
      'expires_at': DateTime.now()
          .add(const Duration(hours: 24))
          .toIso8601String(),
      'delivery_promise': {'message_ar': MockFixtures.deliveryPromise},
      'store_orders': storeOrders,
    }, sample: true);
  }
}

class MockOrderRepository implements OrderRepository {
  MockOrderRepository({this.simulateLatency = true});

  final bool simulateLatency;

  @override
  bool get isSample => true;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  @override
  Future<List<OrderListItem>> list() async {
    await _wait();
    return [
      for (final item in MockFixtures.orders) OrderListItem.fromJson(item),
    ];
  }

  @override
  Future<OrderDetail?> detail(String publicId) async {
    await _wait();
    for (final item in MockFixtures.orders) {
      if (item['public_id'] == publicId) return OrderDetail.fromJson(item);
    }
    return null;
  }
}

class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository({this.simulateLatency = true})
    : _items = [
        for (final item in MockFixtures.notifications)
          AppNotification.fromJson(item),
      ],
      _prefs = NotificationPreferences.fromJson(
        MockFixtures.notificationPreferences,
      );

  final bool simulateLatency;
  List<AppNotification> _items;
  NotificationPreferences _prefs;

  @override
  bool get isSample => true;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  @override
  Future<List<AppNotification>> list() async {
    await _wait();
    return List.unmodifiable(_items);
  }

  @override
  Future<List<AppNotification>> markRead(int id) async {
    final now = DateTime.now();
    _items = [
      for (final item in _items) item.id == id ? item.markRead(now) : item,
    ];
    return List.unmodifiable(_items);
  }

  @override
  Future<List<AppNotification>> markAllRead() async {
    final now = DateTime.now();
    _items = [for (final item in _items) item.markRead(now)];
    return List.unmodifiable(_items);
  }

  @override
  Future<NotificationPreferences> preferences() async {
    await _wait();
    return _prefs;
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences next,
  ) async {
    _prefs = next;
    return _prefs;
  }
}

class MockEngagementRepository implements EngagementRepository {
  MockEngagementRepository({this.simulateLatency = true});

  final bool simulateLatency;

  @override
  bool get isSample => true;

  Future<void> _wait() async {
    if (simulateLatency) await _delay();
  }

  @override
  String get supportPhone => MockFixtures.supportPhone;

  @override
  String get supportWhatsapp => MockFixtures.supportWhatsapp;

  @override
  Future<List<Review>> productReviews(int productId) async {
    await _wait();
    return [for (final item in MockFixtures.reviews) Review.fromJson(item)];
  }

  @override
  Future<List<Review>> storeReviews(String slug) async {
    await _wait();
    return [for (final item in MockFixtures.reviews) Review.fromJson(item)];
  }

  @override
  Future<List<HelpArticle>> helpArticles() async {
    await _wait();
    return [
      for (final item in MockFixtures.helpArticles) HelpArticle.fromJson(item),
    ];
  }

  @override
  Future<List<SupportTicket>> tickets() async {
    await _wait();
    return [
      for (final item in MockFixtures.supportTickets)
        SupportTicket.fromJson(item),
    ];
  }
}
