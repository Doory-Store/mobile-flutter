// Repository contracts for the commerce domains.
//
// Every domain has one interface, a Mock implementation fed by
// `MockFixtures`, and a Live implementation that names the buyer endpoint it
// will call. Screens depend on the interface through the providers in
// `commerce_providers.dart`, so wiring a domain means switching its provider
// from Mock to Live.

import '../../models/catalog_models.dart';
import '../../models/commerce_models.dart';

/// A request the server would refuse (wrong code, invalid coupon, closed
/// area). [message] is shopper-facing MSA.
class DomainRejection implements Exception {
  const DomainRejection(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thrown by Live repositories whose endpoint is not wired yet.
class NotWiredException implements Exception {
  const NotWiredException(this.endpoint);

  final String endpoint;

  @override
  String toString() => 'Not wired: $endpoint';
}

/// Lines and coupons as the cart holds them.
class CartSnapshot {
  const CartSnapshot({this.lines = const [], this.coupons = const []});

  final List<CartLine> lines;
  final List<AppliedCoupon> coupons;
}

/// What the PDP sends when adding to the cart.
class CartLineDraft {
  const CartLineDraft({
    required this.product,
    required this.quantity,
    this.optionId,
    this.optionLabel,
    this.storeId,
  });

  final ProductCardModel product;
  final int quantity;
  final int? optionId;
  final String? optionLabel;
  final int? storeId;
}

/// `/carts` and `/carts/{public_id}/*`.
abstract interface class CartRepository {
  bool get isSample;
  int get deliveryFeePerStoreSyp;
  Future<CartSnapshot> load();
  Future<CartSnapshot> addLine(CartLineDraft draft);
  Future<CartSnapshot> updateQuantity(int lineId, int quantity);
  Future<CartSnapshot> removeLine(int lineId);
  Future<CartSnapshot> applyCoupon(String code);
  Future<CartSnapshot> removeCoupon(String code);
  Future<CartSnapshot> clear();
}

/// `/auth/otp`, `/auth/otp/verify`, `/auth/logout`, `/me`.
abstract interface class AuthRepository {
  bool get isSample;
  Future<OtpChallenge> requestOtp(String phone);
  Future<BuyerSession> verifyOtp(String phone, String code);
  Future<BuyerUser> updateName(String name);
  Future<void> logout();
}

/// `/addresses`, `/neighborhoods`.
abstract interface class AddressRepository {
  bool get isSample;
  Future<List<BuyerAddress>> list();
  Future<List<Neighborhood>> neighborhoods({int cityId = 1});
  Future<List<BuyerAddress>> save(BuyerAddress address);
  Future<List<BuyerAddress>> delete(int id);
  Future<List<BuyerAddress>> setDefault(int id);
}

/// What the checkout screen collects.
class CheckoutDraft {
  const CheckoutDraft({
    required this.method,
    required this.paymentMethod,
    this.addressId,
    this.pickupPointId,
    this.slotId,
    this.notes,
  });

  final DeliveryMethod method;
  final String paymentMethod;
  final int? addressId;
  final int? pickupPointId;
  final String? slotId;
  final String? notes;
}

/// `/payment-guide`, `/delivery/slots`, `/pickup-points`, `/checkouts`.
abstract interface class CheckoutRepository {
  bool get isSample;
  Future<List<PaymentMethodGuide>> paymentGuide();
  Future<List<DeliverySlot>> deliverySlots();
  Future<List<PickupPoint>> pickupPoints();
  Map<String, String> get receivingAccounts;

  /// Builds the checkout record. The sample implementation returns a labelled
  /// preview; nothing reaches a store.
  Future<CheckoutResult> previewCheckout(CheckoutDraft draft, CartSummary cart);
}

/// `/orders`, `/orders/{public_id}`, `/orders/{public_id}/reorder`.
abstract interface class OrderRepository {
  bool get isSample;
  Future<List<OrderListItem>> list();
  Future<OrderDetail?> detail(String publicId);
}

/// `/notifications`, `/me/notification-preferences`.
abstract interface class NotificationRepository {
  bool get isSample;
  Future<List<AppNotification>> list();
  Future<List<AppNotification>> markRead(int id);
  Future<List<AppNotification>> markAllRead();
  Future<NotificationPreferences> preferences();
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences next,
  );
}

/// Reviews, help center, and support tickets.
abstract interface class EngagementRepository {
  bool get isSample;
  Future<List<Review>> productReviews(int productId);
  Future<List<Review>> storeReviews(String slug);
  Future<List<HelpArticle>> helpArticles();
  Future<List<SupportTicket>> tickets();
  String get supportPhone;
  String get supportWhatsapp;
}
