import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../shell/tab_signal.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(categoriesProvider);
    await ref.read(categoriesProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabReselectProvider, (previous, next) {
      if (next.tab != 1 || !_scroll.hasClients) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _scroll.jumpTo(0);
      } else {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
    final async = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.browseCategories)),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: async.when(
          loading: () => ListView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.all(16),
            children: const [
              SkeletonBox(height: 56),
              SizedBox(height: 8),
              SkeletonBox(height: 56),
              SizedBox(height: 8),
              SkeletonBox(height: 56),
            ],
          ),
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
            final sample =
                result is RepoUnavailable<List<CategoryNode>> &&
                nodes.isNotEmpty;
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
            return ListView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsetsDirectional.only(bottom: 24),
              children: [
                if (sample)
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
                    child: DemoLabel(),
                  ),
                for (final node in nodes) _CategoryTile(node: node, depth: 0),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({required this.node, required this.depth});

  final CategoryNode node;
  final int depth;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final node = widget.node;
    final hasChildren = node.children.isNotEmpty;
    return Column(
      children: [
        InkWell(
          onTap: () => pushCategory(context, node.slug),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: 16 + widget.depth * 16,
                end: 8,
                top: 8,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.shortcutPastels.toneAt(node.id),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      node.name.characters.first,
                      style: DooryTypography.labelStrong(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      node.name,
                      style: DooryTypography.body(context),
                    ),
                  ),
                  if (hasChildren)
                    IconButton(
                      tooltip: _open
                          ? DooryStrings.collapse
                          : DooryStrings.expand,
                      onPressed: () => setState(() => _open = !_open),
                      icon: Icon(_open ? Icons.expand_less : Icons.expand_more),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_open)
          for (final child in node.children)
            _CategoryTile(node: child, depth: widget.depth + 1),
      ],
    );
  }
}
