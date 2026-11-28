import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/routing/nav.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import 'category_rail.dart';
import 'category_tile_grid.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({this.initialSlug, super.key});

  /// Root to select first. A child slug selects its root; an unknown or null
  /// slug selects the first root.
  final String? initialSlug;

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _gridScroll = ScrollController();
  int? _selectedId;

  @override
  void dispose() {
    _gridScroll.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(categoriesProvider);
    await ref.read(categoriesProvider.future);
  }

  static CategoryNode? _rootForSlug(List<CategoryNode> roots, String? slug) {
    if (slug == null || slug.isEmpty) return null;
    bool contains(CategoryNode node) =>
        node.slug == slug || node.children.any(contains);
    for (final root in roots) {
      if (contains(root)) return root;
    }
    return null;
  }

  void _select(CategoryNode node) {
    setState(() => _selectedId = node.id);
    if (_gridScroll.hasClients) _gridScroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        leadingWidth: 48,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: SearchStrings.back,
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: DooryColors.textPrimary,
          ),
        ),
        title: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: DoorySearchField(
            readOnly: true,
            onTap: () => pushSearch(context),
            showCamera: true,
            onCameraTap: () => showNotWired(
              context,
              feature: SearchStrings.visualSearchFeature,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: async.when(
          loading: () => const _CategoriesBody(loading: true),
          error: (error, stack) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              StatusMessage(
                title: DooryStrings.unavailable,
                actionLabel: DooryStrings.retry,
                onAction: _refresh,
              ),
            ],
          ),
          data: (result) {
            final nodes = switch (result) {
              RepoOk<List<CategoryNode>>(:final data) => data,
              RepoUnavailable<List<CategoryNode>>(:final sample) =>
                sample ?? const [],
              _ => const <CategoryNode>[],
            };
            if (result is RepoRejected<List<CategoryNode>> ||
                (result is RepoUnavailable<List<CategoryNode>> &&
                    nodes.isEmpty)) {
              final message = result is RepoRejected<List<CategoryNode>>
                  ? result.message
                  : DooryStrings.unavailable;
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  StatusMessage(
                    title: message,
                    actionLabel: DooryStrings.retry,
                    onAction: _refresh,
                  ),
                ],
              );
            }
            if (nodes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  StatusMessage(title: DooryStrings.emptyCategories),
                ],
              );
            }
            final selectedId =
                _selectedId ??
                _rootForSlug(nodes, widget.initialSlug)?.id ??
                nodes.first.id;
            final selected =
                nodes.where((n) => n.id == selectedId).firstOrNull ??
                nodes.first;
            return _CategoriesBody(
              roots: nodes,
              selected: selected,
              sample: result is RepoUnavailable<List<CategoryNode>>,
              onSelect: _select,
              gridController: _gridScroll,
            );
          },
        ),
      ),
    );
  }
}

class _CategoriesBody extends StatelessWidget {
  const _CategoriesBody({
    this.roots = const [],
    this.selected,
    this.onSelect,
    this.loading = false,
    this.sample = false,
    this.gridController,
  });

  final List<CategoryNode> roots;
  final CategoryNode? selected;
  final ValueChanged<CategoryNode>? onSelect;
  final bool loading;
  final bool sample;
  final ScrollController? gridController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CategoryRail(
          roots: roots,
          selectedId: selected?.id,
          onSelect: onSelect ?? (_) {},
          loading: loading,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (sample)
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                  child: DemoLabel(),
                ),
              Expanded(
                child: CategoryTileGrid(
                  root: selected,
                  loading: loading,
                  controller: gridController,
                  onOpen: (node) => pushCategory(context, node.slug),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
