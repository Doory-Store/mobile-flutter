import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../data/favorites/favorites_controller.dart';
import '../listing/catalog_widgets.dart';
import '../shell/tab_signal.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabReselectProvider, (previous, next) {
      if (next.tab != 2 || !_scroll.hasClients) return;
      _scroll.jumpTo(0);
    });
    final items = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.tabFavorites)),
      body: items.isEmpty
          ? ComingSoonBody(
              title: DooryStrings.tabFavorites,
              body: DooryStrings.favoritesBody,
              onBrowse: () => context.go('/categories'),
            )
          : CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      12,
                      16,
                      8,
                    ),
                    child: Text(
                      DooryStrings.favoritesLocalNote,
                      style: DooryTypography.label(context),
                    ),
                  ),
                ),
                ProductGridSliver(items: items),
              ],
            ),
    );
  }
}
