import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum ListRowDensity { regular, compact, edge }

enum ListRowTrailing { chevron, radio, none }

/// List row at 56, 42, or 52 dp. The chevron points to the inline end.
class ListRow extends StatelessWidget {
  const ListRow({
    required this.title,
    this.value,
    this.density = ListRowDensity.regular,
    this.leading,
    this.trailing = ListRowTrailing.chevron,
    this.selected = false,
    this.showDivider = true,
    this.enabled = true,
    this.titleColor,
    this.onTap,
    super.key,
  });

  final String title;
  final String? value;
  final ListRowDensity density;
  final IconData? leading;
  final ListRowTrailing trailing;
  final bool selected;
  final bool showDivider;
  final bool enabled;
  final Color? titleColor;
  final VoidCallback? onTap;

  double get _height {
    return switch (density) {
      ListRowDensity.regular => 56,
      ListRowDensity.compact => 42,
      ListRowDensity.edge => 52,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final twoLine = value != null && density == ListRowDensity.regular;
    final titleStyle =
        (twoLine
                ? DooryTypography.rowLabelStrong(context)
                : DooryTypography.rowLabel(context))
            .copyWith(
              color: !enabled
                  ? tokens.textMuted
                  : titleColor ?? scheme.onSurface,
            );
    final label = value == null || value!.isEmpty ? title : '$title، $value';
    return Semantics(
      button: true,
      enabled: enabled,
      checked: trailing == ListRowTrailing.radio ? selected : null,
      inMutuallyExclusiveGroup: trailing == ListRowTrailing.radio,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: scheme.surface,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: showDivider
                  ? Border(bottom: DooryBorders.hairline(scheme.outline))
                  : null,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: _height),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: twoLine ? 8 : 0,
                ),
                child: Row(
                  children: [
                    if (leading != null) ...[
                      Icon(
                        leading,
                        size: DooryIconSize.inline,
                        color: enabled ? scheme.primary : tokens.textMuted,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                          if (twoLine)
                            Text(
                              value!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DooryTypography.caption(context),
                            ),
                        ],
                      ),
                    ),
                    if (!twoLine && value != null && value!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(value!, style: DooryTypography.caption(context)),
                    ],
                    if (enabled && trailing == ListRowTrailing.chevron) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        size: DooryIconSize.chevron,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                    if (trailing == ListRowTrailing.radio) ...[
                      const SizedBox(width: 8),
                      _RadioMark(selected: selected),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? scheme.primary : Colors.transparent,
        border: selected ? null : Border.all(color: scheme.outline),
      ),
      child: SizedBox(
        width: 22,
        height: 22,
        child: selected
            ? Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.onPrimary,
                  ),
                  child: const SizedBox(width: 8, height: 8),
                ),
              )
            : null,
      ),
    );
  }
}
