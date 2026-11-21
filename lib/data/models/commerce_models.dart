// Buyer commerce models for cart, checkout, account, orders, and engagement.
//
// Field names follow `docs/openapi/buyer-v1.yaml` in the backend so a live
// repository can decode server JSON with the same `fromJson` factories the
// sample fixtures use today.

int? _int(Object? value) => value is int
    ? value
    : value is num
    ? value.toInt()
    : value is String
    ? int.tryParse(value)
    : null;

double? _double(Object? value) => value is num
    ? value.toDouble()
    : value is String
    ? double.tryParse(value)
    : null;

String? _str(Object? value) => value is String ? value : null;

bool _bool(Object? value, [bool fallback = false]) =>
    value is bool ? value : fallback;

DateTime? _date(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

List<Map<String, dynamic>> _maps(Object? value) => [
  if (value is List)
    for (final item in value)
      if (item is Map) Map<String, dynamic>.from(item),
];

// ---------------------------------------------------------------- Auth & me

/// `OtpAccepted`: the code lifetime and, in simulation mode, the code itself.
class OtpChallenge {
  const OtpChallenge({
    required this.phone,
    required this.expiresIn,
    this.simulationCode,
    this.remainingSends,
  });

  factory OtpChallenge.fromJson(
    String phone,
    Map<String, dynamic> json, {
    int? remainingSends,
  }) {
    return OtpChallenge(
      phone: phone,
      expiresIn: _int(json['expires_in']) ?? 300,
      simulationCode: _str(json['simulation_code']),
      remainingSends: remainingSends,
    );
  }

  final String phone;
  final int expiresIn;

  /// Present only while the backend runs its pre-delivery simulation mode.
  final String? simulationCode;

  /// Codes this phone may still request in the current 15-minute window
  /// (`X-RateLimit-Remaining`), when the server reports it.
  final int? remainingSends;
}

/// `BuyerAuthUser` / `BuyerMe`.
class BuyerUser {
  const BuyerUser({required this.id, required this.phone, required this.name});

  factory BuyerUser.fromJson(Map<String, dynamic> json) {
    return BuyerUser(
      id: _int(json['id']) ?? 0,
      phone: _str(json['phone']) ?? '',
      name: _str(json['name']) ?? '',
    );
  }

  final int id;
  final String phone;
  final String name;

  BuyerUser copyWith({String? name}) =>
      BuyerUser(id: id, phone: phone, name: name ?? this.name);

  Map<String, Object?> toJson() => {'id': id, 'phone': phone, 'name': name};
}

/// `BuyerTokenResponse`.
class BuyerSession {
  const BuyerSession({required this.token, required this.user});

  factory BuyerSession.fromJson(Map<String, dynamic> json) {
    return BuyerSession(
      token: _str(json['token']) ?? '',
      user: BuyerUser.fromJson(
        Map<String, dynamic>.from(json['user'] as Map? ?? const {}),
      ),
    );
  }

  final String token;
  final BuyerUser user;
}

// ----------------------------------------------------------- Geo & address

/// `BuyerNeighborhood`.
class Neighborhood {
  const Neighborhood({
    required this.id,
    required this.name,
    required this.slug,
    required this.isOpen,
    required this.cityId,
  });

  factory Neighborhood.fromJson(Map<String, dynamic> json) {
    return Neighborhood(
      id: _int(json['id']) ?? 0,
      name: _str(json['name']) ?? '',
      slug: _str(json['slug']) ?? '',
      isOpen: _bool(json['is_open']),
      cityId: _int(json['city_id']) ?? 0,
    );
  }

  final int id;
  final String name;
  final String slug;
  final bool isOpen;
  final int cityId;
}

/// `BuyerAddress`.
class BuyerAddress {
  const BuyerAddress({
    required this.id,
    required this.lat,
    required this.lng,
    this.label,
    this.landmark,
    this.neighborhoodId,
    this.neighborhoodName,
    this.isDefault = false,
  });

  factory BuyerAddress.fromJson(Map<String, dynamic> json) {
    return BuyerAddress(
      id: _int(json['id']) ?? 0,
      lat: _double(json['lat']) ?? 0,
      lng: _double(json['lng']) ?? 0,
      label: _str(json['label']),
      landmark: _str(json['landmark']),
      neighborhoodId: _int(json['neighborhood_id']),
      neighborhoodName: _str(json['neighborhood_name']),
      isDefault: _bool(json['is_default']),
    );
  }

  final int id;
  final double lat;
  final double lng;
  final String? label;
  final String? landmark;
  final int? neighborhoodId;
  final String? neighborhoodName;

  /// Client-side preference; the contract has no default flag yet.
  final bool isDefault;

  String get title => (label == null || label!.isEmpty) ? 'عنوان' : label!;

  String get summary => [
    if (neighborhoodName != null) neighborhoodName!,
    'حمص',
    if (landmark != null && landmark!.isNotEmpty) landmark!,
  ].join('، ');

  BuyerAddress copyWith({
    int? id,
    String? label,
    String? landmark,
    int? neighborhoodId,
    String? neighborhoodName,
    double? lat,
    double? lng,
    bool? isDefault,
  }) {
    return BuyerAddress(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      label: label ?? this.label,
      landmark: landmark ?? this.landmark,
      neighborhoodId: neighborhoodId ?? this.neighborhoodId,
      neighborhoodName: neighborhoodName ?? this.neighborhoodName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'lat': lat,
    'lng': lng,
    'label': label,
    'landmark': landmark,
    'neighborhood_id': neighborhoodId,
    'neighborhood_name': neighborhoodName,
    'is_default': isDefault,
  };
}

// --------------------------------------------------------------------- Cart

/// `CartLine` plus the card fields the cart screen needs to draw the line.
class CartLine {
  const CartLine({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.storeId,
    required this.storeName,
    this.productRef,
    this.productOptionId,
    this.optionLabel,
    this.photoUrl,
    this.storeSlug,
    this.priceSyp,
    this.priceIsEstimate = false,
    this.available = true,
    this.canPurchase = true,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    return CartLine(
      id: _int(json['id']) ?? 0,
      productId: _int(json['product_id']) ?? 0,
      productName: _str(json['product_name']) ?? '',
      quantity: _int(json['quantity']) ?? 1,
      storeId: _int(json['store_id']) ?? 0,
      storeName: _str(json['store_name']) ?? '',
      productRef: _str(json['product_ref']),
      productOptionId: _int(json['product_option_id']),
      optionLabel: _str(json['option_label']),
      photoUrl: _str(json['photo']),
      storeSlug: _str(json['store_slug']),
      priceSyp: _int(json['price_syp']),
      priceIsEstimate: _bool(json['price_is_estimate']),
      available: _bool(json['available'], true),
      canPurchase: _bool(json['can_purchase'], true),
    );
  }

  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final int storeId;
  final String storeName;
  final String? productRef;
  final int? productOptionId;
  final String? optionLabel;
  final String? photoUrl;
  final String? storeSlug;

  /// Unit price.
  final int? priceSyp;
  final bool priceIsEstimate;
  final bool available;
  final bool canPurchase;

  bool get purchasable => available && canPurchase;

  int? get lineTotalSyp => priceSyp == null ? null : priceSyp! * quantity;

  /// Same product and option merge into one line.
  bool sameItem(int product, int? option) =>
      productId == product && productOptionId == option;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      id: id,
      productId: productId,
      productName: productName,
      quantity: quantity ?? this.quantity,
      storeId: storeId,
      storeName: storeName,
      productRef: productRef,
      productOptionId: productOptionId,
      optionLabel: optionLabel,
      photoUrl: photoUrl,
      storeSlug: storeSlug,
      priceSyp: priceSyp,
      priceIsEstimate: priceIsEstimate,
      available: available,
      canPurchase: canPurchase,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'store_id': storeId,
    'store_name': storeName,
    'product_ref': productRef,
    'product_option_id': productOptionId,
    'option_label': optionLabel,
    'photo': photoUrl,
    'store_slug': storeSlug,
    'price_syp': priceSyp,
    'price_is_estimate': priceIsEstimate,
    'available': available,
    'can_purchase': canPurchase,
    'line_total_syp': lineTotalSyp,
  };
}

/// `CartStoreGroup`.
class CartStoreGroup {
  const CartStoreGroup({
    required this.storeId,
    required this.storeName,
    required this.lines,
    required this.deliveryFeeSyp,
    this.storeSlug,
  });

  final int storeId;
  final String storeName;
  final String? storeSlug;
  final List<CartLine> lines;
  final int deliveryFeeSyp;

  int? get itemsTotalSyp {
    var total = 0;
    var priced = false;
    for (final line in lines) {
      final value = line.lineTotalSyp;
      if (value == null || !line.purchasable) continue;
      total += value;
      priced = true;
    }
    return priced ? total : null;
  }
}

/// A coupon the cart accepted.
class AppliedCoupon {
  const AppliedCoupon({required this.code, required this.discountSyp});

  final String code;
  final int discountSyp;
}

/// `CartSummary`, computed from lines by [CartCalculator].
class CartSummary {
  const CartSummary({
    required this.groups,
    required this.itemsTotalSyp,
    required this.deliveryFeePerStoreSyp,
    required this.deliveryFeeTotalSyp,
    required this.discountTotalSyp,
    required this.grandTotalSyp,
    required this.coupons,
    required this.itemCount,
    required this.hasUnpricedLines,
    required this.hasBlockedLines,
  });

  static const empty = CartSummary(
    groups: [],
    itemsTotalSyp: null,
    deliveryFeePerStoreSyp: 0,
    deliveryFeeTotalSyp: 0,
    discountTotalSyp: 0,
    grandTotalSyp: null,
    coupons: [],
    itemCount: 0,
    hasUnpricedLines: false,
    hasBlockedLines: false,
  );

  final List<CartStoreGroup> groups;
  final int? itemsTotalSyp;
  final int deliveryFeePerStoreSyp;
  final int deliveryFeeTotalSyp;
  final int discountTotalSyp;

  /// Null while any purchasable line has no price: the total is not honest.
  final int? grandTotalSyp;
  final List<AppliedCoupon> coupons;

  /// Total quantity across lines (the cart badge convention).
  final int itemCount;
  final bool hasUnpricedLines;
  final bool hasBlockedLines;

  bool get isEmpty => groups.isEmpty;
  int get storeCount => groups.length;
  bool get canCheckout => !isEmpty && grandTotalSyp != null && !hasBlockedLines;
}

/// Pure cart arithmetic so totals are testable without widgets.
abstract final class CartCalculator {
  static CartSummary summarize(
    List<CartLine> lines, {
    required int deliveryFeePerStoreSyp,
    List<AppliedCoupon> coupons = const [],
  }) {
    if (lines.isEmpty) return CartSummary.empty;
    final byStore = <int, List<CartLine>>{};
    for (final line in lines) {
      byStore.putIfAbsent(line.storeId, () => []).add(line);
    }
    final groups = [
      for (final entry in byStore.entries)
        CartStoreGroup(
          storeId: entry.key,
          storeName: entry.value.first.storeName,
          storeSlug: entry.value.first.storeSlug,
          lines: entry.value,
          deliveryFeeSyp: deliveryFeePerStoreSyp,
        ),
    ];
    var items = 0;
    var count = 0;
    var unpriced = false;
    var blocked = false;
    for (final line in lines) {
      count += line.quantity;
      if (!line.purchasable) {
        blocked = true;
        continue;
      }
      final total = line.lineTotalSyp;
      if (total == null) {
        unpriced = true;
      } else {
        items += total;
      }
    }
    final delivery = deliveryFeePerStoreSyp * groups.length;
    var discount = 0;
    for (final coupon in coupons) {
      discount += coupon.discountSyp;
    }
    if (discount > items) discount = items;
    return CartSummary(
      groups: groups,
      itemsTotalSyp: items,
      deliveryFeePerStoreSyp: deliveryFeePerStoreSyp,
      deliveryFeeTotalSyp: delivery,
      discountTotalSyp: discount,
      grandTotalSyp: unpriced ? null : items - discount + delivery,
      coupons: coupons,
      itemCount: count,
      hasUnpricedLines: unpriced,
      hasBlockedLines: blocked,
    );
  }
}

// ----------------------------------------------------------------- Checkout

enum DeliveryMethod { courier, pickup }

/// `/delivery/slots` item.
class DeliverySlot {
  const DeliverySlot({required this.id, required this.label});

  factory DeliverySlot.fromJson(Map<String, dynamic> json) => DeliverySlot(
    id: _str(json['id']) ?? '${json['id']}',
    label: _str(json['label_ar']) ?? _str(json['label']) ?? '',
  );

  final String id;
  final String label;
}

/// `/pickup-points` item.
class PickupPoint {
  const PickupPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.hours,
  });

  factory PickupPoint.fromJson(Map<String, dynamic> json) => PickupPoint(
    id: _int(json['id']) ?? 0,
    name: _str(json['name']) ?? '',
    address: _str(json['address']) ?? '',
    hours: _str(json['hours']) ?? '',
  );

  final int id;
  final String name;
  final String address;
  final String hours;
}

