import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_providers.dart';

// ---------------------------------------------------------------- Addresses

class AddressesController extends AsyncNotifier<List<BuyerAddress>> {
  @override
  Future<List<BuyerAddress>> build() =>
      ref.watch(addressRepositoryProvider).list();

  Future<void> save(BuyerAddress address) async {
    final next = await ref.read(addressRepositoryProvider).save(address);
    state = AsyncData(next);
  }

  Future<void> delete(int id) async {
    final next = await ref.read(addressRepositoryProvider).delete(id);
    state = AsyncData(next);
  }

  Future<void> setDefault(int id) async {
    final next = await ref.read(addressRepositoryProvider).setDefault(id);
    state = AsyncData(next);
  }
}

final addressesProvider =
    AsyncNotifierProvider<AddressesController, List<BuyerAddress>>(
      AddressesController.new,
    );

final neighborhoodsProvider = FutureProvider<List<Neighborhood>>(
  (ref) => ref.watch(addressRepositoryProvider).neighborhoods(),
);

// ------------------------------------------------------------------- Orders

final ordersProvider = FutureProvider.autoDispose<List<OrderListItem>>(
  (ref) => ref.watch(orderRepositoryProvider).list(),
);

final orderDetailProvider = FutureProvider.autoDispose
    .family<OrderDetail?, String>(
      (ref, id) => ref.watch(orderRepositoryProvider).detail(id),
    );

// ------------------------------------------------------------ Notifications

class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() =>
      ref.watch(notificationRepositoryProvider).list();

  Future<void> markRead(int id) async {
    state = AsyncData(
      await ref.read(notificationRepositoryProvider).markRead(id),
    );
  }

  Future<void> markAllRead() async {
    state = AsyncData(
      await ref.read(notificationRepositoryProvider).markAllRead(),
    );
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsController, List<AppNotification>>(
      NotificationsController.new,
    );

final unreadNotificationsProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider).asData?.value ?? const [];
  return items.where((item) => !item.isRead).length;
});

class NotificationPrefsController
    extends AsyncNotifier<NotificationPreferences> {
  @override
  Future<NotificationPreferences> build() =>
      ref.watch(notificationRepositoryProvider).preferences();

  Future<void> save(NotificationPreferences next) async {
    state = AsyncData(next);
    state = AsyncData(
      await ref.read(notificationRepositoryProvider).updatePreferences(next),
    );
  }
}

final notificationPrefsProvider =
    AsyncNotifierProvider<NotificationPrefsController, NotificationPreferences>(
      NotificationPrefsController.new,
    );

// --------------------------------------------------------------- Engagement

final productReviewsProvider = FutureProvider.autoDispose
    .family<List<Review>, int>(
      (ref, id) => ref.watch(engagementRepositoryProvider).productReviews(id),
    );

final storeReviewsProvider = FutureProvider.autoDispose
    .family<List<Review>, String>(
      (ref, slug) => ref.watch(engagementRepositoryProvider).storeReviews(slug),
    );

final helpArticlesProvider = FutureProvider<List<HelpArticle>>(
  (ref) => ref.watch(engagementRepositoryProvider).helpArticles(),
);

final ticketsProvider = FutureProvider.autoDispose<List<SupportTicket>>(
  (ref) => ref.watch(engagementRepositoryProvider).tickets(),
);

// ----------------------------------------------------------------- Checkout

final paymentGuideProvider = FutureProvider<List<PaymentMethodGuide>>(
  (ref) => ref.watch(checkoutRepositoryProvider).paymentGuide(),
);

final deliverySlotsProvider = FutureProvider<List<DeliverySlot>>(
  (ref) => ref.watch(checkoutRepositoryProvider).deliverySlots(),
);

final pickupPointsProvider = FutureProvider<List<PickupPoint>>(
  (ref) => ref.watch(checkoutRepositoryProvider).pickupPoints(),
);

/// The checkout the confirmation screen shows.
final lastCheckoutProvider = StateProvider<CheckoutResult?>((ref) => null);
