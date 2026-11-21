import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/date_format.dart';
import '../../core/format/price_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../account/account_providers.dart';
import 'order_widgets.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  OrderFilter _filter = OrderFilter.all;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.myOrders)),
      body: Column(
        children: [
          const MockBanner(),
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                for (final filter in OrderFilter.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(orderFilterLabel(filter)),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const ListSkeleton(height: 110),
              error: (error, stack) => StatusMessage(
                title: DooryStrings.unavailable,
                actionLabel: DooryStrings.retry,
                onAction: () => ref.invalidate(ordersProvider),
              ),
              data: (orders) {
                final shown = [
                  for (final order in orders)
                    if (_filter.matches(order.status)) order,
                ];
                if (shown.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: _filter == OrderFilter.all
                        ? ShopStrings.noOrders
                        : ShopStrings.noOrdersInFilter,
                    body: ShopStrings.noOrdersBody,
                    actionLabel: DooryStrings.browseCategories,
                    onAction: () => context.go('/categories'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(ordersProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsetsDirectional.only(
                      top: 4,
                      bottom: 24,
                    ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) =>
                        _OrderCard(order: shown[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderListItem order;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/orders/${order.publicId}'),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.storeName,
                      style: DooryTypography.labelStrong(context),
                    ),
                  ),
                  OrderStatusPill(
                    status: order.status,
                    label: order.statusLabel,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${ShopStrings.orderNumber(order.shortId)} · ${formatRelative(order.createdAt)}',
                style: DooryTypography.cardMeta(context),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.deliveryPromise ?? '',
                      style: DooryTypography.cardMeta(context),
                    ),
                  ),
                  if (order.totalSyp != null)
                    Text(
                      formatSyp(order.totalSyp!),
                      style: DooryTypography.compactPrice(context),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