/// `BuyerPaymentGuideMethod`.
class PaymentMethodGuide {
  const PaymentMethodGuide({
    required this.method,
    required this.label,
    required this.steps,
  });

  factory PaymentMethodGuide.fromJson(Map<String, dynamic> json) {
    return PaymentMethodGuide(
      method: _str(json['method']) ?? '',
      label: _str(json['label_ar']) ?? '',
      steps: [
        if (json['steps_ar'] is List)
          for (final step in json['steps_ar'] as List)
            if (step is String) step,
      ],
    );
  }

  final String method;
  final String label;
  final List<String> steps;
}

/// `CheckoutStoreOrder`.
class CheckoutStoreOrder {
  const CheckoutStoreOrder({
    required this.publicId,
    required this.storeName,
    required this.status,
    this.itemsTotalSyp,
    this.deliveryFeeSyp,
  });

  factory CheckoutStoreOrder.fromJson(Map<String, dynamic> json) {
    return CheckoutStoreOrder(
      publicId: _str(json['public_id']) ?? '',
      storeName: _str(json['store_name']) ?? '',
      status: _str(json['status']) ?? 'pending_payment',
      itemsTotalSyp: _int(json['items_total_syp']),
      deliveryFeeSyp: _int(json['delivery_fee_syp']),
    );
  }

