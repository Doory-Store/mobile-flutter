import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../account/account_providers.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(addressesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.myAddresses)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/addresses/new'),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text(ShopStrings.addAddress),
      ),
      body: async.when(
        loading: () => const ListSkeleton(),
        error: (error, stack) => StatusMessage(
          title: DooryStrings.unavailable,
          actionLabel: DooryStrings.retry,
          onAction: () => ref.invalidate(addressesProvider),
        ),
        data: (items) => items.isEmpty
            ? EmptyState(
                icon: Icons.location_off_outlined,
                title: ShopStrings.noAddresses,
                body: ShopStrings.noAddressesBody,
                actionLabel: ShopStrings.addAddress,
                onAction: () => context.push('/addresses/new'),
                demo: true,
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(addressesProvider.future),
                child: ListView(
                  padding: const EdgeInsetsDirectional.only(bottom: 96),
                  children: [
                    const MockBanner(),
                    const SizedBox(height: 12),
                    for (final address in items) _AddressCard(address: address),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});

  final BuyerAddress address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(addressesProvider.notifier);
    return SectionCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                address.label == 'العمل'
                    ? Icons.work_outline
                    : Icons.home_outlined,
                color: DooryColors.primaryStrong,
              ),
              const SizedBox(width: 8),
              Text(address.title, style: DooryTypography.labelStrong(context)),
              const SizedBox(width: 8),
              if (address.isDefault)
                const StatusPill(
                  label: ShopStrings.defaultAddress,
                  tone: PillTone.brand,
                ),
              const Spacer(),
              PopupMenuButton<String>(
                tooltip: ShopStrings.moreActions,
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      context.push('/addresses/${address.id}');
                    case 'default':
                      await controller.setDefault(address.id);
                      if (context.mounted) {
                        showToast(context, ShopStrings.defaultSet);
                      }
                    case 'delete':
                      final ok = await confirmAction(
                        context,
                        title: ShopStrings.deleteAddressConfirm,
                        confirmLabel: ShopStrings.delete,
                        destructive: true,
                      );
                      if (!ok) return;
                      await controller.delete(address.id);
                      if (context.mounted) {
                        showToast(context, ShopStrings.addressDeleted);
                      }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text(ShopStrings.edit),
                  ),
                  if (!address.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Text(ShopStrings.makeDefault),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(ShopStrings.delete),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(address.summary, style: DooryTypography.body(context)),
        ],
      ),
    );
  }
}
