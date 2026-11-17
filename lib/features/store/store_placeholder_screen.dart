import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';

/// Phase 4 is out of scope. This screen still calls `/stores/{slug}` so a
/// missing store is a real not-found, and a live store shows its name.
class StorePlaceholderScreen extends ConsumerWidget {
  const StorePlaceholderScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(storeProvider(slug));
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.viewStore)),
      body: async.when(
        loading: () => const Padding(
          padding: EdgeInsetsDirectional.all(16),
          child: SkeletonBox(height: 120),
        ),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailable,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(storeProvider(slug)),
        ),
        data: (result) {
          final StoreModel? store = switch (result) {
            RepoOk<StoreModel>(:final data) => data,
            RepoUnavailable<StoreModel>(:final sample) => sample,
            _ => null,
          };
          if (result case RepoRejected<StoreModel>(:final message)) {
            return StatusMessage(
              title: message,
              actionLabel: DooryStrings.retry,
              onAction: () => ref.invalidate(storeProvider(slug)),
            );
          }
          if (result is RepoNotFound<StoreModel>) {
            return StatusMessage(
              title: DooryStrings.notFoundStore,
              actionLabel: DooryStrings.browseCategories,
              onAction: () => context.go('/categories'),
            );
          }
          if (store == null) {
            return StatusMessage(
              title: DooryStrings.unavailable,
              actionLabel: DooryStrings.retry,
              onAction: () => ref.invalidate(storeProvider(slug)),
            );
          }
          final shown = store;
          return ListView(
            padding: const EdgeInsetsDirectional.all(16),
            children: [
              if (shown.sample) const DemoLabel(),
              if (shown.sample) const SizedBox(height: 8),
              Text(shown.name ?? slug, style: DooryTypography.page(context)),
              if (shown.areaLabel != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${DooryStrings.area}: ${shown.areaLabel}',
                  style: DooryTypography.label(context),
                ),
              ],
              if (shown.description != null) ...[
                const SizedBox(height: 8),
                Text(shown.description!, style: DooryTypography.body(context)),
              ],
              if (shown.averageRating != null) ...[
                const SizedBox(height: 8),
                Text(
                  shown.averageRating!.toStringAsFixed(1),
                  style: DooryTypography.labelStrong(context),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                DooryStrings.storePlaceholder,
                style: DooryTypography.body(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
