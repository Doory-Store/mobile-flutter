import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_colors.dart';
import '../theme/doory_typography.dart';

/// − value + control. At [min] the decrement turns into a delete action when
/// [onRemove] is provided, so the last unit can leave the cart in one tap.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.onRemove,
    this.compact = false,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final VoidCallback? onRemove;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 44.0;
    final atMin = value <= min;
    final showDelete = atMin && onRemove != null;
    return Semantics(
      label: '${DooryStrings.quantity} $value',
      child: Container(
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: DooryColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepButton(
              size: size,
              icon: Icons.add,
              tooltip: DooryStrings.increase,
              onTap: value < max ? () => onChanged(value + 1) : null,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: compact ? 28 : 36),
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: DooryTypography.labelStrong(context),
              ),
            ),
            _StepButton(
              size: size,
              icon: showDelete ? Icons.delete_outline : Icons.remove,
              tooltip: showDelete ? DooryStrings.remove : DooryStrings.decrease,
              onTap: showDelete
                  ? onRemove
                  : atMin
                  ? null
                  : () => onChanged(value - 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.size,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: size / 2,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: 20,
            color: onTap == null
                ? DooryColors.textMuted
                : DooryColors.primaryStrong,
          ),
        ),
      ),
    );
  }
}
