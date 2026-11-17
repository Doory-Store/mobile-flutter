import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/doory_strings.dart';
import '../notifications/notification_bell.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/product_shelf.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import '../shell/tab_signal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(homeProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(metaStatusProvider);
    await ref.read(homeProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabReselectProvider, (previous, next) {
      if (next.tab != 0 || !_scroll.hasClients) return;
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

    final home = ref.watch(homeProvider);
    final categories = ref.watch(categoriesProvider);
    final status = ref.watch(metaStatusProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        actions: const [NotificationBell()],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DooryStrings.appName,
              style: DooryTypography.wordmark(context),
            ),
            const SizedBox(height: 8),
            DoorySearchField(
              controller: _search,
              onSubmitted: (value) => pushSearch(context, value),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: home.when(
          loading: () => const _HomeSkeleton(),
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
          data: (result) => _HomeBody(
            scroll: _scroll,
            result: result,
            categories: categories,
            maintenance: status,
            onRetry: _refresh,
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.scroll,
    required this.result,
    required this.categories,
    required this.maintenance,
    required this.onRetry,
  });

  final ScrollController scroll;
  final RepoResult<HomeContent> result;
  final AsyncValue<RepoResult<List<CategoryNode>>> categories;
  final ServiceStatus? maintenance;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final content = switch (result) {
      RepoOk<HomeContent>(:final data) => data,
      RepoUnavailable<HomeContent>(:final sample) => sample,
      _ => null,
    };
    final sample = result is RepoUnavailable<HomeContent> && content != null;
    final failed = content == null;

    return ListView(
      controller: scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (maintenance != null && maintenance!.maintenanceActive)
          MaintenanceBanner(
            message: (maintenance!.maintenanceMessageAr ?? '').isEmpty
                ? DooryStrings.maintenanceFallback
                : maintenance!.maintenanceMessageAr!,
          ),
        if (failed)
          StatusMessage(
            title: switch (result) {
              RepoRejected<HomeContent>(:final message) => message,
              _ => DooryStrings.unavailable,
            },
            actionLabel: DooryStrings.retry,
            onAction: () => onRetry(),
          )
        else ...[
          if (sample)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DemoLabel(),
                  const SizedBox(height: 8),
                  Text(
                    DooryStrings.resultsMayBeSample,
                    style: DooryTypography.label(context),
                  ),
                  TextButton(
                    onPressed: () => onRetry(),
                    child: const Text(DooryStrings.retry),
                  ),
                ],
              ),
            ),
          if (content.deliveryMessage != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      content.deliveryMessage!,
                      style: DooryTypography.labelStrong(context),
                    ),
                  ),
                  if (sample) const DemoLabel(),
                ],
              ),
            ),
          const SizedBox(height: 8),
          _CategoryRail(categories: categories),
          ProductShelf(
            title: DooryStrings.featured,
            products: content.featured,
            sample: sample,
          ),
          ProductShelf(
            title: DooryStrings.latest,
            products: content.latest,
            sample: sample,
          ),
          if (content.recentlyViewed.isNotEmpty)
            ProductShelf(
              title: DooryStrings.recentlyViewed,
              products: content.recentlyViewed,
              sample: sample,
            ),
          if (sample) const _DemoMosaic(),
          _PopularCategories(categories: categories),
          const _About(),
          const _Footer(),
        ],
      ],
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.categories});

  final AsyncValue<RepoResult<List<CategoryNode>>> categories;

  @override
  Widget build(BuildContext context) {
    final nodes = switch (categories.asData?.value) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample ?? const [],
      _ => const <CategoryNode>[],
    };
    if (categories.isLoading && nodes.isEmpty) {
      return const Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
        child: SkeletonBox(height: 88),
      );
    }
    if (nodes.isEmpty) return const SizedBox.shrink();
    final pastels = DooryTokens.of(context).shortcutPastels;
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        itemCount: nodes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final node = nodes[index];
          return SizedBox(
            width: 88,
            child: InkWell(
              onTap: () => pushCategory(context, node.slug),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: pastels.toneAt(index),
                      shape: BoxShape.circle,
                      border: Border.all(color: pastels.border),
                    ),
                    child: Text(
                      node.name.characters.first,
                      style: DooryTypography.section(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    node.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: DooryTypography.shortcut(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PopularCategories extends StatelessWidget {
  const _PopularCategories({required this.categories});

  final AsyncValue<RepoResult<List<CategoryNode>>> categories;

  @override
  Widget build(BuildContext context) {
    final nodes = switch (categories.asData?.value) {
      RepoOk<List<CategoryNode>>(:final data) => data,
      RepoUnavailable<List<CategoryNode>>(:final sample) => sample ?? const [],
      _ => const <CategoryNode>[],
    };
    if (nodes.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DooryStrings.popularCategories,
            style: DooryTypography.shelf(context),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final node in nodes)
                ActionChip(
                  label: Text(node.name),
                  onPressed: () => pushCategory(context, node.slug),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DemoMosaic extends StatelessWidget {
  const _DemoMosaic();

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DemoLabel(),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final ink in tokens.tileInks.take(2))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: AspectRatio(
                      aspectRatio: 2.4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: ink,
                          borderRadius: BorderRadius.circular(
                            tokens.radiusCard,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            DooryStrings.demo,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: DooryTypography.family,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _About extends StatelessWidget {
  const _About();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DooryStrings.aboutTitle,
            style: DooryTypography.section(context),
          ),
          const SizedBox(height: 8),
          Text(DooryStrings.aboutBody, style: DooryTypography.body(context)),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return ColoredBox(
      color: tokens.footerBand,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        child: Text(
          DooryStrings.footer,
          style: DooryTypography.label(context)
              .copyWith(color: tokens.footerBandText),
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.all(16),
      children: const [
        SkeletonBox(height: 44, radius: 20),
        SizedBox(height: 16),
        SkeletonBox(height: 88),
        SizedBox(height: 16),
        SkeletonBox(height: 220),
        SizedBox(height: 12),
        SkeletonBox(height: 220),
      ],
    );
  }
}