  final String publicId;
  final String storeName;
  final String status;
  final int? itemsTotalSyp;
  final int? deliveryFeeSyp;
}

/// `BuyerCheckout`.
class CheckoutResult {
  const CheckoutResult({
    required this.publicId,
    required this.status,
    required this.paymentStatus,
    required this.storeOrders,
    this.itemsTotalSyp,
    this.deliveryFeeTotalSyp,
    this.grandTotalSyp,
    this.expiresAt,
    this.deliveryPromise,
    this.sample = false,
  });

  factory CheckoutResult.fromJson(
    Map<String, dynamic> json, {
    bool sample = false,
  }) {
    final promise = json['delivery_promise'];
    return CheckoutResult(
      publicId: _str(json['public_id']) ?? '',
      status: _str(json['status']) ?? 'pending_payment',
      paymentStatus: _str(json['payment_status']) ?? 'unpaid',
      itemsTotalSyp: _int(json['items_total_syp']),
      deliveryFeeTotalSyp: _int(json['delivery_fee_total_syp']),
      grandTotalSyp: _int(json['grand_total_syp']),
      expiresAt: _date(json['expires_at']),
      deliveryPromise: promise is Map ? _str(promise['message_ar']) : null,
      storeOrders: [
        for (final item in _maps(json['store_orders']))
          CheckoutStoreOrder.fromJson(item),
      ],
      sample: sample,
    );
  }

