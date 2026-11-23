import 'package:material_ui/material_ui.dart';

import '../format/price_format.dart';
import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum PriceBlockSize { card, compact, large }

/// Whole-number discount when the reference price is higher. Null hides it.
int? discountPercent(int? priceSyp, int? compareAtSyp) {
  if (priceSyp == null || compareAtSyp == null) return null;
  if (compareAtSyp <= priceSyp || compareAtSyp == 0) return null;
  return (((compareAtSyp - priceSyp) * 100) / compareAtSyp).round();
}

/// Current price, optional struck reference, and an honest discount.
class PriceBlock extends StatelessWidget {
  const PriceBlock({
    required this.priceSyp,
    this.compareAtSyp,
    this.estimate = false,
    this.size = PriceBlockSize.card,
    super.key,
  });

  final int? priceSyp;
  final int? compareAtSyp;
  final bool estimate;
  final PriceBlockSize size;

  @override
  Widget build(BuildContext context) {
    final price = priceSyp;
    if (price == null) return const SizedBox.shrink();
    final percent = discountPercent(price, compareAtSyp);
    final showCompare = percent != null;
    final priceStyle = switch (size) {
      PriceBlockSize.card => DooryTypography.price(context),
      PriceBlockSize.compact => DooryTypography.priceCompact(context),
      PriceBlockSize.large => DooryTypography.priceLarge(context),
    };
    final parts = <String>[
      formatSyp(price),
      if (showCompare) DooryStrings.insteadOf(formatSyp(compareAtSyp!)),
      if (showCompare) DooryStrings.discountSpoken(percent),
      if (estimate) DooryStrings.estimate,
    ];
    return Semantics(
      label: parts.join('، '),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(formatSyp(price), style: priceStyle),
                if (showCompare)
                  Text(
                    formatSyp(compareAtSyp!),
                    style: DooryTypography.strike(context),
                  ),
                if (showCompare)
                  Text(
                    DooryStrings.discountPercent(percent),
                    style: DooryTypography.captionStrong(context)
                        .copyWith(color: DooryTokens.of(context).danger),
                  ),
              ],
            ),
            if (estimate)
              Text(
                DooryStrings.estimate,
                style: DooryTypography.caption(context),
              ),
          ],
        ),
      ),
    );
  }
}
