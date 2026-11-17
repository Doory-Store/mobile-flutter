import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/routing/nav.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/product_thumb.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/mock/mock_fixtures.dart';
import '../../data/models/commerce_models.dart';
import '../auth/session_controller.dart';
import 'cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final summary = state.summary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          summary.itemCount > 0
              ? ShopStrings.cartTitleCount(summary.itemCount)
              : DooryStrings.tabCart,
        ),
        actions: [
          if (!summary.isEmpty)
            IconButton(
              tooltip: ShopStrings.clearCart,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () async {
                final ok = await confirmAction(
                  context,
                  title: ShopStrings.clearCartConfirm,
                  confirmLabel: ShopStrings.clearCart,
                  destructive: true,
                );
                if (ok) await ref.read(cartProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: state.loading
          ? const ListSkeleton(rows: 3, height: 120)
          : summary.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: ShopStrings.cartEmptyTitle,
              body: ShopStrings.cartEmptyBody,
              actionLabel: DooryStrings.browseCategories,
              onAction: () => context.go('/categories'),
            )
          : _CartBody(state: state),
      bottomNavigationBar: summary.isEmpty || state.loading
          ? null
          : _CheckoutBar(summary: summary),
    );
  }
}

class _CartBody extends ConsumerWidget {
  const _CartBody({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = state.summary;
    return ListView(
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      children: [
        if (state.sample) const MockBanner(message: ShopStrings.cartMockNote),
        const SizedBox(height: 12),
        _PromiseStrip(),
        for (final group in summary.groups)
          _StoreGroupCard(group: group, busy: state.busyLineIds),
        const _CouponCard(),
        SectionCard(
          title: ShopStrings.orderSummary,
          child: _Totals(summary: summary),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.storefront_outlined),
            label: const Text(DooryStrings.continueShopping),
          ),
        ),
      ],
    );
  }
}

class _PromiseStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: DooryColors.primaryStrong,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              MockFixtures.deliveryPromise,
              style: DooryTypography.label(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreGroupCard extends ConsumerWidget {
  const _StoreGroupCard({required this.group, required this.busy});

  final CartStoreGroup group;
  final Set<int> busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: group.storeSlug == null
                ? null
                : () => pushStore(context, group.storeSlug!),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.storefront, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group.storeName,
                      style: DooryTypography.labelStrong(context),
                    ),
                  ),
                  if (group.storeSlug != null)
                    const Icon(Icons.chevron_left, size: 20),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          for (final line in group.lines)
            _LineRow(line: line, busy: busy.contains(line.id)),
          const Divider(height: 1),
          const SizedBox(height: 8),
          MoneyRow(
            label: ShopStrings.storeSubtotal,
            amount: group.itemsTotalSyp,
          ),
          MoneyRow(
            label: ShopStrings.deliveryFee,
            amount: group.deliveryFeeSyp,
          ),
        ],
      ),
    );
  }
}

class _LineRow extends ConsumerWidget {
  const _LineRow({required this.line, required this.busy});