  final String publicId;
  final String status;
  final String paymentStatus;
  final List<CheckoutStoreOrder> storeOrders;
  final int? itemsTotalSyp;
  final int? deliveryFeeTotalSyp;
  final int? grandTotalSyp;
  final DateTime? expiresAt;
  final String? deliveryPromise;
  final bool sample;

  String get shortId => publicId.length > 8
      ? publicId.substring(0, 8).toUpperCase()
      : publicId.toUpperCase();
}

// ------------------------------------------------------------------- Orders

/// Order status keys from the backend and their Arabic labels.
abstract final class OrderStatus {
  static const labels = <String, String>{
    'pending_payment': 'بانتظار الدفع',
    'payment_pending_review': 'الدفع قيد المراجعة',
    'paid': 'مدفوع',
    'accepted_by_store': 'مقبول',
    'preparing': 'قيد التجهيز',
    'ready_for_pickup': 'جاهز للاستلام',
    'out_for_delivery': 'خرج للتوصيل',
    'delivered': 'تم التسليم',
    'completed': 'مكتمل',
    'cancelled': 'ملغى',
    'rejected_by_supplier': 'مرفوض من المتجر',
  };

  /// The happy path drawn by the timeline.
  static const flow = <String>[
    'pending_payment',
    'paid',
    'accepted_by_store',
    'preparing',
    'out_for_delivery',
    'delivered',
  ];

  static String label(String status) => labels[status] ?? status;

  static bool isClosed(String status) =>
      const {'cancelled', 'rejected_by_supplier'}.contains(status);

  static bool isDone(String status) =>
      const {'delivered', 'completed'}.contains(status);

  static bool isActive(String status) => !isClosed(status) && !isDone(status);

  /// Before the store prepares the goods, a cancellation can be requested.
  static bool canRequestCancel(String status) => const {
    'pending_payment',
    'payment_pending_review',
    'paid',
    'accepted_by_store',
  }.contains(status);
}

