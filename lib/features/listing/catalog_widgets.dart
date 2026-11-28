import 'package:material_ui/material_ui.dart';

import '../../core/l10n/catalog_strings.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';
import 'listing_state.dart';

class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({
    required this.items,
    this.showFavorites = false,
    super.key,
  });

  final List<ProductCardModel> items;
  final bool showFavorites;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final scale = ProductCardMetrics.scaleOf(context);
        // Two columns like Trendyol (0.471 of the width each, 8 dp gaps);
        // one column only on very narrow screens.
        final columns = constraints.crossAxisExtent < 320 ? 1 : 2;
        const gap = ProductCardMetrics.gap;
        final tileWidth =
            (constraints.crossAxisExtent - gap * (columns + 1)) / columns;
        final extent = ProductCardMetrics.cardHeight(
          tileWidth,
          scale,
          showFavorites: showFavorites,
        );
        return SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(gap, 0, gap, 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: extent,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(
                product: items[index],
                showFavorites: showFavorites,
              ),
              childCount: items.length,
            ),
          ),
        );
      },
    );
  }
}

class CatalogToolbar extends StatelessWidget {
  const CatalogToolbar({
    required this.sort,
    required this.onSort,
    required this.onPrice,
    this.total,
    this.sample = false,
    super.key,
  });

  final ProductSort sort;
  final VoidCallback onSort;
  final VoidCallback onPrice;
  final int? total;
  final bool sample;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (total != null)
            Text(
              DooryStrings.productCount(total!),
              style: DooryTypography.labelStrong(context),
            ),
          if (sample) const DemoLabel(),
          OutlinedButton(onPressed: onSort, child: Text(_sortLabel(sort))),
          OutlinedButton(
            onPressed: onPrice,
            child: const Text(DooryStrings.priceFilter),
          ),
        ],
      ),
    );
  }
}

String _sortLabel(ProductSort sort) {
  return switch (sort) {
    ProductSort.newest => DooryStrings.sortNewest,
    ProductSort.priceAsc => DooryStrings.sortPriceAsc,
    ProductSort.priceDesc => DooryStrings.sortPriceDesc,
  };
}

/// Trendyol sort options. [sort] is null when the row is unsupported.
class CatalogSortRow {
  const CatalogSortRow({required this.label, this.sort});

  final String label;
  final ProductSort? sort;

  bool get supported => sort != null;
}

const catalogSortRows = <CatalogSortRow>[
  CatalogSortRow(label: CatalogStrings.sortRelevance),
  CatalogSortRow(label: CatalogStrings.sortBestSelling),
  CatalogSortRow(label: CatalogStrings.sortFavorites),
  CatalogSortRow(label: CatalogStrings.sortNewest, sort: ProductSort.newest),
  CatalogSortRow(label: CatalogStrings.sortMostRated),
  CatalogSortRow(
    label: CatalogStrings.sortPriceHigh,
    sort: ProductSort.priceDesc,
  ),
  CatalogSortRow(
    label: CatalogStrings.sortPriceLow,
    sort: ProductSort.priceAsc,
  ),
];

Future<ProductSort?> showSortSheet(BuildContext context, ProductSort current) {
  return showModalBottomSheet<ProductSort>(
    context: context,
    useRootNavigator: true,
    backgroundColor: DooryColors.surface,
    barrierColor: const Color(0x99000000),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColoredBox(
              color: DooryColors.surfaceSubtle,
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          CatalogStrings.sort,
                          style: DooryTypography.section(context).copyWith(
                            fontSize: 16,
                            height: 20 / 16,
                            fontWeight: FontWeight.w700,
                            color: DooryColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: CatalogStrings.close,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: DooryColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: DooryColors.border),
            for (final row in catalogSortRows)
              _SortOptionTile(row: row, current: current),
          ],
        ),
      );
    },
  );
}

class _SortOptionTile extends StatelessWidget {
  const _SortOptionTile({required this.row, required this.current});

  final CatalogSortRow row;
  final ProductSort current;

