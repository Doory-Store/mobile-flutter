import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../favorites/favorites_controller.dart';
import 'commerce_contracts.dart';
import 'mock_repositories.dart';

// One provider per commerce domain. Each returns the Mock implementation
// today; wiring a domain means returning its Live counterpart from
// `live_repositories.dart` here. Screens and controllers read only these
// providers, so nothing else changes when a domain goes live.

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => MockCartRepository(ref.watch(sharedPreferencesProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(),
);

final addressRepositoryProvider = Provider<AddressRepository>(
  (ref) => MockAddressRepository(),
);

final checkoutRepositoryProvider = Provider<CheckoutRepository>(
  (ref) => MockCheckoutRepository(),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => MockOrderRepository(),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => MockNotificationRepository(),
);

final engagementRepositoryProvider = Provider<EngagementRepository>(
  (ref) => MockEngagementRepository(),
);
