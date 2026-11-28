import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/category_avatar.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/product_query.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../listing/catalog_widgets.dart';
import '../listing/listing_state.dart';
import 'browsing_history.dart';
import 'recent_searches.dart';
import 'recommended_shelf.dart';
import 'search_controller.dart';

/// Search, laid out after Trendyol's captures 35–38: a back arrow, a grey
/// field with a camera icon, then one of three bodies:
/// * landing — recent searches (header + «مسح»), «عمليات بحث مقترحة»,
///   «تصفح الفئات», then the «سجّل التصفح» shelf and «قطع لك خصيصًا»;
/// * suggestions — while the shopper types, before submitting;
/// * results — filter chips, a product count, and the two-column grid.
///
/// Results stay on the live `GET /search` (called only with a non-empty
/// `q`). Suggestions are built on the device from history, popular terms,
/// and the live category tree.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({required this.initialQuery, super.key});

  final String initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _field = TextEditingController(
    text: widget.initialQuery,
  );
  final _focus = FocusNode();
  final _scroll = ScrollController();
  Timer? _debounce;

  /// The committed query the results follow. It changes on submit or when
  /// a chip or suggestion is picked, never while the shopper types, so the
  /// field keeps its focus, cursor, and IME composing region.
  late String _query = widget.initialQuery.trim();

  /// What the shopper is typing, debounced, for the suggestion list.
  late String _typed = widget.initialQuery.trim();

  /// True while a keystroke waits for the debounce.
  bool _pending = false;

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.initialQuery.trim();
    if (widget.initialQuery == oldWidget.initialQuery || incoming == _query) {
      return;
    }
    _query = incoming;
    _typed = incoming;
    if (_field.text.trim() != incoming) {
      _field.value = TextEditingValue(
        text: incoming,
        selection: TextSelection.collapsed(offset: incoming.length),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _field.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _commit(String value) {
    _debounce?.cancel();
    final next = value.trim();
    if (!mounted || next.isEmpty) return;
    _focus.unfocus();
    setState(() {
      _query = next;
      _typed = next;
    });
    ref.read(recentSearchesProvider.notifier).add(next);
    // The route keeps `q` for deep links and back; skipped when the screen
    // is hosted without go_router (widget tests).
    if (GoRouter.maybeOf(context) != null) replaceSearch(context, next);
  }

  void _pick(String value) {
    _field.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _commit(value);
  }

  /// Puts a suggestion in the field without searching (the row's arrow).
  void _fill(String value) {
    _field.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _onChanged(value);
    _focus.requestFocus();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _typed = '';
        _pending = false;
      });
      return;
    }
    if (!_pending) setState(() => _pending = true);
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _typed = value.trim();
          _pending = false;
        });
      }
    });
  }

  void _clear() {
    _debounce?.cancel();
    _field.clear();
    setState(() {
      _typed = '';
      _pending = false;
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final typing = _typed.isNotEmpty && _typed != query;
    // The first suggestions are still being prepared (the 250 ms debounce).
    final waiting = _pending && _typed.isEmpty;
    final showsResults =
        !typing && !waiting && query.isNotEmpty && _typed.isNotEmpty;
    final Widget body;
    if (typing) {
      body = _Suggestions(typed: _typed, onPick: _pick, onFill: _fill);
    } else if (waiting) {
      body = const _SuggestionsLoading();
    } else if (query.isEmpty || _typed.isEmpty) {
      body = _Landing(onPick: _pick);
    } else {
      body = _Results(query: query, scroll: _scroll);
    }
    return Scaffold(
      // Grey page behind white cards while idle or typing; white for results.
      backgroundColor: showsResults
          ? DooryColors.surface
          : DooryColors.surfaceSubtle,
      appBar: AppBar(
        toolbarHeight: 56,
        titleSpacing: 0,
        backgroundColor: DooryColors.surface,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else if (GoRouter.maybeOf(context) != null) {
              goTabRoot(context);
            }
          },
        ),
        title: _SearchBox(
          controller: _field,
          focusNode: _focus,
          autofocus: query.isEmpty,
          // Flat white while idle or typing; the grey pill only on results.
          pill: showsResults,
          resultCount: showsResults
              ? ref.watch(
                  searchProvider(query)
                      .select((s) => s.loading ? null : s.total),
                )
              : null,
          onChanged: _onChanged,
          onSubmitted: _commit,
          onClear: _clear,
        ),
        actions: const [SizedBox(width: 12)],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: DooryColors.border),
        ),
      ),
      body: body,
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.pill,
    required this.resultCount,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;

  /// Grey rounded pill (results) instead of the flat white field.
  final bool pill;
  final int? resultCount;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      height: pill ? 40 : 48,
      margin: pill
          ? const EdgeInsetsDirectional.symmetric(horizontal: 8)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: pill ? DooryColors.surfaceSubtle : Colors.transparent,
        borderRadius: BorderRadius.circular(pill ? 20 : 8),
      ),
      child: Row(
        children: [
          // The grey results pill carries the magnifier; the flat idle bar does not.
          if (pill) ...[
            const SizedBox(width: 10),
            const Icon(Icons.search, size: 20, color: DooryColors.primary),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              cursorColor: DooryColors.primary,
              style: DooryTypography.body(context),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: SearchStrings.hint,
                hintStyle: _t(14, FontWeight.w400, DooryColors.textSecondary),
                contentPadding: EdgeInsetsDirectional.fromSTEB(
                  pill ? 8 : 4,
                  10,
                  4,
                  10,
                ),
                suffixText: resultCount == null
                    ? null
                    : '| ${SearchStrings.resultsCount(resultCount!)}',
                suffixStyle: DooryTypography.cardMeta(context),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => controller.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: SearchStrings.clearField,
                    visualDensity: VisualDensity.compact,
                    onPressed: onClear,
                    icon: Icon(Icons.close, size: 20, color: muted),
                  ),
          ),
          // BACKEND: MISSING visual (image) search endpoint
          IconButton(
            tooltip: SearchStrings.visualSearch,
            visualDensity: VisualDensity.compact,
            onPressed: () => showNotWired(
              context,
              feature: SearchStrings.visualSearchFeature,
            ),
            icon: const Icon(
              Icons.photo_camera_outlined,
              size: 24,
              color: DooryColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Idle body: recent searches with «سجل البحث» and «مسح» (4, then
/// «عرض المزيد»), «عمليات بحث مقترحة», «تصفح الفئات», then the
/// «سجّل التصفح» thumbnail shelf and «قطع لك خصيصًا» at the end.
class _Landing extends ConsumerStatefulWidget {
  const _Landing({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  ConsumerState<_Landing> createState() => _LandingState();
}

class _LandingState extends ConsumerState<_Landing> {
  static const _collapsedCount = 4;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentSearchesProvider);
    final history = ref.watch(browsingHistoryProvider);
    final categories = ref.watch(categoriesProvider);
    final nodes = switch (categories.asData?.value) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample ?? const [],
      _ => const <CategoryNode>[],
    };
    final canExpand = recent.length > _collapsedCount;
    final shown = _expanded || !canExpand
        ? recent
        : recent.take(_collapsedCount).toList();
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      children: [
        if (recent.isNotEmpty) ...[
          _Band(
            title: SearchStrings.historyTitle,
            trailing: TextButton(
              onPressed: () => _confirmClear(),
              child: Text(
                SearchStrings.clearHistory,
                style: _t(16, FontWeight.w600, DooryColors.textPrimary),
              ),
            ),
          ),
          for (final item in shown)
            _HistoryRow(
              text: item,
              onTap: () => widget.onPick(item),
              onRemove: () =>
                  ref.read(recentSearchesProvider.notifier).remove(item),
            ),
          if (canExpand && !_expanded)
            Material(
              color: DooryColors.surface,
              child: InkWell(
                key: const ValueKey('search-show-more'),
                onTap: () => setState(() => _expanded = true),
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    SearchStrings.showMore,
                    style: _t(16, FontWeight.w700, DooryColors.primary),
                  ),
                ),
              ),
            ),
        ],
        _SuggestedSearches(onPick: widget.onPick),
        if (nodes.isNotEmpty) _BrowseCategories(nodes: nodes),
        if (history.isNotEmpty) _HistoryShelf(items: history.take(10).toList()),
        const RecommendedShelf(),
      ],
    );
  }

  Future<void> _confirmClear() async {
    final ok = await confirmAction(
      context,
      title: SearchStrings.clearHistoryConfirm,
      confirmLabel: SearchStrings.historyDelete,
    );
    if (ok) await ref.read(recentSearchesProvider.notifier).clear();
  }
}

