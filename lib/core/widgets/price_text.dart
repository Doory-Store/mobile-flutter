import 'package:material_ui/material_ui.dart';

import '../format/price_format.dart';
import '../l10n/doory_strings.dart';
import '../theme/doory_typography.dart';

enum PriceStyle { card, pdp, compact }

class PriceText extends StatelessWidget {
  const PriceText({
    required this.amount,
    this.estimate = false,
    this.style = PriceStyle.card,
    super.key,
  });

  final int? amount;
  final bool estimate;
  final PriceStyle style;

  @override
  Widget build(BuildContext context) {
    if (amount == null) return const SizedBox.shrink();
    final priceStyle = switch (style) {
      PriceStyle.card => DooryTypography.cardPrice(context),
      PriceStyle.pdp => DooryTypography.pdpPrice(context),
      PriceStyle.compact => DooryTypography.compactPrice(context),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatSyp(amount!), style: priceStyle),
        if (estimate)
          Text(DooryStrings.estimate, style: DooryTypography.cardMeta(context)),
      ],
    );
  }
}
