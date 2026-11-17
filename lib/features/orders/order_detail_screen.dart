import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/date_format.dart';
import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../account/account_providers.dart';
import '../cart/cart_controller.dart';
import 'order_widgets.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.publicId, super.key});

  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(orderDetailProvider(publicId));
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.orderDetails)),
      body: async.when(
        loading: () => const ListSkeleton(rows: 3, height: 140),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailable,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(orderDetailProvider(publicId)),
        ),
        data: (order) => order == null
            ? StatusMessage(
                title: ShopStrings.orderNotFound,
                actionLabel: ShopStrings.myOrders,
                onAction: () => context.pushReplacement('/orders'),
              )
            : _Body(order: order),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.order});

  final OrderDetail order;

  Future<void> _reorder(BuildContext context, WidgetRef ref) async {
    final added = await ref.read(cartProvider.notifier).reorder(order);
    if (!context.mounted) return;
    showToast(
      context,
      ShopStrings.reordered(added),
      actionLabel: ShopStrings.viewCart,
      onAction: () => context.go('/cart'),
    );
  }

  Future<void> _requestCancel(BuildContext context) async {
    final reason = await showDoorySheet<String>(
      context,
      title: ShopStrings.cancelReasonTitle,
      builder: (context) => const _ReasonPicker(),
    );
    if (reason == null || !context.mounted) return;
    await showNotWired(context, feature: ShopStrings.cancelRequestFeature);
  }

  Future<void> _rate(BuildContext context) async {
    final submitted = await showDoorySheet<bool>(
      context,
      title: ShopStrings.rateOrder,
      builder: (context) => _RatingSheet(storeName: order.summary.storeName),
    );
    if (submitted == true && context.mounted) {
      await showNotWired(context, feature: ShopStrings.reviewFeature);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = order.summary;
    final status = summary.status;
    return ListView(
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      children: [
        const MockBanner(),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      summary.storeName,
                      style: DooryTypography.section(context),
                    ),
                  ),
                  OrderStatusPill(status: status, label: summary.statusLabel),
                ],
              ),
              const SizedBox(height: 8),
              InfoRow(label: ShopStrings.orderNo, value: summary.shortId),
              InfoRow(
                label: ShopStrings.orderDate,
                value: formatDateTime(summary.createdAt),
              ),
              if (order.paymentMethodLabel != null)
                InfoRow(
                  label: ShopStrings.paymentMethod,
                  value: order.paymentMethodLabel!,
                ),
              if (order.addressSummary != null)
                InfoRow(
                  label: ShopStrings.deliveryAddress,
                  value: order.addressSummary!,
                ),
              if (summary.deliveryPromise != null &&
                  OrderStatus.isActive(status))
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 18,
                        color: DooryColors.primaryStrong,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          summary.deliveryPromise!,
                          style: DooryTypography.label(context),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SectionCard(
          title: ShopStrings.orderTracking,
          child: OrderTimeline(status: status, history: order.history),
        ),
        SectionCard(
          title: ShopStrings.orderItems,
          child: Column(
            children: [
              for (final line in order.lines)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.productName,
                              style: DooryTypography.cardTitle(context),
                            ),
                            Text(
                              [
                                if (line.optionLabel != null) line.optionLabel!,
                                '× ${line.quantity}',
                                if (line.unitPriceSyp != null)
                                  formatSyp(line.unitPriceSyp!),
                              ].join(' · '),
                              style: DooryTypography.cardMeta(context),
                            ),
                          ],
                        ),
                      ),
                      if (line.lineTotalSyp != null)
                        Text(
                          formatSyp(line.lineTotalSyp!),
                          style: DooryTypography.labelStrong(context),
                        ),
                    ],
                  ),
                ),
              const Divider(),
              MoneyRow(
                label: ShopStrings.itemsTotal,
                amount: summary.itemsTotalSyp,
              ),
              MoneyRow(
                label: ShopStrings.deliveryFee,
                amount: summary.deliveryFeeSyp,
              ),
              MoneyRow(
                label: ShopStrings.grandTotal,
                amount: summary.totalSyp,
                strong: true,
              ),
            ],
          ),
        ),
        if (order.notes != null)
          SectionCard(
            title: ShopStrings.notes,
            child: Text(order.notes!, style: DooryTypography.body(context)),
          ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (status == 'pending_payment') ...[
                DooryPrimaryButton(
                  label: ShopStrings.payNow,
                  icon: Icons.payments_outlined,
                  onPressed: () => showNotWired(
                    context,
                    feature: ShopStrings.submitPaymentFeature,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (OrderStatus.isDone(status)) ...[
                DooryPrimaryButton(
                  label: ShopStrings.rateOrder,
                  icon: Icons.star_outline,
                  onPressed: () => _rate(context),
                ),
                const SizedBox(height: 8),
              ],
              DooryOutlineButton(
                label: ShopStrings.reorder,
                icon: Icons.replay,
                onPressed: () => _reorder(context, ref),
              ),
              const SizedBox(height: 8),
              if (OrderStatus.canRequestCancel(status)) ...[
                DooryOutlineButton(
                  label: ShopStrings.requestCancel,
                  icon: Icons.cancel_outlined,
                  onPressed: () => _requestCancel(context),
                ),
                const SizedBox(height: 8),
              ],
              if (OrderStatus.isDone(status)) ...[
                DooryOutlineButton(
                  label: ShopStrings.requestReturn,
                  icon: Icons.assignment_return_outlined,
                  onPressed: () =>
                      showNotWired(context, feature: ShopStrings.returnFeature),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => showNotWired(
                        context,
                        feature: ShopStrings.messageStoreFeature,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text(ShopStrings.messageStore),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.push(
                        '/support/new?order=${summary.publicId}',
                      ),
                      icon: const Icon(Icons.support_agent_outlined),
                      label: const Text(ShopStrings.helpWithOrder),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReasonPicker extends StatefulWidget {
  const _ReasonPicker();

  @override
  State<_ReasonPicker> createState() => _ReasonPickerState();
}

class _ReasonPickerState extends State<_ReasonPicker> {
  String? _reason;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioGroup<String>(
            groupValue: _reason,
            onChanged: (value) => setState(() => _reason = value),
            child: Column(
              children: [
                for (final reason in ShopStrings.cancelReasons)
                  RadioListTile<String>(
                    value: reason,
                    contentPadding: EdgeInsets.zero,
                    title: Text(reason),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          DooryPrimaryButton(
            label: ShopStrings.sendCancelRequest,
            onPressed: _reason == null
                ? null
                : () => Navigator.of(context).pop(_reason),
          ),
        ],
      ),
    );
  }
}

class _RatingSheet extends StatefulWidget {
  const _RatingSheet({required this.storeName});

  final String storeName;

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  int _stars = 0;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ShopStrings.rateStorePrompt(widget.storeName),
            style: DooryTypography.body(context),
          ),
          const SizedBox(height: 8),
          StarInput(
            value: _stars,
            onChanged: (value) => setState(() => _stars = value),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: ShopStrings.reviewHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          DooryPrimaryButton(
            label: ShopStrings.submitReview,
            onPressed: _stars == 0
                ? null
                : () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}

/// Five tappable stars.
class StarInput extends StatelessWidget {
  const StarInput({required this.value, required this.onChanged, super.key});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            tooltip: ShopStrings.starsLabel(i),
            iconSize: 36,
            onPressed: () => onChanged(i),
            icon: Icon(
              i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
              color: i <= value ? DooryColors.rating : DooryColors.border,
            ),
          ),
      ],
    );
  }
}
