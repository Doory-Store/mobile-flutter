import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/catalog_strings.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import 'listing_state.dart';

enum FilterGroup {
  price,
  category,
  brand,
  gender,
  promo,
  campaign,
  size,
  color,
  discounted,
  productType,
}

class ListingFilterScreen extends ConsumerStatefulWidget {
  const ListingFilterScreen({
    required this.initial,
    required this.sort,
    required this.children,
    this.rootCategoryId,
    this.rootCategoryName,
    super.key,
  });

  final ListingFilters initial;
  final ProductSort sort;
  final List<CategoryNode> children;
  final int? rootCategoryId;
  final String? rootCategoryName;

  static Future<ListingFilters?> open(
    BuildContext context, {
    required ListingFilters initial,
    required ProductSort sort,
    required List<CategoryNode> children,
    int? rootCategoryId,
    String? rootCategoryName,
  }) {
    return Navigator.of(context, rootNavigator: true).push<ListingFilters>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ListingFilterScreen(
          initial: initial,
          sort: sort,
          children: children,
          rootCategoryId: rootCategoryId,
          rootCategoryName: rootCategoryName,
        ),
      ),
    );
  }

  @override
  ConsumerState<ListingFilterScreen> createState() =>
      _ListingFilterScreenState();
}

class _ListingFilterScreenState extends ConsumerState<ListingFilterScreen> {
  late ListingFilters _draft = widget.initial;
  FilterGroup? _group;
  bool _more = false;
  int? _liveTotal;
  bool _counting = false;
  Timer? _debounce;
  CancelToken? _countCancel;

  @override
  void initState() {
    super.initState();
    _scheduleCount();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _countCancel?.cancel();
    super.dispose();
  }

  void _setDraft(ListingFilters next) {
    setState(() => _draft = next);
    _scheduleCount();
  }

