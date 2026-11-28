import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import 'browsing_history.dart';
import 'history_row_card.dart';

TextStyle _t(
  double size,
  FontWeight weight, [
  Color color = DooryColors.textPrimary,
]) => TextStyle(
  fontFamily: 'Cairo',
  fontSize: size,
  fontWeight: weight,
  color: color,
);

/// The live price of a browsed product, for the price-drop filter. Null for
/// estimates and when the product cannot be read.
final historyCurrentPriceProvider = FutureProvider.autoDispose
    .family<int?, int>((ref, id) async {
      final result = await ref.watch(productProvider(id).future);
      return switch (result) {
        RepoOk<ProductDetailModel>(:final data) =>
          data.priceIsEstimate ? null : data.priceSyp,
        _ => null,
      };
    });

bool _dropped(HistoryEntry entry, int? current) {
  final viewed = entry.viewedPriceSyp;
  return viewed != null && current != null && current < viewed;
}

/// «سجّل التصفح»: the products the shopper opened, newest first, as rows.
///
/// The list is local (see [BrowsingHistory]); «حذف الكل» and per-row delete
/// empty this device only. The switch stops recording; it keeps what is saved.
/// BACKEND: MISSING server-side history list, delete, and on/off («غير مدعوم»).
class BrowsingHistoryScreen extends ConsumerStatefulWidget {
  const BrowsingHistoryScreen({super.key});

  @override
  ConsumerState<BrowsingHistoryScreen> createState() =>
      _BrowsingHistoryScreenState();
}

class _BrowsingHistoryScreenState extends ConsumerState<BrowsingHistoryScreen> {
  bool _dropsOnly = false;
  int? _categoryId;

  Future<void> _toggleRecording(bool next) async {
    final notifier = ref.read(browsingHistoryEnabledProvider.notifier);
    if (next) return notifier.set(true);
    final ok = await confirmAction(
      context,
      title: SearchStrings.historySwitchOffTitle,
      body: SearchStrings.historySwitchOffBody,
      confirmLabel: SearchStrings.historySwitchOff,
    );
    if (ok) await notifier.set(false);
  }

