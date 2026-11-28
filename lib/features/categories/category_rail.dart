import 'package:material_ui/material_ui.dart';

import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../data/models/catalog_models.dart';

/// Top-level category rail on the start (right) edge. Width 108 dp.
class CategoryRail extends StatelessWidget {
  const CategoryRail({
    required this.roots,
    required this.selectedId,
    required this.onSelect,
    this.loading = false,
    super.key,
  });

  final List<CategoryNode> roots;
  final int? selectedId;
  final ValueChanged<CategoryNode> onSelect;
  final bool loading;

  static const width = 108.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: ListView.separated(
          padding: const EdgeInsetsDirectional.only(top: 5, start: 4, end: 0),
          itemCount: loading ? 7 : roots.length,
          separatorBuilder: (context, index) => const SizedBox(height: 2),
          itemBuilder: (context, index) {
            if (loading) {
              return const Padding(
                padding: EdgeInsetsDirectional.only(end: 4),
                child: SkeletonBox(height: 52),
              );
            }
            final node = roots[index];
            return CategoryRailItem(
              node: node,
              selected: node.id == selectedId,
              onTap: () => onSelect(node),
            );
          },
        ),
      ),
    );
  }
}

class CategoryRailItem extends StatelessWidget {
  const CategoryRailItem({
    required this.node,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final CategoryNode node;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = DooryTypography.labelStrong(context).copyWith(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w700,
      color: selected ? DooryColors.primary : DooryColors.textPrimary,
    );
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 104,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? null : DooryColors.surfaceSubtle,
            gradient: selected
                ? const LinearGradient(
                    begin: AlignmentDirectional.centerEnd,
                    end: AlignmentDirectional.centerStart,
                    colors: [Color(0xFFFFEEE2), Color(0xFFFFFFFF)],
                  )
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              if (selected)
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SizedBox(
                    width: 2,
                    height: 52,
                    child: ColoredBox(color: DooryColors.primary),
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    node.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: label,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
