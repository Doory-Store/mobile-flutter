import 'dart:async';
import 'dart:io';

import 'package:doory_mobile/data/repositories/commerce/mock_repositories.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/mock_network_images.dart';

/// Runs before every test file: Mock repositories answer immediately so
/// widget tests never leave a pending latency timer behind, and network
/// images resolve from a 1x1 PNG instead of the network. Cairo and
/// Material Icons are loaded so goldens paint real glyphs, not Ahem boxes.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockLatency = Duration.zero;
  HttpOverrides.global = MockNetworkImageHttpOverrides();
  await _loadTestFonts();
  await testMain();
}

Future<void> _loadTestFonts() async {
  final cairo = FontLoader('Cairo')
    ..addFont(rootBundle.load('assets/fonts/Cairo-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Cairo-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Cairo-Bold.ttf'));
  await cairo.load();

  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final icons = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (!icons.existsSync()) return;
  final bytes = await icons.readAsBytes();
  final loader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}
