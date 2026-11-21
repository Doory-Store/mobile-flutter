import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../favorites/favorites_controller.dart';
import '../providers.dart';
import 'commerce_contracts.dart';
import 'live_auth_repository.dart';
import 'mock_repositories.dart';

// One provider per commerce domain. Auth is live; the other domains return
// their Mock implementation until wired, which means returning the Live
// counterpart from `live_repositories.dart` here. Screens and controllers read only these
// providers, so nothing else changes when a domain goes live.

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => MockCartRepository(ref.watch(sharedPreferencesProvider)),
);

/// Live by default. `--dart-define=DOORY_AUTH=mock` keeps the offline demo
/// (code 482910) for tests and presentations without a network.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.authMode == AuthMode.mock) return MockAuthRepository();
  return LiveAuthRepository(ref.watch(apiTransportProvider));
});

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