  @override
  Widget build(BuildContext context) {
    final selected = row.sort != null && row.sort == current;
    final color = row.supported
        ? DooryColors.textPrimary
        : DooryColors.textMuted;
    return InkWell(
      onTap: row.supported ? () => Navigator.of(context).pop(row.sort) : null,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CustomPaint(
                  painter: _RadioPainter(
                    selected: selected,
                    enabled: row.supported,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  row.label,
                  style: DooryTypography.body(context)
                      .copyWith(fontSize: 14, color: color),
                ),
              ),
              if (!row.supported)
                // BACKEND: MISSING this sort option on GET /products (only
                // newest, price_asc, price_desc).
                Text(
                  CatalogStrings.unsupported,
                  style: DooryTypography.cardMeta(context)
                      .copyWith(color: DooryColors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioPainter extends CustomPainter {
  const _RadioPainter({required this.selected, required this.enabled});

  final bool selected;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 2 : 1.5
      ..color = !enabled
          ? DooryColors.border
          : (selected ? DooryColors.primary : DooryColors.border);
    canvas.drawCircle(center, 9, ring);
    if (selected && enabled) {
      canvas.drawCircle(center, 5, Paint()..color = DooryColors.primary);
    }
  }

  @override
  bool shouldRepaint(_RadioPainter old) =>
      old.selected != selected || old.enabled != enabled;
}

class PriceFilterResult {
  const PriceFilterResult({this.min, this.max, this.cleared = false});

  final int? min;
  final int? max;
  final bool cleared;
}

Future<PriceFilterResult?> showPriceSheet(
  BuildContext context, {
  int? min,
  int? max,
}) {
  return showModalBottomSheet<PriceFilterResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _PriceSheet(min: min, max: max),
  );
}

class _PriceSheet extends StatefulWidget {
  const _PriceSheet({this.min, this.max});

  final int? min;
  final int? max;

  @override
  State<_PriceSheet> createState() => _PriceSheetState();
}

class _PriceSheetState extends State<_PriceSheet> {
  late final TextEditingController _min = TextEditingController(
    text: widget.min?.toString() ?? '',
  );
  late final TextEditingController _max = TextEditingController(
    text: widget.max?.toString() ?? '',
  );
  String? _error;

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  int? _parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  void _apply() {
    final min = _parse(_min.text);
    final max = _parse(_max.text);
    if (_min.text.trim().isNotEmpty && min == null) return;
    if (_max.text.trim().isNotEmpty && max == null) return;
    if (min != null && max != null && min > max) {
      setState(() => _error = DooryStrings.invalidRange);
      return;
    }
    Navigator.of(context).pop(PriceFilterResult(min: min, max: max));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            DooryStrings.priceFilter,
            style: DooryTypography.section(context),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _min,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: DooryStrings.minPrice),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _max,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: DooryStrings.maxPrice),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: DooryTypography.label(context)
                  .copyWith(color: DooryTokens.of(context).danger),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _apply,
            child: const Text(DooryStrings.apply),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context)
                    .pop(const PriceFilterResult(cleared: true)),
            child: const Text(DooryStrings.clear),
          ),
        ],
      ),
    );
  }
}

class DooryFilterChip extends StatelessWidget {
  const DooryFilterChip({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.active = false,
    this.badge,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final IconData? trailing;
  final bool active;
  final int? badge;

  static const height = 30.0;
  static const borderWidth = 1.0;
  static const horizontalPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    final border = active ? DooryColors.primary : DooryColors.border;
    final fill = active ? DooryColors.primarySubtle : DooryColors.surface;
    // Height is on the outer box so a horizontal ListView cannot stretch
    // the Material (and its StadiumBorder) to the bar's full height.
    final chip = SizedBox(
      height: height,
      child: Material(
        color: fill,
        shape: StadiumBorder(
          side: BorderSide(color: border, width: borderWidth),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: DooryColors.primary),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: DooryTypography.labelStrong(context)
                      .copyWith(fontSize: 12, color: DooryColors.textPrimary),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 2),
                  Icon(trailing, size: 12, color: DooryColors.textPrimary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    if (badge == null || badge! <= 0) return chip;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        chip,
        PositionedDirectional(
          top: -4,
          start: -4,
          child: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: DooryColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$badge',
              style: const TextStyle(
                fontFamily: DooryTypography.family,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: DooryColors.textOnStrong,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListingChipBar extends StatelessWidget {
  const ListingChipBar({
    required this.sort,
    required this.filters,
    required this.rootCategoryId,
    required this.children,
    required this.onSort,
    required this.onFilter,
    required this.onPrice,
    required this.onCategory,
    super.key,
  });

  final ProductSort sort;
  final ListingFilters filters;
  final int? rootCategoryId;
  final List<CategoryNode> children;
  final VoidCallback onSort;
  final VoidCallback onFilter;
  final VoidCallback onPrice;
  final VoidCallback onCategory;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DooryColors.surface,
      child: SizedBox(
        height: 54,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    DooryFilterChip(
                      label: CatalogStrings.sort,
                      icon: Icons.swap_vert,
                      onTap: onSort,
                    ),
                    const SizedBox(width: 8),
                    DooryFilterChip(
                      label: CatalogStrings.filter,
                      icon: Icons.tune,
                      active:
                          filters.activeCount(rootCategoryId: rootCategoryId) >
                          0,
                      badge: filters.activeCount(
                        rootCategoryId: rootCategoryId,
                      ),
                      onTap: onFilter,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.none,
                        child: Row(
                          children: [
                            DooryFilterChip(
                              label: CatalogStrings.price,
                              trailing: Icons.expand_more,
                              active: filters.hasPrice,
                              onTap: onPrice,
                            ),
                            if (children.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              DooryFilterChip(
                                label: CatalogStrings.category,
                                trailing: Icons.expand_more,
                                active:
                                    filters.categoryId != null &&
                                    filters.categoryId != rootCategoryId,
                                onTap: onCategory,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: DooryColors.border),
          ],
        ),
      ),
    );
  }
}
