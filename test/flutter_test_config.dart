import 'dart:async';

import 'package:doory_mobile/data/repositories/commerce/mock_repositories.dart';

/// Runs before every test file: Mock repositories answer immediately so
/// widget tests never leave a pending latency timer behind.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  mockLatency = Duration.zero;
  await testMain();
}
