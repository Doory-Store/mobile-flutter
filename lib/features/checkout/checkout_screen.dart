import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../../data/repositories/commerce/commerce_providers.dart';
import '../account/account_providers.dart';
import '../auth/session_controller.dart';
import '../cart/cart_controller.dart';

/// Payment method chosen at checkout, read by the confirmation screen.
final lastPaymentMethodProvider = StateProvider<String?>((ref) => null);

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  DeliveryMethod _method = DeliveryMethod.courier;
  int? _addressId;
  int? _pickupId;
  String _slotId = 'asap';
  String? _payment;
  final _notes = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  String? _missing(List<BuyerAddress> addresses) {
    if (_method == DeliveryMethod.courier) {
      final id = _addressId ?? _defaultAddress(addresses)?.id;
      if (id == null) return ShopStrings.chooseAddress;
    } else if (_pickupId == null) {
      return ShopStrings.choosePickup;
    }
    if (_payment == null) return ShopStrings.choosePayment;
    return null;
  }

  BuyerAddress? _defaultAddress(List<BuyerAddress> items) {
    if (items.isEmpty) return null;
    return items.firstWhere(
      (item) => item.isDefault,
      orElse: () => items.first,
    );
  }

  Future<void> _confirm(CartSummary cart, List<BuyerAddress> addresses) async {
    final missing = _missing(addresses);
    if (missing != null) {
      showToast(context, missing);
      return;
    }
    final preview = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.link_off, color: DooryColors.primaryStrong),
        title: const Text(DooryStrings.notWiredTitle),
        content: const Text(ShopStrings.placeOrderNotWired),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(DooryStrings.close),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(ShopStrings.showSampleConfirmation),
          ),
        ],
      ),
    );
    if (preview != true || !mounted) return;
    setState(() => _busy = true);
    final result = await ref
        .read(checkoutRepositoryProvider)
        .previewCheckout(
          CheckoutDraft(
            method: _method,
            paymentMethod: _payment!,
            addressId: _addressId ?? _defaultAddress(addresses)?.id,
            pickupPointId: _pickupId,
            slotId: _slotId,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          ),
          cart,
        );
    if (!mounted) return;
    ref.read(lastCheckoutProvider.notifier).state = result;
    ref.read(lastPaymentMethodProvider.notifier).state = _payment;
    setState(() => _busy = false);
    context.pushReplacement('/order-confirmation');
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider).summary;
    final session = ref.watch(sessionProvider);
    final addresses = ref.watch(addressesProvider);
    final addressList = addresses.asData?.value ?? const <BuyerAddress>[];
    final pickup = _method == DeliveryMethod.pickup;
    final deliveryTotal = pickup ? 0 : cart.deliveryFeeTotalSyp;
    final items = cart.itemsTotalSyp;
    final grand = items == null || cart.hasUnpricedLines
        ? null
        : items - cart.discountTotalSyp + deliveryTotal;

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(ShopStrings.checkout)),
        body: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: ShopStrings.cartEmptyTitle,
          actionLabel: DooryStrings.continueShopping,
          onAction: () => context.go('/'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.checkout)),
      body: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          const MockBanner(message: ShopStrings.checkoutMockNote),
          const SizedBox(height: 12),
          SectionCard(
            title: ShopStrings.receiveMethod,
            child: SegmentedButton<DeliveryMethod>(
              segments: const [
                ButtonSegment(
                  value: DeliveryMethod.courier,
                  icon: Icon(Icons.delivery_dining_outlined),
                  label: Text(ShopStrings.homeDelivery),
                ),
                ButtonSegment(
                  value: DeliveryMethod.pickup,
                  icon: Icon(Icons.store_mall_directory_outlined),
                  label: Text(ShopStrings.pickupPoint),
                ),
              ],
              selected: {_method},
              onSelectionChanged: (value) =>
                  setState(() => _method = value.first),
            ),
          ),
          if (!pickup)
            SectionCard(
              title: ShopStrings.deliveryAddress,
              trailing: TextButton.icon(
                onPressed: () => context.push('/addresses/new'),
                icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                label: const Text(ShopStrings.addAddress),
              ),
              child: addresses.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text(DooryStrings.unavailable),
                data: (items) => items.isEmpty
                    ? Text(
                        ShopStrings.noAddresses,
                        style: DooryTypography.label(context),
                      )
                    : RadioGroup<int>(
                        groupValue: _addressId ?? _defaultAddress(items)?.id,
                        onChanged: (value) =>
                            setState(() => _addressId = value),
                        child: Column(
                          children: [
                            for (final address in items)
                              RadioListTile<int>(
                                value: address.id,
                                contentPadding: EdgeInsets.zero,
                                title: Text(address.title),
                                subtitle: Text(address.summary),
                              ),
                          ],
                        ),
                      ),
              ),
            )
          else
            SectionCard(
              title: ShopStrings.pickupPoint,
              child: ref
                  .watch(pickupPointsProvider)
                  .when(
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stack) => Text(DooryStrings.unavailable),
                    data: (points) => RadioGroup<int>(
                      groupValue: _pickupId,
                      onChanged: (value) => setState(() => _pickupId = value),
                      child: Column(
                        children: [
                          for (final point in points)
                            RadioListTile<int>(
                              value: point.id,
                              contentPadding: EdgeInsets.zero,
                              title: Text(point.name),
                              subtitle: Text(
                                '${point.address}\n${point.hours}',
                              ),
                              isThreeLine: true,
                            ),
                        ],
                      ),
                    ),
                  ),
            ),
          SectionCard(
            title: pickup ? ShopStrings.pickupTime : ShopStrings.deliveryTime,
            child: ref
                .watch(deliverySlotsProvider)
                .when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stack) => Text(DooryStrings.unavailable),
                  data: (slots) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final slot in slots)
                        ChoiceChip(
                          label: Text(slot.label),
                          selected: _slotId == slot.id,
                          onSelected: (_) => setState(() => _slotId = slot.id),
                        ),
                    ],
                  ),
                ),
          ),
          SectionCard(
            title: ShopStrings.paymentMethod,
            child: ref
                .watch(paymentGuideProvider)
                .when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stack) => Text(DooryStrings.unavailable),
                  data: (methods) => RadioGroup<String>(
                    groupValue: _payment,
                    onChanged: (value) => setState(() => _payment = value),
                    child: Column(
                      children: [
                        for (final method in methods)
                          _PaymentOption(
                            method: method,
                            expanded: _payment == method.method,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          ShopStrings.paymentAfterOrder,
                          style: DooryTypography.cardMeta(context),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          SectionCard(
            title: ShopStrings.contact,
            child: Row(
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.user?.name ?? ShopStrings.guest,
                        style: DooryTypography.labelStrong(context),
                      ),
                      if (session.user != null)
                        Text(
                          formatPhone(session.user!.phone),
                          style: DooryTypography.label(context),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await ref.read(sessionProvider.notifier).signOut();
                    if (context.mounted) {
                      context.pushReplacement('/login?next=/checkout');
                    }
                  },
                  child: const Text(ShopStrings.notYou),
                ),
              ],
            ),
          ),
          SectionCard(
            title: ShopStrings.notes,
            child: TextField(
              controller: _notes,
              maxLines: 3,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: ShopStrings.notesHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SectionCard(
            title: ShopStrings.orderReview,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final group in cart.groups) ...[
                  Text(
                    group.storeName,
                    style: DooryTypography.labelStrong(context),
                  ),
                  for (final line in group.lines)
                    InfoRow(
                      label:
                          '${line.productName}${line.optionLabel == null ? '' : ' · ${line.optionLabel}'} × ${line.quantity}',
                      value: line.lineTotalSyp == null
                          ? DooryStrings.toBeDetermined
                          : formatSyp(line.lineTotalSyp!),
                    ),
                  const SizedBox(height: 8),
                ],
                const Divider(),
                MoneyRow(label: ShopStrings.itemsTotal, amount: items),
                if (cart.discountTotalSyp > 0)
                  MoneyRow(
                    label: ShopStrings.discount,
                    amount: cart.discountTotalSyp,
                    negative: true,
                  ),
                MoneyRow(
                  label: pickup
                      ? ShopStrings.pickupFee
                      : ShopStrings.deliveryFeeStores(cart.storeCount),
                  amount: deliveryTotal,
                ),
                const Divider(),
                MoneyRow(
                  label: ShopStrings.grandTotal,
                  amount: grand,
                  strong: true,
                ),
                const SizedBox(height: 8),
                Text(
                  ShopStrings.policyNote,
                  style: DooryTypography.cardMeta(context),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: DooryColors.surface,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: DooryColors.border)),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
          child: SafeArea(
            top: false,
            child: DooryPrimaryButton(
              label: grand == null
                  ? ShopStrings.placeOrder
                  : '${ShopStrings.placeOrder} · ${formatSyp(grand)}',
              busy: _busy,
              onPressed: grand == null
                  ? null
                  : () => _confirm(cart, addressList),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({required this.method, required this.expanded});

  final PaymentMethodGuide method;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RadioListTile<String>(
          value: method.method,
          contentPadding: EdgeInsets.zero,
          title: Text(method.label),
          secondary: const Icon(Icons.account_balance_wallet_outlined),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: expanded
              ? Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < method.steps.length; i++)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 4),
                          child: Text(
                            '${i + 1}. ${method.steps[i]}',
                            style: DooryTypography.label(context),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
