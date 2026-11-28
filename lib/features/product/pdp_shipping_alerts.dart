import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/pdp_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../account/local_preferences.dart';
import 'pdp_mock.dart';
import 'pdp_sheets.dart';
import 'pdp_widgets.dart';

TextStyle _strong(BuildContext context, {Color? color}) =>
    DooryTypography.labelStrong(context)
        .copyWith(color: color ?? DooryColors.textPrimary);

TextStyle _body(BuildContext context, {Color? color}) =>
    DooryTypography.label(context).copyWith(
      fontWeight: FontWeight.w400,
      color: color ?? DooryColors.textPrimary,
    );

/// Shipping, Doory commitments and returns in one card.
class PdpShippingInfoCard extends StatelessWidget {
  const PdpShippingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const PdpBlock(
      padding: EdgeInsetsDirectional.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ShippingHeader(),
          PdpSectionDivider(),
          _PaymentChips(),
          PdpSectionDivider(),
          _CommitmentsSection(),
          PdpSectionDivider(),
          _ReturnRow(),
        ],
      ),
    );
  }
}

class _ShippingHeader extends StatelessWidget {
  const _ShippingHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: DooryColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  PdpStrings.shippingTitle,
                  style: _strong(context, color: DooryColors.success),
                ),
              ),
              const DemoLabel(),
              const Icon(Icons.chevron_left, color: DooryColors.success),
            ],
          ),
          const SizedBox(height: 4),
          // BACKEND: MISSING delivery partners per product/city
          Text.rich(
            TextSpan(
              style: _body(context, color: DooryColors.backendMissing),
              children: [
                TextSpan(
                  text: '${PdpStrings.deliveryPartners}: ',
                  style: _strong(context, color: DooryColors.backendMissing),
                ),
                TextSpan(text: PdpMock.deliveryPartners.join(' • ')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentChips extends StatelessWidget {
  const _PaymentChips();

  @override
  Widget build(BuildContext context) {
    // BACKEND: MISSING buyer payment-methods list
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10, bottom: 12),
      child: SizedBox(
        height: 64,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          itemCount: PdpMock.paymentMessages.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return Container(
              width: 168,
              height: 64,
              padding: const EdgeInsetsDirectional.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: index.isEven
                      ? DooryColors.tileViolet
                      : DooryColors.primary,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.chevron_left,
                    size: 12,
                    color: DooryColors.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      PdpMock.paymentMessages[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _body(context, color: DooryColors.backendMissing),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CommitmentsSection extends StatelessWidget {
  const _CommitmentsSection();

  @override
  Widget build(BuildContext context) {
    // BACKEND: MISSING Doory commitments copy (no API field).
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: DooryColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  PdpStrings.commitmentsTitle,
                  style: _strong(context, color: DooryColors.success),
                ),
              ),
              const Icon(Icons.chevron_left, color: DooryColors.success),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommitmentsSubCard(
                title: PdpStrings.safeShopping,
                items: const [PdpStrings.securePayment, PdpStrings.privacy],
              ),
              const SizedBox(width: 10),
              _CommitmentsSubCard(
                title: PdpStrings.safeDelivery,
                items: const [
                  PdpStrings.lostRefund,
                  PdpStrings.inspectOnDelivery,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommitmentsSubCard extends StatelessWidget {
  const _CommitmentsSubCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
          color: DooryColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: _strong(context, color: DooryColors.backendMissing),
            ),
            const SizedBox(height: 4),
            for (final item in items)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: DooryColors.backendMissing,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item,
                        style: _body(
                          context,
                          color: DooryColors.backendMissing,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReturnRow extends StatelessWidget {
  const _ReturnRow();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPdpReturnSheet(context),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
        child: Row(
          children: [
            const Icon(
              Icons.assignment_return_outlined,
              size: 20,
              color: DooryColors.success,
            ),
            const SizedBox(width: 8),
            Text(
              PdpStrings.freeReturn,
              style: _strong(context, color: DooryColors.success),
            ),
            const SizedBox(width: 8),
            // BACKEND: MISSING per-store return policy
            Expanded(
              child: Text(
                PdpMock.returnSummary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _body(context, color: DooryColors.backendMissing),
              ),
            ),
            const Icon(Icons.chevron_left),
          ],
        ),
      ),
    );
  }
}

Future<void> toggleStockWatch(
  BuildContext context,
  WidgetRef ref,
  int productId,
) async {
  final now = await ref
      .read(localIdSetProvider(stockWatchesKey).notifier)
      .toggle('$productId');
  if (context.mounted) {
    showToast(
      context,
      now ? PdpStrings.stockWatchOn : PdpStrings.stockWatchOff,
    );
  }
}

/// Price-drop and back-in-stock alerts, kept on the device.
class PdpAlertsCard extends ConsumerWidget {
  const PdpAlertsCard({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = '$productId';
    final priceOn = ref.watch(localIdSetProvider(priceWatchesKey)).contains(id);
    final stockOn = ref.watch(localIdSetProvider(stockWatchesKey)).contains(id);
    return PdpBlock(
      padding: EdgeInsetsDirectional.zero,
      child: Column(
        children: [
          // BACKEND: AVAILABLE POST /product-watches {product_id, price_drop}
          // (auth). Watch flags are not on GET /products/{id}. On-device only.
          _PdpAlertRow(
            icon: Icons.trending_down,
            title: PdpStrings.priceDropAlert,
            value: priceOn,
            onChanged: () => _toggle(
              context,
              ref,
              key: priceWatchesKey,
              id: id,
              onText: ShopStrings.priceWatchOn,
              offText: ShopStrings.priceWatchOff,
            ),
          ),
          const PdpSectionDivider(),
          // BACKEND: AVAILABLE POST /product-watches {product_id, back_in_stock}
          // (auth). Watch flags are not on GET /products/{id}. On-device only.
          _PdpAlertRow(
            icon: Icons.notifications_active_outlined,
            title: PdpStrings.backInStockAlert,
            value: stockOn,
            onChanged: () => toggleStockWatch(context, ref, productId),
          ),
        ],
      ),
    );
  }
}

class _PdpAlertRow extends StatelessWidget {
  const _PdpAlertRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 12, 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: DooryColors.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: _strong(context))),
              Switch(
                value: value,
                onChanged: (_) => onChanged(),
                activeTrackColor: DooryColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _toggle(
  BuildContext context,
  WidgetRef ref, {
  required String key,
  required String id,
  required String onText,
  required String offText,
}) async {
  final now = await ref.read(localIdSetProvider(key).notifier).toggle(id);
  if (context.mounted) showToast(context, now ? onText : offText);
}
