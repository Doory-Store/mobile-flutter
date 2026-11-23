import 'package:material_ui/material_ui.dart';

import '../format/cart_badge.dart';
import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum DooryTab { home, categories, favorites, cart, account }

/// Five equal tabs. 56 dp, then the bottom safe area. No indicator pill.
class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    required this.current,
    required this.onSelect,
    this.cartCount = 0,
    super.key,
  });

  final DooryTab current;
  final ValueChanged<DooryTab> onSelect;
  final int cartCount;

  static const _items = <_TabSpec>[
    _TabSpec(
      DooryTab.home,
      DooryStrings.tabHome,
      Icons.home_outlined,
      Icons.home,
    ),
    _TabSpec(
      DooryTab.categories,
      DooryStrings.tabCategories,
      Icons.grid_view_outlined,
      Icons.grid_view,
    ),
    _TabSpec(
      DooryTab.favorites,
      DooryStrings.tabFavorites,
      Icons.favorite_border,
      Icons.favorite,
    ),
    _TabSpec(
      DooryTab.cart,
      DooryStrings.tabCart,
      Icons.shopping_cart_outlined,
      Icons.shopping_cart,
    ),
    _TabSpec(
      DooryTab.account,
      DooryStrings.tabAccount,
      Icons.person_outline,
      Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: DooryBorders.hairline(scheme.outline)),
        boxShadow: DooryShadows.bar(tokens.shadowCard),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              for (final item in _items)
                Expanded(
                  child: _TabCell(
                    spec: item,
                    selected: item.tab == current,
                    badge: item.tab == DooryTab.cart
                        ? cartBadgeLabel(cartCount)
                        : null,
                    cartCount: cartCount,
                    onTap: () => onSelect(item.tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.tab, this.label, this.icon, this.selectedIcon);

  final DooryTab tab;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _TabCell extends StatelessWidget {
  const _TabCell({
    required this.spec,
    required this.selected,
    required this.onTap,
    required this.cartCount,
    this.badge,
  });

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = DooryTokens.of(context);
    final color = selected ? scheme.primary : scheme.onSurface;
    final label = spec.tab == DooryTab.cart
        ? DooryStrings.cartTabLabel(cartCount)
        : spec.label;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        splashColor: tokens.primarySubtle,
        highlightColor: tokens.primarySubtle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    selected ? spec.selectedIcon : spec.icon,
                    size: DooryIconSize.chrome,
                    color: color,
                  ),
                  if (badge != null)
                    PositionedDirectional(
                      top: -6,
                      end: -4,
                      child: _CountBadge(label: badge!),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              spec.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DooryTypography.tabLabel(color),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 16,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: DooryTypography.badgeCount(scheme.onPrimary),
      ),
    );
  }
}