/// Filter tabs on «طلباتي».
enum OrderFilter {
  all,
  awaitingPayment,
  inProgress,
  onTheWay,
  delivered,
  closed,
}

extension OrderFilterMatch on OrderFilter {
  bool matches(String status) => switch (this) {
    OrderFilter.all => true,
    OrderFilter.awaitingPayment => const {
      'pending_payment',
      'payment_pending_review',
    }.contains(status),
    OrderFilter.inProgress => const {
      'paid',
      'accepted_by_store',
      'preparing',
      'ready_for_pickup',
    }.contains(status),
    OrderFilter.onTheWay => status == 'out_for_delivery',
    OrderFilter.delivered => OrderStatus.isDone(status),
    OrderFilter.closed => OrderStatus.isClosed(status),
  };
}

/// `BuyerOrderListItem`.
class OrderListItem {
  const OrderListItem({
    required this.publicId,
    required this.storeName,
    required this.status,
    required this.statusLabel,
    this.itemsTotalSyp,
    this.deliveryFeeSyp,
    this.deliveryPromise,
    this.createdAt,
  });

  factory OrderListItem.fromJson(Map<String, dynamic> json) {
    final status = _str(json['status']) ?? '';
    final promise = json['delivery_promise'];
    return OrderListItem(
      publicId: _str(json['public_id']) ?? '',
      storeName: _str(json['store_name']) ?? '',
      status: status,
      statusLabel: _str(json['status_label_ar']) ?? OrderStatus.label(status),
      itemsTotalSyp: _int(json['items_total_syp']),
      deliveryFeeSyp: _int(json['delivery_fee_syp']),
      deliveryPromise: promise is Map ? _str(promise['message_ar']) : null,
      createdAt: _date(json['created_at']),
    );
  }

  final String publicId;
  final String storeName;
  final String status;
  final String statusLabel;
  final int? itemsTotalSyp;
  final int? deliveryFeeSyp;
  final String? deliveryPromise;
  final DateTime? createdAt;

  int? get totalSyp =>
      itemsTotalSyp == null ? null : itemsTotalSyp! + (deliveryFeeSyp ?? 0);

  String get shortId => publicId.length > 8
      ? publicId.substring(0, 8).toUpperCase()
      : publicId.toUpperCase();
}

/// `BuyerOrderLine`.
class OrderLine {
  const OrderLine({
    required this.id,
    required this.productName,
    required this.quantity,
    this.optionLabel,
    this.unitPriceSyp,
    this.lineTotalSyp,
    this.productId,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
    id: _int(json['id']) ?? 0,
    productName: _str(json['product_name_ar']) ?? '',
    optionLabel: _str(json['option_label_ar']),
    quantity: _int(json['quantity']) ?? 1,
    unitPriceSyp: _int(json['unit_price_syp']),
    lineTotalSyp: _int(json['line_total_syp']),
    productId: _int(json['product_id']),
  );

  final int id;
  final String productName;
  final String? optionLabel;
  final int quantity;
  final int? unitPriceSyp;
  final int? lineTotalSyp;
  final int? productId;
}

/// `BuyerOrderStatusHistory`.
class OrderStatusChange {
  const OrderStatusChange({
    required this.toStatus,
    required this.toLabel,
    this.fromStatus,
    this.at,
  });

  factory OrderStatusChange.fromJson(Map<String, dynamic> json) {
    final to = _str(json['to_status']) ?? '';
    return OrderStatusChange(
      fromStatus: _str(json['from_status']),
      toStatus: to,
      toLabel: _str(json['to_status_label_ar']) ?? OrderStatus.label(to),
      at: _date(json['at']),
    );
  }

  final String? fromStatus;
  final String toStatus;
  final String toLabel;
  final DateTime? at;
}

/// `BuyerOrderDetail`.
class OrderDetail {
  const OrderDetail({
    required this.summary,
    required this.lines,
    required this.history,
    this.notes,
    this.addressSummary,
    this.paymentMethodLabel,
    this.cancellationPending = false,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      summary: OrderListItem.fromJson(json),
      lines: [
        for (final item in _maps(json['lines'])) OrderLine.fromJson(item),
      ],
      history: [
        for (final item in _maps(json['status_history']))
          OrderStatusChange.fromJson(item),
      ],
      notes: _str(json['notes']),
      addressSummary: _str(json['address_summary']),
      paymentMethodLabel: _str(json['payment_method_label_ar']),
      cancellationPending: _maps(json['cancellation_requests'])
          .any((item) => item['status'] == 'pending'),
    );
  }

