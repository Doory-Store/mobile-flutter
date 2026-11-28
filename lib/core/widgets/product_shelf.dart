import 'package:material_ui/material_ui.dart';

import '../../data/models/catalog_models.dart';
import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'chrome.dart';
import 'product_card.dart';

class ProductShelf extends StatelessWidget {
  const ProductShelf({
    required this.title,
    required this.products,
    this.onViewAll,
    this.sample = false,
    super.key,
  });

  final String title;
  final List<ProductCardModel> products;
  final VoidCallback? onViewAll;
  final bool sample;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final scale = ProductCardMetrics.scaleOf(context);
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: DooryTypography.shelf(context)),
                  ),
                  if (sample) const DemoLabel(),
                  const SizedBox(width: 8),
                  _ViewAll(onPressed: onViewAll),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                // ≈ 0.335 of the width, so 2.7–2.8 cards show with the next
                // one cut off (Trendyol home shelf).
                final cardWidth = ProductCardMetrics.shelfCardWidth(
                  constraints.maxWidth,
                  scale,
                );
                return SizedBox(
                  height: ProductCardMetrics.cardHeight(cardWidth, scale),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: ProductCardMetrics.gap,
                    ),
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: ProductCardMetrics.gap),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        width: cardWidth,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewAll extends StatelessWidget {
  const _ViewAll({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final enabled = onPressed != null;
    return Semantics(
      button: enabled,
      enabled: enabled,
      label: DooryStrings.viewAll,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 36),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          backgroundColor: enabled ? tokens.surfaceSubtle : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundColor: enabled
              ? Theme.of(context).colorScheme.primary
              : tokens.textMuted,
        ),
        child: Text(
          DooryStrings.viewAll,
          style: DooryTypography.labelStrong(context),
        ),
      ),
    );
  }
}
