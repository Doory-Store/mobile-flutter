import 'dart:async';
import 'dart:io';

import 'package:doory_mobile/data/repositories/commerce/mock_repositories.dart';

import 'support/mock_network_images.dart';

/// Runs before every test file: Mock repositories answer immediately so
/// widget tests never leave a pending latency timer behind, and network
/// images resolve from a 1x1 PNG instead of the network.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  mockLatency = Duration.zero;
  HttpOverrides.global = MockNetworkImageHttpOverrides();
  await testMain();
}