  void _scheduleCount() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _refreshCount);
  }

  Future<void> _refreshCount() async {
    final min = _draft.minPrice;
    final max = _draft.maxPrice;
    if (min != null && max != null && min > max) {
      setState(() {
        _liveTotal = 0;
        _counting = false;
      });
      return;
    }
    _countCancel?.cancel();
    final cancel = CancelToken();
    _countCancel = cancel;
    setState(() => _counting = true);
    final result = await ref
        .read(catalogRepositoryProvider)
        .products(
          ProductsQuery(
            categoryId: _draft.categoryId ?? widget.rootCategoryId,
            sort: widget.sort,
            minPriceSyp: _draft.minPrice,
            maxPriceSyp: _draft.maxPrice,
            page: 1,
            perPage: 1,
          ),
        );
    if (!mounted || cancel.isCancelled) return;
    final total = switch (result) {
      RepoOk<ProductPage>(:final data) => data.meta.total,
      _ => null,
    };
    setState(() {
      _counting = false;
      _liveTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSub = _group != null;
    final footerLabel = onSub
        ? CatalogStrings.apply
        : (_counting || _liveTotal == null
              ? CatalogStrings.showResults
              : CatalogStrings.showResultsCount(_liveTotal!));
    return Scaffold(
      backgroundColor: DooryColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _FilterToolbar(
              title: switch (_group) {
                FilterGroup.price => CatalogStrings.price,
                FilterGroup.category => CatalogStrings.category,
                _ => CatalogStrings.filter,
              },
              showClear: !onSub,
              onLeading: () {
                if (onSub) {
                  setState(() => _group = null);
                } else {
                  Navigator.of(context).pop();
                }
              },
              onClear: onSub ? null : () => _setDraft(ListingFilters.empty),
            ),
            Expanded(child: onSub ? _buildSubPage() : _buildRoot()),
            _FilterFooter(
              label: footerLabel,
              enabled:
                  onSub ||
                  (!_counting && (_liveTotal == null || _liveTotal! > 0)),
              onPressed: () {
                if (onSub) {
                  setState(() => _group = null);
                  return;
                }
                Navigator.of(context).pop(_draft);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoot() {
    final groups = <_GroupRowData>[
      _GroupRowData(
        group: FilterGroup.price,
        title: CatalogStrings.price,
        supported: true,
        selected: _draft.hasPrice,
        summary: _priceSummary(),
      ),
      if (widget.children.isNotEmpty)
        _GroupRowData(
          group: FilterGroup.category,
          title: CatalogStrings.category,
          supported: true,
          selected:
              _draft.categoryId != null &&
              _draft.categoryId != widget.rootCategoryId,
          summary: _categorySummary(),
        ),
      const _GroupRowData(
        group: FilterGroup.brand,
        title: CatalogStrings.brand,
        supported: false,
      ),
    ];
    const extra = <_GroupRowData>[
      _GroupRowData(
        group: FilterGroup.gender,
        title: CatalogStrings.gender,
        supported: false,
      ),
      _GroupRowData(
        group: FilterGroup.promo,
        title: CatalogStrings.promo,
        supported: false,
      ),
      _GroupRowData(
        group: FilterGroup.campaign,
        title: CatalogStrings.campaign,
        supported: false,
      ),
      _GroupRowData(
        group: FilterGroup.size,
        title: CatalogStrings.size,
        supported: false,
      ),
      _GroupRowData(
        group: FilterGroup.color,
        title: CatalogStrings.color,
        supported: false,
      ),
      _GroupRowData(
        group: FilterGroup.discounted,
        title: CatalogStrings.discounted,
        supported: false,
      ),
      _GroupRowData(
        group: FilterGroup.productType,
        title: CatalogStrings.productType,
        supported: false,
      ),
    ];
    return ListView(
      children: [
        for (final row in groups)
          _GroupTile(row: row, onTap: () => setState(() => _group = row.group)),
        InkWell(
          onTap: () => setState(() => _more = !_more),
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                CatalogStrings.moreFilters,
                style: DooryTypography.labelStrong(context)
                    .copyWith(color: DooryColors.primary, fontSize: 14),
              ),
            ),
          ),
        ),
        if (_more)
          for (final row in extra) _GroupTile(row: row, onTap: () {}),
        const ColoredBox(
          color: DooryColors.surfaceSubtle,
          child: SizedBox(height: 120),
        ),
      ],
    );
  }

  Widget _buildSubPage() {
    if (_group == FilterGroup.price) {
      return PriceFilterEditor(
        min: _draft.minPrice,
        max: _draft.maxPrice,
        onChanged: (min, max) => _setDraft(
          _draft.copyWith(
            minPrice: min,
            maxPrice: max,
            clearPrice: min == null && max == null,
          ),
        ),
      );
    }
    if (_group == FilterGroup.category) {
      return CategoryFilterEditor(
        rootId: widget.rootCategoryId,
        rootName: widget.rootCategoryName,
        children: widget.children,
        selectedId: _draft.categoryId ?? widget.rootCategoryId,
        onChanged: (id) => _setDraft(_draft.copyWith(categoryId: id)),
      );
    }
    return const SizedBox.shrink();
  }

  String? _priceSummary() {
    if (!_draft.hasPrice) return null;
    final min = _draft.minPrice;
    final max = _draft.maxPrice;
    if (min != null && max != null) {
      return '${formatSypDigits(min)} – ${formatSypDigits(max)}';
    }
    if (min != null) return '${formatSypDigits(min)}+';
    return '– ${formatSypDigits(max!)}';
  }

  String? _categorySummary() {
    final id = _draft.categoryId;
    if (id == null || id == widget.rootCategoryId) return null;
    for (final child in widget.children) {
      if (child.id == id) return child.name;
    }
    return widget.rootCategoryName;
  }
}

class _GroupRowData {
  const _GroupRowData({
    required this.group,
    required this.title,
    required this.supported,
    this.selected = false,
    this.summary,
  });

  final FilterGroup group;
  final String title;
  final bool supported;
  final bool selected;
  final String? summary;
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.row, required this.onTap});

  final _GroupRowData row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: row.supported ? onTap : null,
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: DooryTypography.labelStrong(context)
                                .copyWith(
                                  fontSize: 14,
                                  color: row.supported
                                      ? DooryColors.textPrimary
                                      : DooryColors.textMuted,
                                ),
                            children: [
                              TextSpan(text: row.title),
                              if (row.selected)
                                const TextSpan(
                                  text: ' (1)',
                                  style: TextStyle(color: DooryColors.primary),
                                ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (row.summary != null && row.summary!.isNotEmpty)
                          Text(
                            row.summary!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DooryTypography.cardMeta(context).copyWith(
                              fontSize: 12,
                              color: DooryColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!row.supported)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: Text(
                        CatalogStrings.unsupported,
                        style: DooryTypography.cardMeta(context)
                            .copyWith(color: DooryColors.textMuted),
                      ),
                    ),
                  const Icon(
                    Icons.chevron_left,
                    size: 16,
                    color: DooryColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: DooryColors.border),
      ],
    );
  }
}

