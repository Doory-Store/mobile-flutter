import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routing/home_collection.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';
import 'catalog_widgets.dart';
import '../search/recommended_shelf.dart';
import 'listing_screen.dart';

/// Full listing behind a home shelf's «عرض الكل».
///
/// «وصل حديثًا» pages the whole catalog from `GET /products` (newest first),
/// with sort and price filters. «مختارات» and «شاهدته مؤخرًا» have no paged
/// endpoint, so they show every card the home feed returned for that shelf,
/// and open the full catalog when that shelf is empty.
class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({required this.collection, super.key});

  final HomeCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullCatalog = ListingScreen(
      slug: allProductsKey,
      title: collection.title,
    );
    if (collection == HomeCollection.latest) return fullCatalog;
    if (collection == HomeCollection.recommended) {
      return const RecommendedCollectionScreen();
    }

    final home = ref.watch(homeProvider);
    final content = switch (home.asData?.value) {
      RepoOk<HomeContent>(:final data) => data,
      RepoUnavailable<HomeContent>(:final sample) => sample,
      _ => null,
    };
    if (content == null && home.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(collection.title)),
        body: const Padding(
          padding: EdgeInsetsDirectional.all(16),
          child: SkeletonBox(height: 220),
        ),
      );
    }
    final items = switch (collection) {
      HomeCollection.featured => content?.featured,
      HomeCollection.recentlyViewed => content?.recentlyViewed,
      HomeCollection.latest => content?.latest,
      HomeCollection.recommended => null,
    };
    if (items == null || items.isEmpty) return fullCatalog;

    return Scaffold(
      appBar: AppBar(title: Text(collection.title)),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ProductGridSliver(items: items),
          SliverToBoxAdapter(
            child: SizedBox(height: 24 + MediaQuery.paddingOf(context).bottom),
          ),
        ],
      ),
    );
  }
}
