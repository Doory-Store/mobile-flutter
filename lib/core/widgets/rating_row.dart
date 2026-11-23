import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

/// Five stars, a one-decimal score, and an optional review count.
class RatingRow extends StatelessWidget {
  const RatingRow({required this.rating, this.count, super.key});

  final double? rating;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final value = rating;
    if (value == null) return const SizedBox.shrink();
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final showCount = count != null && count! > 0;
    return Semantics(
      label: DooryStrings.ratingSpoken(value, count),
      child: ExcludeSemantics(
        child: Wrap(
          spacing: 4,
          runSpacing: 2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < 5; index++) ...[
                  if (index > 0) const SizedBox(width: 2),
                  _Star(
                    fill: (value - index).clamp(0, 1).toDouble(),
                    filled: tokens.rating,
                    empty: scheme.outline,
                  ),
                ],
              ],
            ),
            Text(
              value.toStringAsFixed(1),
              style: DooryTypography.captionStrong(context),
            ),
            if (showCount)
              Text('($count)', style: DooryTypography.caption(context)),
          ],
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.fill, required this.filled, required this.empty});

  final double fill;
  final Color filled;
  final Color empty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 12,
      child: Stack(
        children: [
          Icon(Icons.star, size: 12, color: empty),
          if (fill > 0)
            ClipRect(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: fill,
                child: Icon(Icons.star, size: 12, color: filled),
              ),
            ),
        ],
      ),
    );
  }
}
