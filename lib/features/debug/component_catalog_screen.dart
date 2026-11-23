import 'package:material_ui/material_ui.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_tokens.dart';
import '../../core/widgets/bottom_tab_bar.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/doory_app_bar.dart';
import '../../core/widgets/doory_button.dart';
import '../../core/widgets/doory_chip.dart';
import '../../core/widgets/doory_image.dart';
import '../../core/widgets/doory_sheet.dart';
import '../../core/widgets/doory_wordmark.dart';
import '../../core/widgets/group_card.dart';
import '../../core/widgets/list_row.dart';
import '../../core/widgets/price_block.dart';
import '../../core/widgets/product_cards.dart';
import '../../core/widgets/rating_row.dart';
import '../../core/widgets/screen_states.dart';
import '../../core/widgets/search_pill.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/ui_kit.dart' hide EmptyState, showDoorySheet;

/// Debug review of every P0 component. Absent from release builds.
class ComponentCatalogScreen extends StatelessWidget {
  const ComponentCatalogScreen({super.key});

  static const listKey = Key('catalog-list');
  static const cardsKey = Key('catalog-cards');
  static const sheetKey = Key('catalog-sheet');

  @override
  Widget build(BuildContext context) {
    final canvas = DooryTokens.of(context).surfaceCanvas;
    return Scaffold(
      backgroundColor: canvas,
      appBar: DooryAppBar(
        title: DooryStrings.catalogTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        key: listKey,
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: DemoLabel(),
            ),
          ),
          const _Block(
            title: 'الشعار',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DooryWordmark(),
                SizedBox(height: 8),
                DooryWordmark(size: DooryWordmarkSize.display),
              ],
            ),
          ),
          const _Block(
            title: 'البحث',
            child: Column(
              children: [
                SearchPill(),
                SearchPill(mode: SearchPillMode.summary, text: 'بيجاما | 24'),
                SearchPill(mode: SearchPillMode.active, text: 'قميص'),
                SearchPill(enabled: false),
              ],
            ),
          ),
          _Block(
            title: 'الأزرار',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final size in DooryButtonSize.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 8),
                    child: DooryButton(
                      label: 'متابعة',
                      size: size,
                      expanded: true,
                      onPressed: () => showNotWired(context),
                    ),
                  ),
                for (final variant in const [
                  DooryButtonVariant.outline,
                  DooryButtonVariant.secondary,
                  DooryButtonVariant.text,
                ])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 8),
                    child: DooryButton(
                      label: 'متابعة',
                      variant: variant,
                      expanded: variant != DooryButtonVariant.text,
                      onPressed: () => showNotWired(context),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 8),
                  child: DooryButton(label: 'متابعة', expanded: true),
                ),
                DooryButton(
                  label: 'متابعة',
                  expanded: true,
                  loading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          _Block(
            key: cardsKey,
            title: 'البطاقتان',
            horizontal: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 193.5,
                      child: ProductCardVertical(
                        ref: '1001-cotton-shirt',
                        brand: 'نور',
                        name: 'قميص قطني بأكمام طويلة قماش ناعم',
                        image: 'assets/mock/products/1001.jpg',
                        priceSyp: 125000,
                        compareAtSyp: 150000,
                        rating: 4.4,
                        ratingCount: 2009,
                        colorCount: 3,
                        onFavorite: _noop,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 193.5,
                      child: ProductCardVertical(
                        ref: '1006-shoulder-bag',
                        brand: 'سوق حمص',
                        name: 'حقيبة كتف',
                        image: 'assets/mock/products/1006.jpg',
                        priceSyp: 64000,
                        available: false,
                        favorite: true,
                        sample: true,
                        onFavorite: _noop,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 480,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      ProductCardRail(
                        ref: '1002-day-dress',
                        brand: 'بيت الورد',
                        name: 'فستان يومي',
                        image: 'assets/mock/products/1002.jpg',
                        priceSyp: 89000,
                      ),
                      SizedBox(width: 8),
                      ProductCardRail(
                        ref: '1003-trainers',
                        brand: 'سوق حمص',
                        name: 'حذاء رياضي خفيف',
                        image: 'assets/mock/products/1003.jpg',
                        priceSyp: 210000,
                        compareAtSyp: 240000,
                        rating: 4,
                        ratingCount: 18,
                      ),
                      SizedBox(width: 8),
                      ProductCardRail(
                        ref: '1005-wool-blanket',
                        brand: 'بيت الورد',
                        name: 'بطانية صوف',
                        image: 'assets/mock/products/1005.jpg',
                        priceSyp: 75000,
                        estimate: true,
                        rating: 4.8,
                        ratingCount: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _Block(
            title: 'السعر والتقييم',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PriceBlock(priceSyp: 125000),
                SizedBox(height: 8),
                PriceBlock(priceSyp: 125000, compareAtSyp: 150000),
                SizedBox(height: 8),
                PriceBlock(priceSyp: 75000, estimate: true),
                SizedBox(height: 8),
                PriceBlock(priceSyp: null),
                SizedBox(height: 8),
                RatingRow(rating: 4.4, count: 2009),
                SizedBox(height: 8),
                RatingRow(rating: 4.4),
              ],
            ),
          ),
          const _Block(
            title: 'الحبات',
            child: Wrap(
              spacing: 8,
              children: [
                DooryChip(label: 'قطن'),
                DooryChip(label: 'قطن', selected: true),
                DooryChip(label: 'قطن', enabled: false),
              ],
            ),
          ),
          _Block(
            title: 'الصفوف',
            child: Column(
              children: [
                ListRow(title: 'طلباتي', onTap: () => showNotWired(context)),
                ListRow(
                  title: 'الماركة',
                  value: 'نور',
                  onTap: () => showNotWired(context),
                ),
                ListRow(
                  title: 'الأنسب',
                  trailing: ListRowTrailing.radio,
                  selected: true,
                  showDivider: true,
                  onTap: () {},
                ),
                ListRow(
                  title: 'الأعلى سعراً',
                  trailing: ListRowTrailing.radio,
                  onTap: () {},
                ),
                const ListRow(
                  title: 'معطّل',
                  enabled: false,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const GroupCard(
            title: 'نظرة عامة',
            children: [
              ListRow(
                title: 'طلباتي',
                density: ListRowDensity.edge,
                leading: Icons.inventory_2_outlined,
              ),
              ListRow(
                title: 'تقييماتي',
                density: ListRowDensity.compact,
                leading: Icons.star_outline,
              ),
              ListRow(
                title: 'عناويني',
                density: ListRowDensity.edge,
                leading: Icons.location_on_outlined,
                showDivider: false,
              ),
            ],
          ),
          _Block(
            title: 'الرأس',
            child: Column(
              children: [
                SectionHeader(
                  title: 'وصل حديثاً',
                  actionLabel: DooryStrings.seeAll,
                  onAction: _noop,
                  gutter: SectionGutter.regular,
                ),
                SectionHeader(title: 'مختارات', gutter: SectionGutter.regular),
              ],
            ),
          ),
          _Block(
            key: sheetKey,
            title: 'الورقة',
            child: DooryButton(
              label: 'الفرز',
              expanded: true,
              onPressed: () => _openSort(context),
            ),
          ),
          _Block(
            title: 'الفراغ والخطأ',
            child: Column(
              children: [
                SizedBox(
                  height: 420,
                  child: EmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'سلة مشترياتك',
                    message: 'أضف ما يعجبك من المتاجر، ويظهر هنا.',
                    actionLabel: DooryStrings.continueShopping,
                    onAction: _noop,
                  ),
                ),
                SizedBox(
                  height: 420,
                  child: ErrorState(
                    message: 'تحقق من الشبكة ثم أعد المحاولة.',
                    onRetry: _noop,
                  ),
                ),
                SizedBox(
                  height: 420,
                  child: ErrorState(
                    message: 'تحقق من الشبكة ثم أعد المحاولة.',
                    onRetry: _noop,
                    retrying: true,
                  ),
                ),
              ],
            ),
          ),
          const _Block(
            title: 'الهيكل',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonProductCard(),
                SizedBox(height: 12),
                SkeletonListRow(),
                SizedBox(height: 12),
                SkeletonChip(),
              ],
            ),
          ),
          _Block(
            title: 'الشريط',
            child: Column(
              children: [
                BottomTabBar(current: DooryTab.home, onSelect: _ignoreTab),
                SizedBox(height: 12),
                BottomTabBar(
                  current: DooryTab.home,
                  cartCount: 3,
                  onSelect: _ignoreTab,
                ),
                SizedBox(height: 12),
                BottomTabBar(
                  current: DooryTab.cart,
                  cartCount: 120,
                  onSelect: _ignoreTab,
                ),
              ],
            ),
          ),
          const _Block(
            title: 'الصورة',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: DooryImage(source: 'assets/mock/products/1001.jpg'),
                ),
                SizedBox(width: 8),
                SizedBox(width: 120, child: DooryImage()),
                SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: DooryImage(source: 'assets/mock/products/missing.jpg'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _noop() {}

  static void _ignoreTab(DooryTab tab) {}

  Future<void> _openSort(BuildContext context) {
    const options = [
      'الأنسب',
      'الأكثر مبيعاً',
      'المفضلة',
      'وصل حديثاً',
      'الأكثر تقييمًا',
      'الأعلى سعراً',
      'الأقل سعراً',
    ];
    return showDoorySheet(
      context: context,
      title: 'الفرز',
      child: Column(
        children: [
          for (var index = 0; index < options.length; index++)
            ListRow(
              title: options[index],
              trailing: ListRowTrailing.radio,
              selected: index == 0,
              showDivider: index != options.length - 1,
              onTap: () => Navigator.of(context).maybePop(),
            ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.title,
    required this.child,
    this.horizontal = 16,
    super.key,
  });

  final String title;
  final Widget child;
  final double horizontal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title, gutter: SectionGutter.regular),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            horizontal,
            0,
            horizontal,
            16,
          ),
          child: child,
        ),
      ],
    );
  }
}