  void _showInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(SearchStrings.historyInfoTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(SearchStrings.historyInfoBody),
            const SizedBox(height: 8),
            // BACKEND: MISSING server-side history delete/on-off.
            Text(
              SearchStrings.historyInfoLocal,
              key: const ValueKey('history-info-local-note'),
              style: _t(11, FontWeight.w600, DooryColors.backendMissing),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(DooryStrings.close),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(SearchStrings.historyClearTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(SearchStrings.historyClearBody),
            const SizedBox(height: 8),
            // BACKEND: MISSING delete/clear of server-side views.
            Text(
              SearchStrings.historyClearLocalOnly,
              key: const ValueKey('history-local-only-note'),
              style: _t(11, FontWeight.w600, DooryColors.backendMissing),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(DooryStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(SearchStrings.historyDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(browsingHistoryProvider.notifier).clear();
      if (mounted) {
        setState(() {
          _dropsOnly = false;
          _categoryId = null;
        });
      }
    }
  }

  Future<void> _pickCategory(List<HistoryEntry> items) async {
    final counts = <int, int>{};
    final names = <int, String>{};
    for (final entry in items) {
      final id = entry.categoryId;
      final name = entry.categoryName;
      if (id == null || name == null || name.isEmpty) continue;
      counts[id] = (counts[id] ?? 0) + 1;
      names[id] = name;
    }
    final picked = await showModalBottomSheet<({int? id})>(
      context: context,
      showDragHandle: true,
      backgroundColor: DooryColors.surface,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CategoryRow(
                label: SearchStrings.categoryAll,
                count: items.length,
                selected: _categoryId == null,
                onTap: () => Navigator.of(sheetContext).pop((id: null)),
              ),
              for (final id in counts.keys)
                _CategoryRow(
                  label: names[id]!,
                  count: counts[id]!,
                  selected: _categoryId == id,
                  onTap: () => Navigator.of(sheetContext).pop((id: id)),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _categoryId = picked.id);
  }

  Future<void> _delete(HistoryEntry entry, List<HistoryEntry> items) async {
    final index = items.indexWhere((item) => item.id == entry.id);
    final notifier = ref.read(browsingHistoryProvider.notifier);
    await notifier.remove(entry.id);
    if (!mounted) return;
    showToast(
      context,
      SearchStrings.rowDeleted,
      actionLabel: ShopStrings.undo,
      onAction: () => notifier.restore(entry, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(browsingHistoryProvider);
    final enabled = ref.watch(browsingHistoryEnabledProvider);

    String? categoryName;
    if (_categoryId != null) {
      for (final entry in items) {
        if (entry.categoryId == _categoryId) categoryName = entry.categoryName;
      }
    }
    // A filter whose products are all gone resets itself.
    final categoryId = categoryName == null ? null : _categoryId;

    var visible = [
      for (final entry in items)
        if (categoryId == null || entry.categoryId == categoryId) entry,
    ];
    final currents = <int, AsyncValue<int?>>{};
    if (_dropsOnly) {
      for (final entry in visible) {
        if (entry.viewedPriceSyp != null) {
          currents[entry.id] = ref.watch(historyCurrentPriceProvider(entry.id));
        }
      }
      visible = [
        for (final entry in visible)
          if (currents[entry.id] case final AsyncValue<int?> current?)
            if (current.isLoading ||
                (current.hasValue && _dropped(entry, current.value)))
              entry,
      ];
    }

    return Scaffold(
      backgroundColor: DooryColors.surfaceSubtle,
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: DooryColors.surface,
        surfaceTintColor: DooryColors.surface,
        title: Text(
          SearchStrings.browsingHistory,
          style: _t(16, FontWeight.w700),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: _confirmClear,
              child: Text(
                SearchStrings.historyDeleteAll,
                style: _t(16, FontWeight.w700, DooryColors.primary),
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          ColoredBox(
            color: DooryColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SwitchCard(
                  enabled: enabled,
                  onChanged: _toggleRecording,
                  onInfo: _showInfo,
                ),
                if (!enabled)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 0),
                    child: Text(
                      SearchStrings.historyPaused,
                      key: const ValueKey('history-paused'),
                      style: _t(12, FontWeight.w400, DooryColors.textMuted),
                    ),
                  ),
                if (items.isNotEmpty)
                  _FilterChips(
                    dropsOnly: _dropsOnly,
                    categoryName: categoryName,
                    onDrops: () => setState(() => _dropsOnly = !_dropsOnly),
                    onCategory: () => _pickCategory(items),
                  )
                else
                  const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const _EmptyHistory()
                : visible.isEmpty
                ? _FilteredEmpty(
                    onClear: () => setState(() {
                      _dropsOnly = false;
                      _categoryId = null;
                    }),
                  )
                : ListView.separated(
                    padding: const EdgeInsetsDirectional.all(8),
                    itemCount: visible.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final entry = visible[index];
                      final current = currents[entry.id];
                      if (current != null && current.isLoading) {
                        return const SkeletonBox(height: 144);
                      }
                      return HistoryRowCard(
                        key: ValueKey('history-row-${entry.id}'),
                        entry: entry,
                        currentPriceSyp: _dropsOnly ? current?.value : null,
                        onDelete: () => _delete(entry, items),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  const _SwitchCard({
    required this.enabled,
    required this.onChanged,
    required this.onInfo,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 0),
      child: Container(
        key: const ValueKey('history-switch-card'),
        height: 48,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: DooryColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: DooryColors.border),
        ),
        child: Row(
          children: [
            Text(
              SearchStrings.historySwitchLabel,
              style: _t(16, FontWeight.w700),
            ),
            IconButton(
              key: const ValueKey('history-info'),
              tooltip: SearchStrings.infoTooltip,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
              iconSize: 16,
              onPressed: onInfo,
              icon: const Icon(
                Icons.info_outline,
                color: DooryColors.textMuted,
              ),
            ),
            const Spacer(),
            Switch(
              key: const ValueKey('history-switch'),
              value: enabled,
              onChanged: onChanged,
              thumbColor: const WidgetStatePropertyAll(DooryColors.primary),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? DooryColors.primary.withValues(alpha: 0.4)
                    : DooryColors.border,
              ),
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.dropsOnly,
    required this.categoryName,
    required this.onDrops,
    required this.onCategory,
  });

  final bool dropsOnly;
  final String? categoryName;
  final VoidCallback onDrops;
  final VoidCallback onCategory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
      child: Row(
        children: [
          _Chip(
            key: const ValueKey('history-chip-drop'),
            selected: dropsOnly,
            onTap: onDrops,
            leading: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: DooryColors.danger,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.trending_down,
                size: 14,
                color: Colors.white,
              ),
            ),
            label: SearchStrings.chipPriceDrop,
          ),
          const SizedBox(width: 8),
          _Chip(
            key: const ValueKey('history-chip-category'),
            selected: categoryName != null,
            onTap: onCategory,
            label: categoryName ?? SearchStrings.chipCategory,
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: DooryColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.selected,
    required this.onTap,
    required this.label,
    this.leading,
    this.trailing,
    super.key,
  });

  final bool selected;
  final VoidCallback onTap;
  final String label;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = selected ? DooryColors.primary : DooryColors.textPrimary;
    return Material(
      color: selected ? DooryColors.primarySubtle : DooryColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? DooryColors.primary : DooryColors.border,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 34),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 6)],
                Text(label, style: _t(14, FontWeight.w600, color)),
                if (trailing != null) ...[const SizedBox(width: 2), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 22,
                color: selected
                    ? DooryColors.primary
                    : DooryColors.borderControl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _t(16, selected ? FontWeight.w700 : FontWeight.w400),
                ),
              ),
              Text(
                '($count)',
                style: _t(14, FontWeight.w400, DooryColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilteredEmpty extends StatelessWidget {
  const _FilteredEmpty({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(SearchStrings.filteredEmpty, style: _t(16, FontWeight.w600)),
          TextButton(
            key: const ValueKey('history-clear-filter'),
            onPressed: onClear,
            child: Text(
              SearchStrings.clearFilter,
              style: _t(14, FontWeight.w700, DooryColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: tokens.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 48,
                color: DooryColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              SearchStrings.historyEmpty,
              textAlign: TextAlign.center,
              style: _t(16, FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              SearchStrings.historyEmptyHint,
              textAlign: TextAlign.center,
              style: _t(14, FontWeight.w400, DooryColors.textSecondary),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text(SearchStrings.startShopping),
            ),
          ],
        ),
      ),
    );
  }
}
