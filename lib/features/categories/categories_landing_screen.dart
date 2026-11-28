import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/search_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../shell/tab_signal.dart';

/// Card fill. Not a token: closer to Trendyol than `surfaceSubtle`.
const _cardColor = Color(0xFFEEEEEE);

/// «كل الفئات»: the Categories tab root. Each card opens the rail page with
/// that root selected.
class CategoriesLandingScreen extends ConsumerStatefulWidget {
  const CategoriesLandingScreen({super.key});

  @override
  ConsumerState<CategoriesLandingScreen> createState() =>
      _CategoriesLandingScreenState();
}

class _CategoriesLandingScreenState
    extends ConsumerState<CategoriesLandingScreen> {
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
      backgroundColor: DooryColors.surface,
      appBar: AppBar(
        toolbarHeight: 56,
        titleSpacing: 8,
        title: DoorySearchField(
          readOnly: true,
          onTap: () => pushSearch(context),
          showCamera: true,
          onCameraTap: () =>
              showNotWired(context, feature: SearchStrings.visualSearchFeature),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: DooryColors.border),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: async.when(
          loading: () => _LandingScroll(controller: _scroll, loading: true),
          error: (error, stack) => _message(_retry(DooryStrings.unavailable)),
          data: _data,
        ),
      ),
    );
  }

  Widget _retry(String title) {
    return StatusMessage(
      title: title,
      actionLabel: DooryStrings.retry,
      onAction: _refresh,
    );
  }

  Widget _data(RepoResult<List<CategoryNode>> result) {
    final roots = switch (result) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) =>
        sample ?? const <CategoryNode>[],
      _ => const <CategoryNode>[],
    };
    if (result is RepoRejected<List<CategoryNode>>) {
      return _message(_retry(result.message));
    }
    if (result is RepoUnavailable<List<CategoryNode>> && roots.isEmpty) {
      return _message(_retry(DooryStrings.unavailable));
    }
    if (roots.isEmpty) {
      return _message(const StatusMessage(title: DooryStrings.emptyCategories));
    }
    return _LandingScroll(
      controller: _scroll,
      roots: roots,
      sample: result is RepoUnavailable<List<CategoryNode>>,
    );
  }

  Widget _message(Widget child) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [const _LandingHeader(), child],
    );
  }
}

class _LandingHeader extends StatelessWidget {
  const _LandingHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Semantics(
          header: true,
          child: const Text(
            DooryStrings.allCategories,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DooryColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _LandingScroll extends StatelessWidget {
  const _LandingScroll({
    required this.controller,
    this.roots = const [],
    this.loading = false,
    this.sample = false,
  });

  final ScrollController controller;
  final List<CategoryNode> roots;
  final bool loading;
  final bool sample;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: _LandingHeader()),
        if (sample)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: DemoLabel(),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 12,
              mainAxisExtent: CategoryLandingCard.height,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (loading) {
                return const SkeletonBox(height: CategoryLandingCard.height);
              }
              final node = roots[index];
              return CategoryLandingCard(
                node: node,
                onTap: () => pushCategoryBrowse(context, node.slug),
              );
            }, childCount: loading ? 8 : roots.length),
          ),
        ),
      ],
    );
  }
}

/// One «كل الفئات» card: title top-start, server photo bottom-end.
class CategoryLandingCard extends StatelessWidget {
  const CategoryLandingCard({
    required this.node,
    required this.onTap,
    this.showNewBadge = false,
    super.key,
  });

  final CategoryNode node;
  final VoidCallback onTap;

  /// «جديد» badge. Built but hidden: no flag on `GET /categories`.
  // BACKEND: MISSING category `is_new` / badge flag.
  final bool showNewBadge;

  static const height = 87.0;

  @override
  Widget build(BuildContext context) {
    final radius = DooryTokens.of(context).radiusCard;
    final url = node.imageUrl?.trim();
    final hasImage = url != null && url.isNotEmpty;
    return Semantics(
      button: true,
      label: node.name,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: _cardColor,
          child: InkWell(
            onTap: onTap,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final half = constraints.maxWidth / 2;
                return Stack(
                  children: [
                    // BACKEND: MISSING cut-out product art. GET /categories
                    // returns square photos only; crop + fades stand in.
                    if (hasImage)
                      PositionedDirectional(
                        end: 0,
                        bottom: 0,
                        width: half,
                        height: height,
                        child: _CardPhoto(url: url, showNewBadge: showNewBadge),
                      ),
                    PositionedDirectional(
                      start: 0,
                      top: 0,
                      width: half,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          10,
                          8,
                          8,
                          0,
                        ),
                        child: Text(
                          node.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            height: 18 / 14,
                            fontWeight: FontWeight.w700,
                            color: DooryColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CardPhoto extends StatelessWidget {
  const _CardPhoto({required this.url, required this.showNewBadge});

  final String url;
  final bool showNewBadge;

  static const _fadeClear = Color(0x00EEEEEE);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: (context, _) => const SizedBox.shrink(),
          // Missing or failed image: title only on the grey card.
          errorWidget: (context, _, _) =>
              const SizedBox.shrink(key: ValueKey('landing-card-no-image')),
        ),
        const PositionedDirectional(
          start: 0,
          top: 0,
          bottom: 0,
          width: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [_cardColor, _fadeClear],
              ),
            ),
          ),
        ),
        const PositionedDirectional(
          start: 0,
          end: 0,
          top: 0,
          height: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_cardColor, _fadeClear],
              ),
            ),
          ),
        ),
        if (showNewBadge)
          const PositionedDirectional(top: 4, end: 4, child: _NewBadge()),
      ],
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DooryColors.danger,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        DooryStrings.newBadge,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w700,
          color: DooryColors.textOnStrong,
        ),
      ),
    );
  }
}