  final OrderListItem summary;
  final List<OrderLine> lines;
  final List<OrderStatusChange> history;
  final String? notes;
  final String? addressSummary;
  final String? paymentMethodLabel;
  final bool cancellationPending;
}

// ------------------------------------------------------- Engagement & help

/// `BuyerNotification`.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.eventKey,
    required this.title,
    required this.body,
    this.readAt,
    this.createdAt,
    this.orderPublicId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: _int(json['id']) ?? 0,
      eventKey: _str(json['event_key']) ?? '',
      title: _str(json['title']) ?? '',
      body: _str(json['body']) ?? '',
      readAt: _date(json['read_at']),
      createdAt: _date(json['created_at']),
      orderPublicId: _str(json['order_public_id']),
    );
  }

  final int id;
  final String eventKey;
  final String title;
  final String body;
  final DateTime? readAt;
  final DateTime? createdAt;
  final String? orderPublicId;

  bool get isRead => readAt != null;

  AppNotification markRead(DateTime at) => AppNotification(
    id: id,
    eventKey: eventKey,
    title: title,
    body: body,
    readAt: readAt ?? at,
    createdAt: createdAt,
    orderPublicId: orderPublicId,
  );
}

/// `BuyerNotificationPreferences`.
class NotificationPreferences {
  const NotificationPreferences({
    this.operationalInApp = true,
    this.operationalWhatsapp = true,
    this.operationalEmail = false,
    this.marketingWhatsapp = false,
    this.marketingEmail = false,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      operationalInApp: _bool(json['operational_in_app'], true),
      operationalWhatsapp: _bool(json['operational_whatsapp'], true),
      operationalEmail: _bool(json['operational_email']),
      marketingWhatsapp: _bool(json['marketing_whatsapp']),
      marketingEmail: _bool(json['marketing_email']),
    );
  }

  final bool operationalInApp;
  final bool operationalWhatsapp;
  final bool operationalEmail;
  final bool marketingWhatsapp;
  final bool marketingEmail;

  NotificationPreferences copyWith({
    bool? operationalInApp,
    bool? operationalWhatsapp,
    bool? operationalEmail,
    bool? marketingWhatsapp,
    bool? marketingEmail,
  }) {
    return NotificationPreferences(
      operationalInApp: operationalInApp ?? this.operationalInApp,
      operationalWhatsapp: operationalWhatsapp ?? this.operationalWhatsapp,
      operationalEmail: operationalEmail ?? this.operationalEmail,
      marketingWhatsapp: marketingWhatsapp ?? this.marketingWhatsapp,
      marketingEmail: marketingEmail ?? this.marketingEmail,
    );
  }
}

/// `BuyerReview`.
class Review {
  const Review({
    required this.id,
    required this.rating,
    required this.authorName,
    this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: _int(json['id']) ?? 0,
    rating: (_int(json['rating']) ?? 0).clamp(1, 5),
    comment: _str(json['comment']),
    authorName: _str(json['author_name']) ?? 'متسوّق',
    createdAt: _date(json['created_at']),
  );

  final int id;
  final int rating;
  final String? comment;
  final String authorName;
  final DateTime? createdAt;
}

/// `/help/categories` and `/help/articles` items.
class HelpArticle {
  const HelpArticle({
    required this.slug,
    required this.category,
    required this.title,
    required this.body,
  });

  factory HelpArticle.fromJson(Map<String, dynamic> json) => HelpArticle(
    slug: _str(json['slug']) ?? '',
    category: _str(json['category']) ?? '',
    title: _str(json['title']) ?? '',
    body: _str(json['body']) ?? '',
  );

  final String slug;
  final String category;
  final String title;
  final String body;
}

/// `/support/tickets` item.
class SupportTicket {
  const SupportTicket({
    required this.publicId,
    required this.subject,
    required this.status,
    this.orderPublicId,
    this.createdAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) => SupportTicket(
    publicId: _str(json['public_id']) ?? '',
    subject: _str(json['subject']) ?? '',
    status: _str(json['status']) ?? 'open',
    orderPublicId: _str(json['order_public_id']),
    createdAt: _date(json['created_at']),
  );

  final String publicId;
  final String subject;
  final String status;
  final String? orderPublicId;
  final DateTime? createdAt;

  String get statusLabel => switch (status) {
    'open' => 'مفتوحة',
    'pending' => 'بانتظار ردّك',
    'resolved' => 'تم الحل',
    'closed' => 'مغلقة',
    _ => status,
  };
}
