// Live implementations of the commerce contracts.
//
// Each method names the buyer endpoint it maps to (see the backend
// `docs/openapi/buyer-v1.yaml`). Auth is wired in `live_auth_repository.dart`;
// the domains below throw [NotWiredException] until their business rules are
// approved. Switching a provider in `commerce_providers.dart` from Mock to
// Live is the wiring step.

import '../../models/commerce_models.dart';
import 'commerce_contracts.dart';

Never _todo(String endpoint) => throw NotWiredException(endpoint);

class LiveCartRepository implements CartRepository {
  @override
  bool get isSample => false;
  @override
  int get deliveryFeePerStoreSyp => 0;
  @override
  Future<CartSnapshot> load() async => _todo('GET /carts/{public_id}');
  @override
  Future<CartSnapshot> addLine(CartLineDraft draft) async =>
      _todo('POST /carts/{public_id}/lines');
  @override
  Future<CartSnapshot> updateQuantity(int lineId, int quantity) async =>
      _todo('PATCH /carts/{public_id}/lines/{line}');
  @override
  Future<CartSnapshot> removeLine(int lineId) async =>
      _todo('DELETE /carts/{public_id}/lines/{line}');
  @override
  Future<CartSnapshot> applyCoupon(String code) async =>
      _todo('POST /carts/{public_id}/coupons');
  @override
  Future<CartSnapshot> removeCoupon(String code) async =>
      _todo('DELETE /carts/{public_id}/coupons/{code}');
  @override
  Future<CartSnapshot> clear() async => _todo('POST /carts');
}

class LiveAddressRepository implements AddressRepository {
  @override
  bool get isSample => false;
  @override
  Future<List<BuyerAddress>> list() async => _todo('GET /addresses');
  @override
  Future<List<Neighborhood>> neighborhoods({int cityId = 1}) async =>
      _todo('GET /neighborhoods?city_id=');
  @override
  Future<List<BuyerAddress>> save(BuyerAddress address) async =>
      _todo('POST /addresses | PATCH /addresses/{id}');
  @override
  Future<List<BuyerAddress>> delete(int id) async =>
      _todo('DELETE /addresses/{id}');
  @override
  Future<List<BuyerAddress>> setDefault(int id) async =>
      _todo('no contract: default address');
}

class LiveCheckoutRepository implements CheckoutRepository {
  @override
  bool get isSample => false;
  @override
  Map<String, String> get receivingAccounts => const {};
  @override
  Future<List<PaymentMethodGuide>> paymentGuide() async =>
      _todo('GET /payment-guide');
  @override
  Future<List<DeliverySlot>> deliverySlots() async =>
      _todo('GET /delivery/slots');
  @override
  Future<List<PickupPoint>> pickupPoints() async => _todo('GET /pickup-points');
  @override
  Future<CheckoutResult> previewCheckout(
    CheckoutDraft draft,
    CartSummary cart,
  ) async => _todo('POST /checkouts');
}

class LiveOrderRepository implements OrderRepository {
  @override
  bool get isSample => false;
  @override
  Future<List<OrderListItem>> list() async => _todo('GET /orders');
  @override
  Future<OrderDetail?> detail(String publicId) async =>
      _todo('GET /orders/{public_id}');
}

class LiveNotificationRepository implements NotificationRepository {
  @override
  bool get isSample => false;
  @override
  Future<List<AppNotification>> list() async => _todo('GET /notifications');
  @override
  Future<List<AppNotification>> markRead(int id) async =>
      _todo('POST /notifications/{id}/read');
  @override
  Future<List<AppNotification>> markAllRead() async =>
      _todo('POST /notifications/{id}/read (each)');
  @override
  Future<NotificationPreferences> preferences() async =>
      _todo('GET /me/notification-preferences');
  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences next,
  ) async => _todo('PATCH /me/notification-preferences');
}

class LiveEngagementRepository implements EngagementRepository {
  @override
  bool get isSample => false;
  @override
  String get supportPhone => '';
  @override
  String get supportWhatsapp => '';
  @override
  Future<List<Review>> productReviews(int productId) async =>
      _todo('GET /products/{id}/reviews');
  @override
  Future<List<Review>> storeReviews(String slug) async =>
      _todo('GET /stores/{slug}/reviews');
  @override
  Future<List<HelpArticle>> helpArticles() async => _todo('GET /help/articles');
  @override
  Future<List<SupportTicket>> tickets() async => _todo('GET /support/tickets');
}