  final CartLine line;
  final bool busy;

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(cartProvider.notifier);
    final removed = await controller.remove(line.id);
    if (removed == null || !context.mounted) return;
    showToast(
      context,
      ShopStrings.removedFromCart,
      actionLabel: ShopStrings.undo,
      onAction: () => controller.restore(removed),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                pushProduct(context, line.productRef ?? '${line.productId}'),
            child: ProductThumb(url: line.photoUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DooryTypography.cardTitle(context),
                ),
                if (line.optionLabel != null)
                  Text(
                    line.optionLabel!,
                    style: DooryTypography.cardMeta(context),
                  ),
                const SizedBox(height: 4),
                if (line.priceSyp != null)
                  Text(
                    ShopStrings.unitPrice(formatSyp(line.priceSyp!)),
                    style: DooryTypography.cardMeta(context),
                  ),
                if (line.priceIsEstimate)
                  Text(
                    DooryStrings.estimate,
                    style: DooryTypography.cardMeta(context),
                  ),
                if (!line.purchasable)
                  Text(
                    line.available
                        ? DooryStrings.cannotPurchase
                        : DooryStrings.soldOut,
                    style: DooryTypography.label(context)
                        .copyWith(color: DooryColors.danger),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QuantityStepper(
                      compact: true,
                      value: line.quantity,
                      onChanged: (value) => ref
                          .read(cartProvider.notifier)
                          .setQuantity(line.id, value),
                      onRemove: () => _remove(context, ref),
                    ),
                    if (busy) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                    const Spacer(),
                    if (line.lineTotalSyp != null)
                      Text(
                        formatSyp(line.lineTotalSyp!),
                        style: DooryTypography.compactPrice(context),
                      ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: DooryStrings.remove,
            color: tokens.onSurfaceVariant,
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => _remove(context, ref),
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends ConsumerStatefulWidget {
  const _CouponCard();

  @override
  ConsumerState<_CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends ConsumerState<_CouponCard> {
  final _controller = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await ref
        .read(cartProvider.notifier)
        .applyCoupon(_controller.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
    if (error == null) {
      _controller.clear();
      showToast(context, ShopStrings.couponApplied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final coupons = ref.watch(
      cartProvider.select((state) => state.summary.coupons),
    );
    return SectionCard(
      title: ShopStrings.coupon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _apply(),
                  decoration: InputDecoration(
                    hintText: ShopStrings.couponHint,
                    errorText: _error,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _busy ? null : _apply,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(DooryStrings.apply),
                ),
              ),
            ],
          ),
          if (coupons.isEmpty) ...[
            const SizedBox(height: 6),
            Text(
              ShopStrings.couponDemoHint(MockFixtures.couponCode),
              style: DooryTypography.cardMeta(context),
            ),
          ],
          for (final coupon in coupons)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 8),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: InputChip(
                  avatar: const Icon(Icons.local_offer_outlined, size: 18),
                  label: Text(
                    '${coupon.code} · −${formatSyp(coupon.discountSyp)}',
                  ),
                  onDeleted: () =>
                      ref.read(cartProvider.notifier).removeCoupon(coupon.code),
                  deleteButtonTooltipMessage: ShopStrings.removeCoupon,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.summary});

  final CartSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MoneyRow(label: ShopStrings.itemsTotal, amount: summary.itemsTotalSyp),
        if (summary.discountTotalSyp > 0)
          MoneyRow(
            label: ShopStrings.discount,
            amount: summary.discountTotalSyp,
            negative: true,
          ),
        MoneyRow(
          label: ShopStrings.deliveryFeeStores(summary.storeCount),
          amount: summary.deliveryFeeTotalSyp,
        ),
        const Divider(),
        MoneyRow(
          label: ShopStrings.grandTotal,
          amount: summary.grandTotalSyp,
          strong: true,
        ),
        if (summary.hasUnpricedLines)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 8),
            child: Text(
              ShopStrings.unpricedNote,
              style: DooryTypography.cardMeta(context),
            ),
          ),
        if (summary.hasBlockedLines)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 8),
            child: Text(
              ShopStrings.blockedNote,
              style: DooryTypography.label(context)
                  .copyWith(color: DooryColors.danger),
            ),
          ),
      ],
    );
  }
}

class _CheckoutBar extends ConsumerWidget {
  const _CheckoutBar({required this.summary});

  final CartSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(sessionProvider.select((s) => s.signedIn));
    return Material(
      color: DooryColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: DooryColors.border)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ShopStrings.grandTotal,
                      style: DooryTypography.cardMeta(context),
                    ),
                    Text(
                      summary.grandTotalSyp == null
                          ? DooryStrings.toBeDetermined
                          : formatSyp(summary.grandTotalSyp!),
                      style: DooryTypography.compactPrice(context),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: summary.canCheckout
                    ? () => context.push(
                        signedIn ? '/checkout' : '/login?next=/checkout',
                      )
                    : () => showToast(
                        context,
                        summary.hasBlockedLines
                            ? ShopStrings.blockedNote
                            : ShopStrings.unpricedNote,
                      ),
                child: const Text(ShopStrings.proceedToCheckout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
