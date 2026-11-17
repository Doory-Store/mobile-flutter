import 'package:material_ui/material_ui.dart';

import '../../core/format/date_format.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';

String orderFilterLabel(OrderFilter filter) => switch (filter) {
  OrderFilter.all => ShopStrings.filterAll,
  OrderFilter.awaitingPayment => ShopStrings.filterAwaitingPayment,
  OrderFilter.inProgress => ShopStrings.filterInProgress,
  OrderFilter.onTheWay => ShopStrings.filterOnTheWay,
  OrderFilter.delivered => ShopStrings.filterDelivered,
  OrderFilter.closed => ShopStrings.filterClosed,
};

class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({required this.status, this.label, super.key});

  final String status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final tone = OrderStatus.isClosed(status)
        ? PillTone.danger
        : OrderStatus.isDone(status)
        ? PillTone.success
        : status == 'pending_payment' || status == 'payment_pending_review'
        ? PillTone.brand
        : PillTone.info;
    return StatusPill(label: label ?? OrderStatus.label(status), tone: tone);
  }
}

/// Vertical timeline over the happy path, with reached steps stamped.
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({required this.status, required this.history, super.key});

  final String status;
  final List<OrderStatusChange> history;

  @override
  Widget build(BuildContext context) {
    if (OrderStatus.isClosed(status)) {
      return Column(
        children: [
          for (final change in history)
            _Step(
              label: change.toLabel,
              time: formatDateTime(change.at),
              reached: true,
              current: change == history.last,
              last: change == history.last,
              danger: OrderStatus.isClosed(change.toStatus),
            ),
        ],
      );
    }
    final reachedAt = <String, DateTime?>{
      for (final change in history) change.toStatus: change.at,
    };
    final currentIndex = OrderStatus.flow.indexOf(
      status == 'completed' ? 'delivered' : status,
    );
    return Column(
      children: [
        for (var i = 0; i < OrderStatus.flow.length; i++)
          _Step(
            label: OrderStatus.label(OrderStatus.flow[i]),
            time: formatDateTime(reachedAt[OrderStatus.flow[i]]),
            reached: currentIndex >= i,
            current: currentIndex == i,
            last: i == OrderStatus.flow.length - 1,
          ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.label,
    required this.time,
    required this.reached,
    required this.current,
    required this.last,
    this.danger = false,
  });

  final String label;
  final String time;
  final bool reached;
  final bool current;
  final bool last;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? DooryColors.danger
        : reached
        ? DooryColors.primaryStrong
        : DooryColors.border;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: current ? 18 : 14,
                  height: current ? 18 : 14,
                  margin: const EdgeInsetsDirectional.only(top: 4),
                  decoration: BoxDecoration(
                    color: reached ? color : DooryColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: reached && !current
                      ? const Icon(
                          Icons.check,
                          size: 10,
                          color: DooryColors.textOnStrong,
                        )
                      : null,
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: reached ? color : DooryColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: current
                        ? DooryTypography.labelStrong(context)
                        : DooryTypography.label(context).copyWith(
                            color: reached ? null : DooryColors.textMuted,
                          ),
                  ),
                  if (time.isNotEmpty)
                    Text(time, style: DooryTypography.cardMeta(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
