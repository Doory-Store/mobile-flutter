import 'package:material_ui/material_ui.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';

class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({required this.items, super.key});

  final List<ProductCardModel> items;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final columns = constraints.crossAxisExtent < 360 || scale > 1.35
            ? 1
            : 2;
        final gaps = 12.0 * (columns - 1);
        final tileWidth = (constraints.crossAxisExtent - 32 - gaps) / columns;
        final extent = tileWidth * 1.5 + 156 * scale.clamp(1.0, 1.8);
        return SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: extent,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: items[index]),
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

Future<ProductSort?> showSortSheet(BuildContext context, ProductSort current) {
  return showModalBottomSheet<ProductSort>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final sort in ProductSort.values)
              ListTile(
                title: Text(_sortLabel(sort)),
                trailing: sort == current ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(sort),
              ),
          ],
        ),
      );
    },
  );
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
