import 'dart:async';

import 'package:doory_mobile/core/format/cart_badge.dart';
import 'package:doory_mobile/core/format/price_format.dart';
import 'package:doory_mobile/core/theme/doory_colors.dart';
import 'package:doory_mobile/core/theme/doory_tokens.dart';
import 'package:doory_mobile/core/widgets/price_block.dart';
import 'package:doory_mobile/data/rebuild/mock_scenario.dart';
import 'package:doory_mobile/data/rebuild/rebuild_models.dart';
import 'package:doory_mobile/data/rebuild/rebuild_repository.dart';
import 'package:doory_mobile/data/repositories/repo_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatSyp keeps Latin digits and ل.س without a trailing dot', () {
    expect(formatSyp(1250), '\u20661,250 ل.س\u2069');
    expect(formatSyp(-1250), '\u2066-1,250 ل.س\u2069');
    expect(formatSyp(1250).endsWith('.\u2069'), isFalse);
  });

  test('cart badge hides zero and caps at 99+', () {
    expect(cartBadgeLabel(0), isNull);
    expect(cartBadgeLabel(3), '3');
    expect(cartBadgeLabel(99), '99');
    expect(cartBadgeLabel(120), '99+');
  });

  test('discount percent is a rounded honest ratio', () {
    expect(discountPercent(125000, 150000), 17);
    expect(discountPercent(43000, 43000), isNull);
    expect(discountPercent(null, 100), isNull);
    expect(discountPercent(100, 80), isNull);
  });

  test('tokens expose the new canvas, success surface, and spacing', () {
    const tokens = DooryTokens.light;
    expect(tokens.surfaceCanvas, DooryColors.surfaceCanvas);
    expect(tokens.successSurface, DooryColors.successSurface);
    expect(tokens.space.s6, 6);
    expect(tokens.space.gutterDense, 8);
    expect(tokens.radius4, 4);
    expect(tokens.radius6, 6);
    expect(tokens.radius12, 12);
    expect(tokens.sheetBarrier, DooryColors.sheetBarrier);
  });

  test('mock scenario returns data, empty, error, or a pending load', () async {
    final ok = const RebuildRepository(MockScenario.ok);
    final home = await ok.home();
    final loaded = home as RepoOk<RebuildHome>;
    expect(loaded.data.grid, isNotEmpty);
    expect(loaded.data.grid.first.sample, isTrue);

    final empty = await const RebuildRepository(MockScenario.empty).products();
    expect((empty as RepoOk<List<RebuildProduct>>).data, isEmpty);

    final missing = await const RebuildRepository(MockScenario.ok)
        .product('nope');
    expect(missing, isA<RepoNotFound>());

    final error = await const RebuildRepository(MockScenario.error).cart();
    expect(error, isA<RepoRejected>());

    final pending = const RebuildRepository(MockScenario.loading).favorites();
    expect(
      pending.timeout(const Duration(milliseconds: 30)),
      throwsA(isA<TimeoutException>()),
    );
  });
}