TextStyle _t(double size, FontWeight weight, Color color) => TextStyle(
  fontFamily: 'Cairo',
  fontSize: size,
  fontWeight: weight,
  color: color,
);

/// One recent search: the word (16 sp), and a small ✕ at the start. 55 dp with
/// an inset divider (16 at the start, 24 at the end).
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.text,
    required this.onTap,
    required this.onRemove,
  });

  final String text;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DooryColors.surface,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 55,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      tooltip: SearchStrings.removeEntry,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 48,
                        height: 54,
                      ),
                      iconSize: 8,
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.close,
                        color: DooryColors.textMuted,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _t(16, FontWeight.w400, DooryColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 24,
                color: DooryColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// «سجّل التصفح» shelf: image-only thumbnails of the newest opened products
/// (70×105), and «عرض الكل ›» to the full history page. Hidden when empty.
class _HistoryShelf extends StatelessWidget {
  const _HistoryShelf({required this.items});

  final List<HistoryEntry> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('search-history-shelf'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    SearchStrings.browsingHistory,
                    style: _t(16, FontWeight.w700, DooryColors.textPrimary),
                  ),
                ),
              ),
              ViewAllLink(onTap: () => pushHistory(context)),
            ],
          ),
        ),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (context, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final card = items[index].card;
              return Semantics(
                label: card.name,
                button: true,
                child: Container(
                  key: ValueKey('history-thumb-${card.id}'),
                  width: 70,
                  height: 105,
                  decoration: BoxDecoration(
                    color: DooryColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: DooryColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => pushProduct(context, card.ref, card: card),
                    child: card.photoUrl == null
                        ? const Icon(
                            Icons.image_outlined,
                            color: DooryColors.textMuted,
                          )
                        : CachedNetworkImage(
                            imageUrl: card.photoUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: 210,
                            placeholder: (context, _) =>
                                const SkeletonBox(height: double.infinity),
                            errorWidget: (context, _, _) => const Icon(
                              Icons.image_outlined,
                              color: DooryColors.textMuted,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Grey header band above a white card (14 sp w700).
class _Band extends StatelessWidget {
  const _Band({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DooryColors.surfaceSubtle,
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: DooryTypography.body(context)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// «عمليات بحث مقترحة»: a fixed device list in one scrolling row of pills.
// BACKEND: MISSING popular / trending terms endpoint (shown with the red
// «غير مدعوم» label; GET /search/suggest has no such list)
class _SuggestedSearches extends StatelessWidget {
  const _SuggestedSearches({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: DooryColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      SearchStrings.popularTitle,
                      style: _t(16, FontWeight.w700, DooryColors.textPrimary),
                    ),
                  ),
                ),
                Text(
                  SearchStrings.unsupported,
                  key: const ValueKey('suggested-unsupported'),
                  style: _t(11, FontWeight.w600, DooryColors.backendMissing),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              itemCount: popularSearches.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) => _TermPill(
                label: popularSearches[index],
                onTap: () => onPick(popularSearches[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 30 dp stadium pill: white, 1 dp border, 13 sp.
class _TermPill extends StatelessWidget {
  const _TermPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DooryColors.surface,
      shape: const StadiumBorder(side: BorderSide(color: DooryColors.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Container(
          height: 30,
          alignment: Alignment.center,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          child: Text(
            label,
            style: DooryTypography.body(context).copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

/// «تصفّح الفئات»: root categories; a chip opens that root in the rail page.
class _BrowseCategories extends StatelessWidget {
  const _BrowseCategories({required this.nodes});

  final List<CategoryNode> nodes;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DooryColors.surface,
      margin: const EdgeInsetsDirectional.only(top: 8),
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      SearchStrings.browseCategories,
                      style: _t(16, FontWeight.w700, DooryColors.textPrimary),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/categories'),
                  child: Text(
                    DooryStrings.viewAll,
                    style: DooryTypography.cardMeta(context).copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DooryColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final node in nodes)
                  CategoryChip(
                    node: node,
                    onPressed: () => goCategoryBrowse(context, node.slug),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _SuggestionKind { keyword, history, category, popular }

class _Suggestion {
  const _Suggestion(this.text, this.kind);

  final String text;
  final _SuggestionKind kind;
}

/// Placeholder rows while the first suggestions are prepared.
class _SuggestionsLoading extends StatelessWidget {
  const _SuggestionsLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('suggestions-loading'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Band(title: SearchStrings.relatedTitle),
        for (var i = 0; i < 4; i++)
          Container(
            height: 48,
            color: DooryColors.surface,
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: const SkeletonBox(height: 14, width: 160, radius: 4),
          ),
      ],
    );
  }
}

class _Suggestions extends ConsumerWidget {
  const _Suggestions({
    required this.typed,
    required this.onPick,
    required this.onFill,
  });

  final String typed;
  final ValueChanged<String> onPick;
  final ValueChanged<String> onFill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // BACKEND: AVAILABLE GET /search/suggest?q= → products[], categories[], stores[], recent[] (not wired; built on device below)
    final recent = ref.watch(recentSearchesProvider);
    final categories = ref.watch(categoriesProvider);
    final nodes = switch (categories.asData?.value) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample ?? const [],
      _ => const <CategoryNode>[],
    };
    final needle = typed.toLowerCase();
    bool matches(String value) => value.toLowerCase().contains(needle);
    final seen = <String>{typed};
    final items = <_Suggestion>[_Suggestion(typed, _SuggestionKind.keyword)];
    void addAll(Iterable<String> values, _SuggestionKind kind) {
      for (final value in values) {
        if (matches(value) && seen.add(value)) {
          items.add(_Suggestion(value, kind));
        }
      }
    }

    addAll(recent, _SuggestionKind.history);
    addAll(_flatten(nodes).map((node) => node.name), _SuggestionKind.category);
    addAll(popularSearches, _SuggestionKind.popular);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      children: [
        const _Band(title: SearchStrings.relatedTitle),
        for (final item in items.take(12))
          _SuggestionRow(
            item: item,
            typed: typed,
            onTap: () => onPick(item.text),
            onFill: () => onFill(item.text),
          ),
        if (items.length == 1)
          Container(
            key: const ValueKey('suggestions-empty'),
            color: DooryColors.surface,
            padding: const EdgeInsetsDirectional.all(16),
            child: Text(
              SearchStrings.noSuggestionMatch,
              style: DooryTypography.label(context),
            ),
          ),
      ],
    );
  }

  static Iterable<CategoryNode> _flatten(List<CategoryNode> nodes) sync* {
    for (final node in nodes) {
      yield node;
      yield* _flatten(node.children);
    }
  }
}

/// 48 dp suggestion row: the row searches, the arrow only fills the field.
class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({
    required this.item,
    required this.typed,
    required this.onTap,
    required this.onFill,
  });

  final _Suggestion item;
  final String typed;
  final VoidCallback onTap;
  final VoidCallback onFill;

  @override
  Widget build(BuildContext context) {
    final tag = switch (item.kind) {
      _SuggestionKind.category => SearchStrings.categoryTag,
      _SuggestionKind.history => SearchStrings.keywordTag,
      _ => null,
    };
    return Material(
      color: DooryColors.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsetsDirectional.only(start: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: DooryColors.border)),
          ),
          child: Row(
            children: [
              Icon(switch (item.kind) {
                _SuggestionKind.history => Icons.history,
                _SuggestionKind.category => Icons.grid_view_outlined,
                _ => Icons.search,
              }, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: _Highlighted(text: item.text, needle: typed),
              ),
              if (tag != null)
                Text(
                  tag,
                  style: DooryTypography.cardMeta(context)
                      .copyWith(fontSize: 12, color: DooryColors.textMuted),
                ),
              IconButton(
                tooltip: SearchStrings.fillSuggestion,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 48,
                  height: 48,
                ),
                onPressed: onFill,
                icon: const Icon(
                  Icons.north_west,
                  size: 18,
                  color: DooryColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bolds the typed part of a suggestion, as Trendyol does.
class _Highlighted extends StatelessWidget {
  const _Highlighted({required this.text, required this.needle});

  final String text;
  final String needle;

  @override
  Widget build(BuildContext context) {
    final base = DooryTypography.body(context);
    final at = text.toLowerCase().indexOf(needle.toLowerCase());
    if (needle.isEmpty || at < 0) return Text(text, style: base);
    final bold = base.copyWith(fontWeight: FontWeight.w700);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, at), style: base),
          TextSpan(text: text.substring(at, at + needle.length), style: bold),
          TextSpan(text: text.substring(at + needle.length), style: base),
        ],
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.scroll});

  final String query;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProvider(query));
    final notifier = ref.read(searchProvider(query).notifier);
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 480) notifier.loadMore();
          return false;
        },
        child: CustomScrollView(
          controller: scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _FilterBar(query: query, state: state),
            ),
            ..._content(context, ref, state),
          ],
        ),
      ),
    );
  }

  /// Under «no results»: the home feed's featured (else latest) cards.
  /// Hidden when the home call fails or is only a demo sample.
  // BACKEND: AVAILABLE GET /home → featured, latest (not search-aware)
  List<Widget> _suggestedGrid(WidgetRef ref) {
    final home = ref.watch(homeProvider).asData?.value;
    if (home is! RepoOk<HomeContent>) return const [];
    final items = home.data.featured.isNotEmpty
        ? home.data.featured
        : home.data.latest;
    if (items.isEmpty) return const [];
    return [ProductGridSliver(items: items)];
  }

  List<Widget> _content(
    BuildContext context,
    WidgetRef ref,
    SearchState state,
  ) {
    final notifier = ref.read(searchProvider(query).notifier);
    final notes = <Widget>[
      if (state.degraded) const _Note(text: DooryStrings.degraded),
      if (state.priceRangeError)
        _Note(
          text: DooryStrings.invalidRange,
          color: DooryTokens.of(context).danger,
        ),
      if (state.sample) const _Note(text: DooryStrings.resultsMayBeSample),
    ];
    final header = SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: notes,
      ),
    );
    if (state.loading && state.items.isEmpty) {
      return [header, const SliverToBoxAdapter(child: _ResultsSkeleton())];
    }
    if (state.failure == ListingFailure.rejected ||
        (state.failure == ListingFailure.unavailable && !state.sample)) {
      return [
        header,
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusMessage(
            title: state.message ?? DooryStrings.rejectedGeneric,
            actionLabel: DooryStrings.retry,
            onAction: notifier.refresh,
          ),
        ),
      ];
    }
    if (state.isEmptyResult) {
      return [
        header,
        SliverToBoxAdapter(child: _NoResults(query: query)),
        ..._suggestedGrid(ref),
      ];
    }
    return [
      header,
      ProductGridSliver(items: state.items),
      if (state.loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }
}

/// Horizontal row of filter chips: «الفرز», «فلترة» (price), category facets.
class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.query, required this.state});

  final String query;
  final SearchState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchProvider(query).notifier);
    final priced = state.minPrice != null || state.maxPrice != null;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DooryColors.border)),
      ),
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        children: [
          _FilterChip(
            icon: Icons.swap_vert,
            label: SearchStrings.sort,
            active: state.sort != ProductSort.newest,
            onTap: () async {
              final next = await showSortSheet(context, state.sort);
              if (next != null) await notifier.setSort(next);
            },
          ),
          _FilterChip(
            icon: Icons.tune,
            label: priced ? SearchStrings.priceChip : SearchStrings.filter,
            active: priced,
            onTap: () async {
              final result = await showPriceSheet(
                context,
                min: state.minPrice,
                max: state.maxPrice,
              );
              if (result == null) return;
              await notifier.applyPrice(
                result.cleared ? null : result.min,
                result.cleared ? null : result.max,
              );
            },
          ),
          for (final facet in state.facets)
            _FilterChip(
              label: DooryStrings.categoryFacet(
                facet.name ?? '${facet.id}',
                facet.count,
              ),
              active: state.categoryId == facet.id,
              onTap: () => notifier.toggleCategory(facet.id),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = active ? DooryColors.primary : DooryColors.textPrimary;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Semantics(
        button: true,
        selected: active,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: active ? DooryColors.primarySubtle : DooryColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: active ? DooryColors.primary : DooryColors.border,
              ),
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
                  style: DooryTypography.label(context).copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Text(
        text,
        style: DooryTypography.label(context).copyWith(color: color),
      ),
    );
  }
}

/// Four product-shaped placeholders (2:3 photo + text block) while loading.
class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final width = (constraints.maxWidth - gap * 3) / 2;
        return Padding(
          key: const ValueKey('search-results-skeleton'),
          padding: const EdgeInsetsDirectional.all(gap),
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (var i = 0; i < 4; i++)
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SkeletonBox(height: width * 1.5),
                      const SizedBox(height: 8),
                      const SkeletonBox(height: 94),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Trendyol's no-results note: an info strip; products follow below it.
class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          color: DooryColors.primarySubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              size: 24,
              color: DooryColors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                SearchStrings.noResultsFor(query),
                style: DooryTypography.body(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
