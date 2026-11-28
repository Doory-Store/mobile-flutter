import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/category_avatar.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';

/// 3-column subcategory tiles plus a trailing «عرض الكل» tile.
///
/// When a child itself has children (depth 3, a proposal), each child is a
/// section header with its own grid.
class CategoryTileGrid extends StatelessWidget {
  const CategoryTileGrid({
    required this.root,
    required this.onOpen,
    this.loading = false,
    this.controller,
    super.key,
  });

  final CategoryNode? root;
  final ValueChanged<CategoryNode> onOpen;
  final bool loading;
  final ScrollController? controller;

  static const columns = 3;
  static const columnGap = 20.0;
  static const rowGap = 12.0;
  static const tileWidth = 77.0;
  static const imageHeight = 96.0;

  static double _extent(double width) {
    final tileW = (width - 32 - columnGap * (columns - 1)) / columns;
    return tileW * (imageHeight / tileWidth) + 4 + 28;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            controller: controller,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: columnGap,
              mainAxisSpacing: rowGap,
              mainAxisExtent: _extent(constraints.maxWidth),
            ),
            itemCount: 12,
            itemBuilder: (context, index) =>
                const SkeletonBox(height: imageHeight),
          );
        },
      );
    }
    final selected = root;
    if (selected == null) return const SizedBox.shrink();

    final depth3 = selected.children.any((child) => child.children.isNotEmpty);
    if (depth3) {
      return ListView(
        controller: controller,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
        children: [
          for (final child in selected.children) ...[
            _SectionHeader(node: child, onOpen: () => onOpen(child)),
            const SizedBox(height: 8),
            _TileWrap(
              children: [
                for (final grand in child.children)
                  CategoryTile(node: grand, onTap: () => onOpen(grand)),
                ShowAllCategoryTile(onTap: () => onOpen(child)),
              ],
            ),
            const SizedBox(height: 16),
          ],
          ShowAllCategoryTile(onTap: () => onOpen(selected)),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView(
          controller: controller,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: columnGap,
            mainAxisSpacing: rowGap,
            mainAxisExtent: _extent(constraints.maxWidth),
          ),
          children: [
            for (final child in selected.children)
              CategoryTile(node: child, onTap: () => onOpen(child)),
            ShowAllCategoryTile(onTap: () => onOpen(selected)),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.node, required this.onOpen});

  final CategoryNode node;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            node.name,
            style: DooryTypography.labelStrong(context)
                .copyWith(fontSize: 14, color: DooryColors.textPrimary),
          ),
        ),
        TextButton(
          onPressed: onOpen,
          child: Text(
            DooryStrings.viewAll,
            style: DooryTypography.labelStrong(context)
                .copyWith(color: DooryColors.primary),
          ),
        ),
      ],
    );
  }
}

class _TileWrap extends StatelessWidget {
  const _TileWrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: CategoryTileGrid.columns,
      crossAxisSpacing: CategoryTileGrid.columnGap,
      mainAxisSpacing: CategoryTileGrid.rowGap,
      // Taller than the photo so the two-line label fits.
      childAspectRatio:
          CategoryTileGrid.tileWidth / (CategoryTileGrid.imageHeight + 4 + 30),
      children: children,
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.node, required this.onTap, super.key});

  final CategoryNode node;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio:
                CategoryTileGrid.tileWidth / CategoryTileGrid.imageHeight,
            child: _TilePhoto(node: node),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              node.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: DooryTypography.family,
                fontSize: 11,
                height: 13 / 11,
                fontWeight: FontWeight.w400,
                color: DooryColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TilePhoto extends StatelessWidget {
  const _TilePhoto({required this.node});

  final CategoryNode node;

  @override
  Widget build(BuildContext context) {
    final url = node.imageUrl?.trim();
    final hasUrl = url != null && url.isNotEmpty;
    final fallback = CategoryAvatar(
      name: node.name,
      size: CategoryTileGrid.tileWidth,
      square: true,
      backgroundColor: DooryTokens.of(context).shortcutPastels.toneAt(node.id),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DooryColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(DooryTokens.of(context).radiusCard),
        border: Border.all(color: DooryColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DooryTokens.of(context).radiusCard),
        child: hasUrl
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: CategoryTileGrid.tileWidth,
                height: CategoryTileGrid.imageHeight,
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: (context, _) => fallback,
                errorWidget: (context, _, _) => fallback,
              )
            : fallback,
      ),
    );
  }
}

/// Four pastel squares and an orange chevron circle. Opens the root listing.
class ShowAllCategoryTile extends StatelessWidget {
  const ShowAllCategoryTile({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio:
                CategoryTileGrid.tileWidth / CategoryTileGrid.imageHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  DooryTokens.of(context).radiusCard,
                ),
                border: Border.all(color: DooryColors.border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: const [
                        _MiniSquare(),
                        _MiniSquare(),
                        _MiniSquare(),
                        _MiniSquare(),
                      ],
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: DooryColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.chevron_left,
                        size: 16,
                        color: DooryColors.textOnStrong,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              DooryStrings.viewAll,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: DooryTypography.family,
                fontSize: 11,
                height: 13 / 11,
                fontWeight: FontWeight.w400,
                color: DooryColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSquare extends StatelessWidget {
  const _MiniSquare();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DooryColors.primarySubtle,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
