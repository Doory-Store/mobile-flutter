import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_providers.dart';
import '../account/account_providers.dart';
import 'checkout_screen.dart';

/// Sample confirmation plus the payment step (amount due, method steps,
/// receiving account, transaction reference).
class OrderConfirmationScreen extends ConsumerStatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  ConsumerState<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState
    extends ConsumerState<OrderConfirmationScreen> {
  final _reference = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(lastCheckoutProvider);
    final method = ref.watch(lastPaymentMethodProvider);
    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: ShopStrings.noRecentOrder,
          actionLabel: ShopStrings.myOrders,
          onAction: () => context.pushReplacement('/orders'),
        ),
      );
    }
    final guide = ref.watch(paymentGuideProvider).asData?.value ?? const [];
    final selected = guide.where((item) => item.method == method).firstOrNull;
    final account = method == null
        ? null
        : ref.read(checkoutRepositoryProvider).receivingAccounts[method];

    return Scaffold(
      appBar: AppBar(
        title: const Text(ShopStrings.orderCreated),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: DooryStrings.close,
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          if (result.sample)
            const MockBanner(message: ShopStrings.confirmationMockNote),
          const SizedBox(height: 16),
          const Icon(Icons.check_circle, size: 72, color: DooryColors.success),
          const SizedBox(height: 8),
          Text(
            ShopStrings.orderCreatedTitle,
            textAlign: TextAlign.center,
            style: DooryTypography.page(context),
          ),
          const SizedBox(height: 4),
          Text(
            ShopStrings.orderNumber(result.shortId),
            textAlign: TextAlign.center,
            style: DooryTypography.label(context),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: ShopStrings.amountDue,
            trailing: const StatusPill(
              label: 'بانتظار الدفع',
              tone: PillTone.brand,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  result.grandTotalSyp == null
                      ? DooryStrings.toBeDetermined
                      : formatSyp(result.grandTotalSyp!),
                  style: DooryTypography.pdpPrice(context),
                ),
                if (result.expiresAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    ShopStrings.payWithin(
                      result.expiresAt!.difference(DateTime.now()).inHours + 1,
                    ),
                    style: DooryTypography.label(context),
                  ),
                ],
                if (result.deliveryPromise != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    result.deliveryPromise!,
                    style: DooryTypography.cardMeta(context),
                  ),
                ],
              ],
            ),
          ),
          SectionCard(
            title: ShopStrings.storeOrders,
            child: Column(
              children: [
                for (final order in result.storeOrders)
                  _StoreOrderRow(order: order),
              ],
            ),
          ),
          if (selected != null)
            SectionCard(
              title: ShopStrings.payWith(selected.label),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < selected.steps.length; i++)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 6),
                        child: Text(
                          '${i + 1}. ${selected.steps[i]}',
                          style: DooryTypography.body(context),
                        ),
                      ),
                    if (account != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          12,
                          4,
                          4,
                          4,
                        ),
                        decoration: BoxDecoration(
                          color: DooryColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ShopStrings.receivingAccount,
                                    style: DooryTypography.cardMeta(context),
                                  ),
                                  Text(
                                    account,
                                    textDirection: TextDirection.ltr,
                                    style: DooryTypography.labelStrong(context),
                                  ),
                                ],
                              ),
                            ),
                            const DemoLabel(),
                            IconButton(
                              tooltip: ShopStrings.copy,
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: account),
                                );
                                if (context.mounted) {
                                  showToast(context, ShopStrings.copied);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    DooryTextField(
                      label: ShopStrings.transactionReference,
                      controller: _reference,
                      hint: ShopStrings.transactionReferenceHint,
                      textDirection: TextDirection.ltr,
                      validator: (value) =>
                          (value == null || value.trim().length < 4)
                          ? ShopStrings.referenceInvalid
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DooryPrimaryButton(
                      label: ShopStrings.confirmPayment,
                      onPressed: () {
                        if (!(_form.currentState?.validate() ?? false)) return;
                        showNotWired(
                          context,
                          feature: ShopStrings.submitPaymentFeature,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Column(
              children: [
                DooryOutlineButton(
                  label: ShopStrings.cancelOrder,
                  icon: Icons.cancel_outlined,
                  onPressed: () => showNotWired(
                    context,
                    feature: ShopStrings.cancelCheckoutFeature,
                  ),
                ),
                const SizedBox(height: 8),
                DooryOutlineButton(
                  label: ShopStrings.myOrders,
                  icon: Icons.receipt_long_outlined,
                  onPressed: () => context.pushReplacement('/orders'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text(DooryStrings.continueShopping),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreOrderRow extends StatelessWidget {
  const _StoreOrderRow({required this.order});

  final CheckoutStoreOrder order;

  @override
  Widget build(BuildContext context) {
    final total = order.itemsTotalSyp == null
        ? null
        : order.itemsTotalSyp! + (order.deliveryFeeSyp ?? 0);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.storefront_outlined),
      title: Text(order.storeName),
      subtitle: Text(OrderStatus.label(order.status)),
      trailing: Text(
        total == null ? DooryStrings.toBeDetermined : formatSyp(total),
        style: DooryTypography.labelStrong(context),
      ),
    );
  }
}