class _FilterToolbar extends StatelessWidget {
  const _FilterToolbar({
    required this.title,
    required this.onLeading,
    this.showClear = true,
    this.onClear,
  });

  final String title;
  final VoidCallback onLeading;
  final bool showClear;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DooryColors.surface,
      elevation: 2,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            IconButton(
              tooltip: CatalogStrings.close,
              onPressed: onLeading,
              icon: Icon(
                showClear ? Icons.close : Icons.arrow_back,
                size: 24,
                color: DooryColors.textPrimary,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: DooryTypography.section(context).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: DooryColors.textPrimary,
                ),
              ),
            ),
            if (showClear)
              TextButton(
                onPressed: onClear,
                child: Text(
                  CatalogStrings.clear,
                  style: DooryTypography.labelStrong(context)
                      .copyWith(color: DooryColors.primary, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterFooter extends StatelessWidget {
  const _FilterFooter({
    required this.label,
    required this.onPressed,
    required this.enabled,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DooryColors.surface,
      elevation: 8,
      child: SizedBox(
        height: 82,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: FilledButton(
              onPressed: enabled ? onPressed : null,
              style: FilledButton.styleFrom(
                backgroundColor: DooryColors.primary,
                disabledBackgroundColor: DooryColors.border,
                foregroundColor: DooryColors.textOnStrong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: const TextStyle(
                  fontFamily: DooryTypography.family,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

/// Price fields plus local SYP presets (proposal; not from the server).
class PriceFilterEditor extends StatefulWidget {
  const PriceFilterEditor({
    required this.onChanged,
    this.min,
    this.max,
    super.key,
  });

  final int? min;
  final int? max;
  final void Function(int? min, int? max) onChanged;

  static const presets = <(int?, int?)>[
    (0, 25000),
    (25000, 50000),
    (50000, 100000),
    (100000, 250000),
    (250000, null),
  ];

  @override
  State<PriceFilterEditor> createState() => _PriceFilterEditorState();
}

class _PriceFilterEditorState extends State<PriceFilterEditor> {
  late final _min = TextEditingController(text: widget.min?.toString() ?? '');
  late final _max = TextEditingController(text: widget.max?.toString() ?? '');

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  int? _parse(String raw) {
    final t = raw.replaceAll(',', '').trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  void _emit() => widget.onChanged(_parse(_min.text), _parse(_max.text));

  void _applyPreset(int? min, int? max) {
    _min.text = min?.toString() ?? '';
    _max.text = max?.toString() ?? '';
    _emit();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final min = _parse(_min.text);
    final max = _parse(_max.text);
    final invalid = min != null && max != null && min > max;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: _PriceField(
                  controller: _min,
                  label: CatalogStrings.minPrice,
                  onChanged: (_) {
                    setState(_emit);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Text('–'),
              ),
              Expanded(
                child: _PriceField(
                  controller: _max,
                  label: CatalogStrings.maxPrice,
                  onChanged: (_) {
                    setState(_emit);
                  },
                ),
              ),
            ],
          ),
        ),
        if (invalid)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(
              DooryStrings.invalidRange,
              style: DooryTypography.label(context)
                  .copyWith(color: DooryColors.danger),
            ),
          ),
        const ColoredBox(
          color: DooryColors.surfaceSubtle,
          child: SizedBox(height: 8),
        ),
        for (final preset in PriceFilterEditor.presets) ...[
          InkWell(
            onTap: () => _applyPreset(preset.$1, preset.$2),
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _presetLabel(preset.$1, preset.$2),
                    style: DooryTypography.labelStrong(context)
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: DooryColors.border),
        ],
      ],
    );
  }

  String _presetLabel(int? min, int? max) {
    if (min != null && max != null) {
      return '${formatSyp(min)} – ${formatSyp(max)}';
    }
    if (min != null) return '${formatSyp(min)}+';
    return formatSyp(max ?? 0);
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        hintStyle: const TextStyle(color: DooryColors.textMuted),
        filled: true,
        fillColor: DooryColors.surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: DooryColors.borderControl),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: DooryColors.borderControl),
        ),
      ),
    );
  }
}

class CategoryFilterEditor extends StatelessWidget {
  const CategoryFilterEditor({
    required this.children,
    required this.onChanged,
    this.rootId,
    this.rootName,
    this.selectedId,
    super.key,
  });

  final int? rootId;
  final String? rootName;
  final List<CategoryNode> children;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final rows = <(int?, String)>[
      if (rootId != null) (rootId, rootName ?? CatalogStrings.category),
      for (final child in children) (child.id, child.name),
    ];
    return ListView(
      children: [
        for (final row in rows)
          InkWell(
            onTap: () => onChanged(row.$1),
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      selectedId == row.$1
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selectedId == row.$1
                          ? DooryColors.primary
                          : DooryColors.border,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        row.$2,
                        style: DooryTypography.body(context).copyWith(
                          fontSize: 14,
                          color: DooryColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<ListingFilters?> showPriceFilterSheet(
  BuildContext context, {
  required ListingFilters initial,
}) {
  var draft = initial;
  return showModalBottomSheet<ListingFilters>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: DooryColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return SafeArea(
        child: SizedBox(
          height: 420,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        CatalogStrings.price,
                        style: DooryTypography.section(
                          context,
                        ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, draft),
                      child: Text(
                        CatalogStrings.apply,
                        style: const TextStyle(color: DooryColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PriceFilterEditor(
                  min: draft.minPrice,
                  max: draft.maxPrice,
                  onChanged: (min, max) => draft = draft.copyWith(
                    minPrice: min,
                    maxPrice: max,
                    clearPrice: min == null && max == null,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<ListingFilters?> showCategoryFilterSheet(
  BuildContext context, {
  required ListingFilters initial,
  required List<CategoryNode> children,
  int? rootCategoryId,
  String? rootCategoryName,
}) {
  var draft = initial;
  return showModalBottomSheet<ListingFilters>(
    context: context,
    useRootNavigator: true,
    backgroundColor: DooryColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return SafeArea(
        child: SizedBox(
          height: 360,
          child: StatefulBuilder(
            builder: (context, setSheet) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            CatalogStrings.category,
                            style: DooryTypography.section(context).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, draft),
                          child: const Text(
                            CatalogStrings.apply,
                            style: TextStyle(color: DooryColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CategoryFilterEditor(
                      rootId: rootCategoryId,
                      rootName: rootCategoryName,
                      children: children,
                      selectedId: draft.categoryId ?? rootCategoryId,
                      onChanged: (id) => setSheet(
                        () => draft = draft.copyWith(categoryId: id),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
